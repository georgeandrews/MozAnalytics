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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let keychainWrapper = KeychainWrapper()
    
    var accessID: String?
    var secretKey: String?
    
    var mozData: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.autocapitalizationType = UITextAutocapitalizationType.None
        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: K.ReuseID.cell)
    }
    
    override func viewDidAppear(animated: Bool) {
        // 1. Check for credentials
        if NSUserDefaults.standardUserDefaults().boolForKey(K.defaultsKey.hasCredentials) == false {
            // 2. No credentials, send to settings
            self.tabBarController?.selectedIndex = 2
        } else {
            accessID = NSUserDefaults.standardUserDefaults().valueForKey(K.accessID) as? String
            secretKey = keychainWrapper.myObjectForKey(K.secretKey) as? String
        }
    }
    
    @IBAction func saveResult(sender: AnyObject) {
        
        if let mozData = mozData {
            
            // 1. Create
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            let mozResult = NSEntityDescription.insertNewObjectForEntityForName(K.Entity.mozResult, inManagedObjectContext: managedContext) as! MozResult
            
            // 2. Populate
            mozResult.title = mozData.valueForKey(ResponseField.TITLE.rawValue) as! String
            mozResult.canonicalURL = mozData.valueForKey(ResponseField.URL.rawValue) as! String
            mozResult.mozRank = mozData.valueForKey(ResponseField.MOZ_RANK.rawValue) as! NSNumber
            mozResult.pageAuthority = mozData.valueForKey(ResponseField.PAGE_AUTHORITY.rawValue) as! NSNumber
            mozResult.domainAuthority = mozData.valueForKey(ResponseField.DOMAIN_AUTHORITY.rawValue) as! NSNumber
            mozResult.externalLinks = mozData.valueForKey(ResponseField.EXT_EQUITY_LINKS.rawValue) as! NSNumber
            
            // 3. Save
            do {
                try managedContext.save()
                
                presentAlert(title: "Success", message: "Your data has been saved...")
                
            } catch let error as NSError {
                presentAlert(title: "Error", message: "Sorry, there was a problem saving your data.")
                
                print("Could not save \(error), \(error.userInfo)") // FIXME: Remove me before shipping
            }
            
        } else {
            presentAlert(title: "Notification", message: "You must first perform a search before you can save your data.")
        }
        
    }
    
}

extension SearchViewController: UISearchBarDelegate{
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        startAnimatingSearch()
        
        if let url = NSURL(string: searchBar.text!) {
            // FIXME: Update UX so users don't have to type http:// and https:// and can choose instead
            // Validate URL
            if (UIApplication.sharedApplication().canOpenURL(url)) {
                performLookup(searchBar.text!)
            } else {
                presentAlert(title: "Notification", message: "You must enter a well-formed URL to search!")
            }
            
        }

        stopAnimatingSearch()
    }
    
    private func startAnimatingSearch() {
        searchBar.resignFirstResponder()
        searchBar.hidden = true
        activityIndicator.startAnimating()
    }
    
    private func stopAnimatingSearch() {
        searchBar.hidden = false
        activityIndicator.stopAnimating()
    }
    
    private func performLookup(searchURL: String) {
        
        Mozscape.retrieveDataFromMozAPI(
            searchURL,
            accessID: accessID!,
            secretKey: secretKey!,
            completion: { data, httpResponse in
                
                if let data = data {
                    
                    let statusCode = (httpResponse as! NSHTTPURLResponse).statusCode
                    
                    if statusCode != 200 {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.presentAlert(title: "Error", message: "There was a problem completing your request. \(statusCode).")
                        }
                    } else {
                        self.updateMozData(data)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentAlert(title: "Error", message: "There was a problem completing your request. No data returned from API.")
                    }
                }
                
        })
        
    }
    
    private func updateMozData(data: NSData) {
    
        if let jsonDictionary: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)) as? NSDictionary {
            
            // FIXME: Remove JSON response logging before shipping
            print("\nMozscape Request:", jsonDictionary)
            
            // trim title because Moz includes whitespace and newline characters
            jsonDictionary.setValue(jsonDictionary.valueForKey(ResponseField.TITLE.rawValue)?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()), forKey: ResponseField.TITLE.rawValue)
            
            // mozData provides data for tableView
            self.mozData = jsonDictionary
        }
        
    }
    
}

extension SearchViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ResponseField.valuesToPull.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(K.ReuseID.cell, forIndexPath: indexPath)
        
        // Retrieve responseField from valuesToPull and use to access value from mozJSONDictionary
        let responseField = ResponseField.valuesToPull[indexPath.row]
        
        let description = Metrics.responseFields[responseField]![0] as! String
        let value: AnyObject? = mozData?.valueForKey(responseField.rawValue)
        
        populateCell(cell, description: description, value: value)
        
        return cell
    }
    
    func populateCell(cell: UITableViewCell, description: String, value: AnyObject?) {
        if let valueString = value as? String {
            cell.textLabel!.text = "\(description): \(valueString)"
        } else if let valueNumber = value as? NSNumber {
            cell.textLabel!.text = "\(description): \(valueNumber.stringValue)"
        } else {
            cell.textLabel!.text = "\(description): "
        }
    }
}


extension UIViewController {
    
    // MARK: EZ Alerts
    func presentAlert(title title: String, message: String) {
        present(UIAlertController(title: title, message: message, preferredStyle: .ActionSheet).withOKAction())
    }
    
    private func present(alertController: UIAlertController) {
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension UIAlertController {
    private func withOKAction() -> UIAlertController {
        addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        return self
    }
}