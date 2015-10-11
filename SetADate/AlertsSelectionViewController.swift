//
//  AlertsSelectionViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 11/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class AlertsSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var noAlertsTable: UITableView!
    @IBOutlet weak var alertsSelectionTable: UITableView!
    
    @IBOutlet weak var alertsTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noAlertsTableHeightConstraint: NSLayoutConstraint!
    
    
    let possibleAlertTimes = [["At time of event" : 0], ["5 minutes before" : 5], ["15 minutes before" : 15], ["30 minutes before" : 30], ["1 hour before" : 60], ["2 hours before" : 120], ["1 day before" : 60 * 24], ["2 days before" : 2 * 24 * 60], ["1 week before" : 7 * 24 * 60]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noAlertsTable.dataSource = self
        self.noAlertsTable.delegate = self
        self.alertsSelectionTable.dataSource = self
        self.alertsSelectionTable.delegate = self
        
        // Have to use this to set height for table view due to constraints used in story board.
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            self.alertsTableHeightConstraint.constant = CGFloat(self.alertsSelectionTable.numberOfRowsInSection(0)) * 44.0 - 1.0
            self.noAlertsTableHeightConstraint.constant = CGFloat(self.noAlertsTable.numberOfRowsInSection(0)) * 44.0 - 1.0
            self.view.layoutIfNeeded()
        })
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIndentifier = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier)
        
        if tableView == self.noAlertsTable {
            cell?.textLabel?.text = "None"
        } else {
            let alertTime = possibleAlertTimes[indexPath.row]
            for (key, value) in alertTime {
                cell?.textLabel?.text = key
                print("need to store the value and send it back to Creat Event VC %d", value)
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows: Int = 1
        if tableView == self.noAlertsTable {
            numberOfRows = 1
        }
        
        if tableView == self.alertsSelectionTable {
            numberOfRows = 9
        }
        
        return numberOfRows
    }
    
}


enum possibleAlertTimes {
    
}