//
//  SavedResultsViewController.swift
//  MozAnalytics
//
//  Created by Andrews Jr, George on 9/15/15.
//  Copyright (c) 2015 Andrews Jr, George. All rights reserved.
//

import UIKit
import CoreData

class SaveResultsViewController: UITableViewController {
    
    @IBOutlet var mozResultsTableView: UITableView!
    
    var mozResults = [MozResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mozResultsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: K.ReuseID.cell)
        mozResultsTableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: K.Entity.mozResult)
        
        if let results = try? managedContext.executeFetchRequest(fetchRequest) as? [MozResult] {
            mozResults = results!
            mozResultsTableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // 1. Check for credentials
        if NSUserDefaults.standardUserDefaults().boolForKey(K.defaultsKey.hasCredentials) == false {
            // 2. No credentials, send to settings
            self.tabBarController?.selectedIndex = 2
            return
        } else if mozResults.count < 1 {
            // 3. No results, send to search
            self.tabBarController?.selectedIndex = 1
            return
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? DetailViewController {
            if let indexPath = tableView.indexPathsForSelectedRows?.first {
                destination.mozResult = mozResults[indexPath.row]
            }
        }
    }
    
    // MARK: UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mozResults.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mozResult = mozResults[indexPath.row]
        
        let cell = self.mozResultsTableView.dequeueReusableCellWithIdentifier(K.ReuseID.cell, forIndexPath: indexPath) 
        
        cell.textLabel!.text = mozResult.canonicalURL
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            managedContext?.deleteObject(mozResults[indexPath.row])
            do {
                try managedContext?.save()
            } catch _ {
            }
            
            mozResults.removeAtIndex(indexPath.row)
            mozResultsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(K.SegueID.showDetail, sender: indexPath)
    }
    
}
