//
//  SearchViewController.swift
//  MozAnalytics
//
//  Created by Andrews Jr, George on 9/15/15.
//  Copyright (c) 2015 Andrews Jr, George. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let keychainWrapper = KeychainWrapper()
    
    var accessID: String?
    var secretKey: String?
    var mozData: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.autocapitalizationType = .none
        
        // UISearchBarDelegate and UITableViewDataSource protocols 
        // are implemented in extensions below. The following 
        // two lines of code ensure we use them.
        searchBar.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 1. Check for credentials
        if UserDefaults.standard.bool(forKey: "hasCredentials") == false {
            // 2. No credentials, send to settings
            self.tabBarController?.selectedIndex = 2
        } else {
            accessID = UserDefaults.standard.value(forKey: "accessID") as? String
            secretKey = keychainWrapper.myObject(forKey: kSecValueData) as? String
        }
    }
    
    @IBAction func saveResult(_ sender: AnyObject) {
        
        if let mozData = mozData {
            
            // 1. Create new NSManagedObject
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            let mozResult = NSEntityDescription.insertNewObject(forEntityName: "MozResult", into: managedContext) as! MozResult
            
            // 2. Populate NSManagedObject
            mozResult.canonicalURL = mozData.value(forKey: ResponseField.URL.rawValue) as! String
            mozResult.mozRank = mozData.value(forKey: ResponseField.MOZ_RANK.rawValue) as! NSNumber
            mozResult.pageAuthority = mozData.value(forKey: ResponseField.PAGE_AUTHORITY.rawValue) as! NSNumber
            mozResult.domainAuthority = mozData.value(forKey: ResponseField.DOMAIN_AUTHORITY.rawValue) as! NSNumber
            mozResult.externalLinks = mozData.value(forKey: ResponseField.EXT_EQUITY_LINKS.rawValue) as! NSNumber
            
            // 3. Save NSManagedObject
            do {
                try managedContext.save()
                
                presentAlert(title: "Success", message: "Your data has been saved...")
                
            } catch let error as NSError {
                presentAlert(title: "Error", message: "Sorry, there was a problem saving your data.")
                
                print("Could not save \(error), \(error.userInfo)") // FIXME: Remove before shipping
            }
            
        } else {
            presentAlert(title: "Notification", message: "You must first perform a search before you can save your data.")
        }
        
    }
    
    // MARK: - Application State
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(searchBar.text, forKey: "searchText")
        coder.encode(mozData, forKey: "mozData")
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let searchText = coder.decodeObject(forKey: "searchText") as? String {
            searchBar.text = searchText
        }
        if let mozData = coder.decodeObject(forKey: "mozData") as? NSDictionary {
            self.mozData = mozData
            tableView.reloadData()
        }
        super.decodeRestorableState(with: coder)
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        if let url = URL(string: searchBar.text!) {
            // TODO: Update UX so users don't have to type http:// and https:// and can choose instead
            // Validate URL
            if (UIApplication.shared.canOpenURL(url)) {
                performLookup(searchBar.text!)
            } else {
                presentAlert(title: "Notification", message: "You must enter a well-formed URL to search!")
            }
            
        }

    }
    
    fileprivate func performLookup(_ searchURL: String) {
        
        Mozscape.retrieveDataFromMozAPI(
            searchURL,
            accessID: accessID!,
            secretKey: secretKey!,
            completion: { data, httpResponse in
                
                if let data = data {
                    
                    let statusCode = (httpResponse as! HTTPURLResponse).statusCode
                    
                    if statusCode != 200 {
                        DispatchQueue.main.async {
                            self.presentAlert(title: "Error", message: "There was a problem completing your request. \(statusCode).")
                        }
                    } else {
                        self.updateMozData(using: data)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.presentAlert(title: "Error", message: "There was a problem completing your request. No data returned from API.")
                    }
                }
                
        })
        
    }
    
    fileprivate func updateMozData(using data: Data) {
    
        if let jsonDictionary: NSDictionary = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? NSDictionary {
            
            // FIXME: Remove JSON response logging before shipping
            print("\nMozscape Request:", jsonDictionary)
            
            // trim title because Moz includes whitespace and newline characters
            jsonDictionary.setValue((jsonDictionary.value(forKey: ResponseField.TITLE.rawValue) as AnyObject).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), forKey: ResponseField.TITLE.rawValue)
            
            // mozData provides data for tableView
            self.mozData = jsonDictionary
        }
        
    }
    
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Metrics.responseFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let responseField = Metrics.responseFields[indexPath.row]
        let value: AnyObject? = mozData?.value(forKey: responseField.rawValue) as AnyObject?
        
        populate(cell, for: responseField, using: value)
        
        return cell
    }
    
}

