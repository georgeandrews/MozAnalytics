//
//  DetailViewController.swift
//  MozAnalytics
//
//  Created by Andrews Jr, George on 9/15/15.
//  Copyright (c) 2015 Andrews Jr, George. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UITableViewController {
    
    var mozResult: MozResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

        let responseField = Metrics.responseFields[indexPath.row]
        let value: AnyObject? = mozResult?.value(forKey: responseField.rawValue) as AnyObject?
        
        populate(cell, for: responseField, with: value)
        
        return cell
    }
    
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
    }
    
}
