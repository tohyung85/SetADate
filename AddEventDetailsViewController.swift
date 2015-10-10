//
//  AddEventDetailsViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 8/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class AddEventDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FullDayEventSwitchDelegate {
    
    @IBOutlet weak var eventNameAndLocationTable: UITableView!
    @IBOutlet weak var dateAndTimeTable: UITableView!
    @IBOutlet weak var attendeesTable: UITableView!
    @IBOutlet weak var alertsTable: UITableView!
    @IBOutlet weak var notesTextField: UITextView!
    
    var switchState: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventNameAndLocationTable.delegate = self
        self.eventNameAndLocationTable.dataSource = self
        self.dateAndTimeTable.delegate = self
        self.dateAndTimeTable.dataSource = self
        self.attendeesTable.delegate = self
        self.attendeesTable.dataSource = self
        self.alertsTable.delegate = self
        self.alertsTable.dataSource = self
        self.switchState = false
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.eventNameAndLocationTable:
            return 2
        case self.dateAndTimeTable:
            return self.switchState! ? 2 : 4
        case self.attendeesTable:
            return 1
        case self.alertsTable:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier: String?
        
        switch tableView {
        case self.eventNameAndLocationTable:
            cellIdentifier = "eventTitleLocationCell"
            let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath) as! EventTitleLocationTableViewCell
            tableViewCell.textField.placeholder = indexPath.row == 1 ? "Location" : "Event Name"
            tableViewCell.textField.delegate = tableViewCell
            return tableViewCell
            
        case self.dateAndTimeTable:
            switch indexPath.row {
            case 0:
                cellIdentifier = "fullDayEventCell"
                let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath) as! FullDayEventCell
                tableViewCell.switchDelegate = self
                return tableViewCell
            case 1:
                cellIdentifier = self.switchState! ? "repeatCell" : "startDateCell"
            case 2:
                cellIdentifier = "endDateCell"
            case 3:
                cellIdentifier = "repeatCell"
            default:
                cellIdentifier = "repeatCell"
            }
            let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath)
            return tableViewCell


        case self.attendeesTable:
            cellIdentifier = "attendeesCell"
            let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath)
            return tableViewCell
        case self.alertsTable:
            cellIdentifier = "alertsCell"
            let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath)
            return tableViewCell
        default:
            cellIdentifier = "alertsCell"
            let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath)
            return tableViewCell
        }
        
    }
    
    
    
    // Remove keyboard on touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    // Full day switch delegate method
    func switchValueChange(sender: UISwitch, state: Bool) {
        self.switchState = state
        self.dateAndTimeTable.reloadData()
        self.dateAndTimeTable.frame.size.height = CGFloat(self.dateAndTimeTable.numberOfRowsInSection(0)) * 40.0
    }
}