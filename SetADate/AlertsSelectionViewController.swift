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
    
    var masterVC : CreateEventViewController?
    
    var selectedAlert : [String : Int]?
    
    let possibleAlertTimes = [["None" : 0], ["At time of event" : 0], ["5 minutes before" : 5], ["15 minutes before" : 15], ["30 minutes before" : 30], ["1 hour before" : 60], ["2 hours before" : 120], ["1 day before" : 60 * 24], ["2 days before" : 2 * 24 * 60], ["1 week before" : 7 * 24 * 60]]
    
    
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
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIndentifier = "alertsSelectionCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier)
        
        if tableView == self.noAlertsTable {
            if let unwrappedCell = cell {
                unwrappedCell.textLabel?.text = "None"
                checkAndInsertCheckMark(unwrappedCell)
            }
        } else {
            let alertTime = possibleAlertTimes[indexPath.row + 1]
            for (key, _) in alertTime {
                if let unwrappedCell = cell {
                    unwrappedCell.textLabel?.text = key
                    checkAndInsertCheckMark(unwrappedCell)

                }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let cellSelected  = tableView.cellForRowAtIndexPath(indexPath)
        for types in self.possibleAlertTimes {
            for (key, value) in types {
                if cellSelected?.textLabel?.text == key {
                    self.selectedAlert = [key : value]
                    self.masterVC?.alerts = self.selectedAlert
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }
    
    func checkAndInsertCheckMark (cell: UITableViewCell) {
        for (key, _) in self.selectedAlert! {
            if key == cell.textLabel?.text {
                cell.accessoryType = .Checkmark
            }
        }
    }
    
}