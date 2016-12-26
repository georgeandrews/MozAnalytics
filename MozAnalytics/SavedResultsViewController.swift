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
<<<<<<< HEAD
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTableView()
    }
    
    func loadTableView() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MozResult")
        
        if let results = try? managedContext.fetch(fetchRequest) as? [MozResult] {
=======
        
        mozResultsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: K.ReuseID.cell)
        mozResultsTableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: K.Entity.mozResult)
        
        if let results = try? managedContext.executeFetchRequest(fetchRequest) as? [MozResult] {
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
            mozResults = results!
            mozResultsTableView.reloadData()
        }
    }
    
<<<<<<< HEAD
    override func viewDidAppear(_ animated: Bool) {
        // 1. Check for credentials
        if UserDefaults.standard.bool(forKey: "hasCredentials") == false {
=======
    override func viewDidAppear(animated: Bool) {
        // 1. Check for credentials
        if NSUserDefaults.standardUserDefaults().boolForKey(K.defaultsKey.hasCredentials) == false {
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
            // 2. No credentials, send to settings
            self.tabBarController?.selectedIndex = 2
            return
        } else if mozResults.count < 1 {
            // 3. No results, send to search
            self.tabBarController?.selectedIndex = 1
            return
        }
        
    }
    
<<<<<<< HEAD
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
=======
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? DetailViewController {
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
            if let indexPath = tableView.indexPathsForSelectedRows?.first {
                destination.mozResult = mozResults[indexPath.row]
            }
        }
    }
    
<<<<<<< HEAD
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mozResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.mozResultsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        
        cell.textLabel!.text = mozResults[indexPath.row].canonicalURL
=======
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
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
        
        return cell
    }
    
<<<<<<< HEAD
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let managedContext = appDelegate.managedObjectContext {
                
                managedContext.delete(mozResults[indexPath.row])
                
                do {
                    try managedContext.save()
                } catch _ {
                }
                
                mozResults.remove(at: indexPath.row)
                mozResultsTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath)
=======
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
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
    }
    
}
