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
<<<<<<< HEAD
=======
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
    
    let keychainWrapper = KeychainWrapper()
    
    var accessID: String?
    var secretKey: String?
<<<<<<< HEAD
=======
    
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
    var mozData: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
<<<<<<< HEAD
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
=======
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
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
            do {
                try managedContext.save()
                
                presentAlert(title: "Success", message: "Your data has been saved...")
                
            } catch let error as NSError {
                presentAlert(title: "Error", message: "Sorry, there was a problem saving your data.")
                
<<<<<<< HEAD
                print("Could not save \(error), \(error.userInfo)") // FIXME: Remove before shipping
=======
                print("Could not save \(error), \(error.userInfo)") // FIXME: Remove me before shipping
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
            }
            
        } else {
            presentAlert(title: "Notification", message: "You must first perform a search before you can save your data.")
        }
        
    }
    
<<<<<<< HEAD
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
=======
}

extension SearchViewController: UISearchBarDelegate{
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        startAnimatingSearch()
        
        if let url = NSURL(string: searchBar.text!) {
            // FIXME: Update UX so users don't have to type http:// and https:// and can choose instead
            // Validate URL
            if (UIApplication.sharedApplication().canOpenURL(url)) {
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
                performLookup(searchBar.text!)
            } else {
                presentAlert(title: "Notification", message: "You must enter a well-formed URL to search!")
            }
            
        }

<<<<<<< HEAD
    }
    
    fileprivate func performLookup(_ searchURL: String) {
=======
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
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
        
        Mozscape.retrieveDataFromMozAPI(
            searchURL,
            accessID: accessID!,
            secretKey: secretKey!,
            completion: { data, httpResponse in
                
                if let data = data {
                    
<<<<<<< HEAD
                    let statusCode = (httpResponse as! HTTPURLResponse).statusCode
                    
                    if statusCode != 200 {
                        DispatchQueue.main.async {
                            self.presentAlert(title: "Error", message: "There was a problem completing your request. \(statusCode).")
                        }
                    } else {
                        self.updateMozData(using: data)
                        
                        DispatchQueue.main.async {
=======
                    let statusCode = (httpResponse as! NSHTTPURLResponse).statusCode
                    
                    if statusCode != 200 {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.presentAlert(title: "Error", message: "There was a problem completing your request. \(statusCode).")
                        }
                    } else {
                        self.updateMozData(data)
                        
                        dispatch_async(dispatch_get_main_queue()) {
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
                            self.tableView.reloadData()
                        }
                    }
                    
                } else {
<<<<<<< HEAD
                    DispatchQueue.main.async {
=======
                    dispatch_async(dispatch_get_main_queue()) {
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
                        self.presentAlert(title: "Error", message: "There was a problem completing your request. No data returned from API.")
                    }
                }
                
        })
        
    }
    
<<<<<<< HEAD
    fileprivate func updateMozData(using data: Data) {
    
        if let jsonDictionary: NSDictionary = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? NSDictionary {
=======
    private func updateMozData(data: NSData) {
    
        if let jsonDictionary: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)) as? NSDictionary {
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
            
            // FIXME: Remove JSON response logging before shipping
            print("\nMozscape Request:", jsonDictionary)
            
            // trim title because Moz includes whitespace and newline characters
<<<<<<< HEAD
            jsonDictionary.setValue((jsonDictionary.value(forKey: ResponseField.TITLE.rawValue) as AnyObject).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), forKey: ResponseField.TITLE.rawValue)
=======
            jsonDictionary.setValue(jsonDictionary.valueForKey(ResponseField.TITLE.rawValue)?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()), forKey: ResponseField.TITLE.rawValue)
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
            
            // mozData provides data for tableView
            self.mozData = jsonDictionary
        }
        
    }
    
}

<<<<<<< HEAD
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
        
        // Retrieve responseField from valuesToPull and use to access value from mozJSONDictionary
        let responseField = Metrics.responseFields[indexPath.row]
        
        let description = Metrics.responseFieldDetails[responseField]![0] as! String
        let value: AnyObject? = mozData?.value(forKey: responseField.rawValue) as AnyObject?
        
        populateResponseFieldCell(cell, description: description, value: value)
=======
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
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
        
        return cell
    }
    
<<<<<<< HEAD
}

=======
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
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
