//
//  DetailViewController.swift
//  MozAnalytics
//
//  Created by Andrews Jr, George on 9/15/15.
//  Copyright (c) 2015 Andrews Jr, George. All rights reserved.
//

import UIKit
<<<<<<< HEAD
import CoreData

class DetailViewController: UITableViewController {
=======

class DetailViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var detailTableView: UITableView!
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
    
    var mozResult: MozResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        // Do any additional setup after loading the view, typically from a nib.
    }
        
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Metrics.responseFields.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Retrieve responseField from valuesToPull and use to access value from result object
        let responseField = Metrics.responseFields[indexPath.row]
        
        let description = Metrics.responseFieldDetails[responseField]![0] as! String
        let value: AnyObject? = mozResult?.value(forKey: responseField.rawValue) as AnyObject?
        
        populateResponseFieldCell(cell, description: description, value: value)
=======
        detailTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: K.ReuseID.cell)
        detailTableView.dataSource = self
        detailTableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ResponseField.valuesToPull.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.detailTableView.dequeueReusableCellWithIdentifier(K.ReuseID.cell, forIndexPath: indexPath) 
        
        // Retrieve responseField from valuesToPull and use to access value from result object
        let responseField = ResponseField.valuesToPull[indexPath.row]
        
        let description = Metrics.responseFields[responseField]![0] as! String
        let value: AnyObject? = mozResult?.valueForKey(responseField.rawValue)
        
        populateCell(cell, description: description, value: value)
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
        
        return cell
    }
    
<<<<<<< HEAD
    // MARK: - Application State
    override func encodeRestorableState(with coder: NSCoder) {
        
        coder.encode(mozResult?.objectID.uriRepresentation().absoluteString, forKey: "currentObjectID")
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        if let currentObjectID = coder.decodeObject(forKey: "currentObjectID") as? String {
            let url = URL(string: currentObjectID)!
            let objectID = managedContext.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url)!
            
            mozResult = managedContext.object(with: objectID!) as? MozResult
        }
        
        super.decodeRestorableState(with: coder)
=======
    func populateCell(cell: UITableViewCell, description: String, value: AnyObject?) {
        if let valueString = value as? String {
            cell.textLabel!.text = "\(description): \(valueString)"
        } else if let valueNumber = value as? NSNumber {
            cell.textLabel!.text = "\(description): \(valueNumber.stringValue)"
        } else {
            cell.textLabel!.text = "\(description): "
        }
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
    }
    
}
