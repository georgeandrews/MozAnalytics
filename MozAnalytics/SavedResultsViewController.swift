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
            mozResults = results!
            mozResultsTableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 1. Check for credentials
        if UserDefaults.standard.bool(forKey: "hasCredentials") == false {
            // 2. No credentials, send to settings
            self.tabBarController?.selectedIndex = 2
            return
        } else if mozResults.count < 1 {
            // 3. No results, send to search
            self.tabBarController?.selectedIndex = 1
            return
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            if let indexPath = tableView.indexPathsForSelectedRows?.first {
                destination.mozResult = mozResults[indexPath.row]
            }
        }
    }
    
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
        
        return cell
    }
    
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
    }
    
}
