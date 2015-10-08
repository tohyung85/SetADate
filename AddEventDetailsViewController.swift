//
//  AddEventDetailsViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 8/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class AddEventDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var eventNameAndLocationTable: UITableView!
    @IBOutlet weak var dateAndTimeTable: UITableView!
    @IBOutlet weak var attendeesTable: UITableView!
    @IBOutlet weak var alertsTable: UITableView!
    

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
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.eventNameAndLocationTable:
            return 2
        case self.dateAndTimeTable:
            return 4
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
            cellIdentifier = "eventCell"
        case self.dateAndTimeTable:
            cellIdentifier = "eventCell1"
        case self.attendeesTable:
            cellIdentifier = "eventCell2"
        case self.alertsTable:
            
            cellIdentifier = "eventCell3"
        default:
            cellIdentifier = "eventCell"
        }
        
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath)
        
        return tableViewCell
    }
    
}