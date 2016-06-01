//
//  DetailViewController.swift
//  MozAnalytics
//
//  Created by Andrews Jr, George on 9/15/15.
//  Copyright (c) 2015 Andrews Jr, George. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var detailTableView: UITableView!
    
    var mozResult: MozResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
