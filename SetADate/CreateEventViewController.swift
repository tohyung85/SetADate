//
//  CreateEventViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 7/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class CreateEventViewController: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate, FullDayEventSwitchDelegate {
    
    @IBOutlet weak var createEventSelectionBar: UITabBar!
    @IBOutlet weak var eventNameAndLocationTable: UITableView!
    @IBOutlet weak var dateAndTimeTable: UITableView!
    @IBOutlet weak var attendeesTable: UITableView!
    @IBOutlet weak var alertsTable: UITableView!
    @IBOutlet weak var notesTextField: UITextView!
    @IBOutlet weak var dateAndTimeTableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var switchState: Bool?
    var eventType: TypeOfEvent?
    
    var alerts : [String : Int]?
    var repeats : [String : Int]?
    var startDate : NSDate?
    var endDate : NSDate?
    var attendeesName : [String]?
    
    var showStartDatePicker : Bool?
    var showEndDatePicker : Bool?
    
    let themeBackGroundColor = UIColor(red: 59.0/255, green: 186.0/255, blue: 174.0/255, alpha: 1.0)
    let themeForeGroundColor = UIColor.whiteColor()
    
    
    
    
    ///////////////////////////////
    // VIEW CONTROLLER LIFECYCLE FUNCTIONS
    ///////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createEventSelectionBar.delegate = self
        performTabBarConfigurations()
        self.createEventSelectionBar.selectedItem = self.createEventSelectionBar.items?.first
        
        // To remove shadow image of navigation view controller and hence the underline of the bar
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
        
        self.eventType = .Event
        self.eventNameAndLocationTable.delegate = self
        self.eventNameAndLocationTable.dataSource = self
        self.dateAndTimeTable.delegate = self
        self.dateAndTimeTable.dataSource = self
        self.attendeesTable.delegate = self
        self.attendeesTable.dataSource = self
        self.alertsTable.delegate = self
        self.alertsTable.dataSource = self
        
        self.dateAndTimeTable.rowHeight = UITableViewAutomaticDimension
        self.switchState = false
        
        self.startDate = NSDate()
        self.endDate = self.startDate?.dateByAddingTimeInterval(60.0 * 60.0)
        self.alerts = ["None" : 0]
        self.repeats = ["Never" : 0]
    }
    
    override func viewWillAppear(animated: Bool) {
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(self.themeBackGroundColor, size: CGSizeMake(createEventSelectionBar.frame.width/2, createEventSelectionBar.frame.height))
        
        self.alertsTable.reloadData()
        self.showStartDatePicker = false
        self.showEndDatePicker = false
        self.dateAndTimeTable.reloadData()

        UIView.animateWithDuration(0.0, animations: { () -> Void in
            if self.showEndDatePicker == true || self.showStartDatePicker == true {
                self.dateAndTimeTableHeightConstraint.constant = CGFloat(self.dateAndTimeTable.numberOfRowsInSection(0) - 1) * 40.0 + 200.0
            } else {
                self.dateAndTimeTableHeightConstraint.constant = CGFloat(self.dateAndTimeTable.numberOfRowsInSection(0)) * 40.0
            }
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    ///////////////////////////////
    // TAB BAR FUNCTIONS
    ///////////////////////////////
    
    
    func performTabBarConfigurations() {
        // Sets default text color of tab bar items
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : self.themeBackGroundColor], forState: UIControlState.Normal)
        
        // Sets selected text color of tab bar items
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : self.themeForeGroundColor], forState: UIControlState.Selected)
        
        //Removes default grey shadow of tab bar
        createEventSelectionBar.clipsToBounds = true
        
        // Sets the background color of the selected UITabBarItem (using and plain colored UIImage with the width = 1/3 of the tabBar (if you have 3 items) and the height of the tabBar)
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(self.themeBackGroundColor, size: CGSizeMake(createEventSelectionBar.frame.width/3, createEventSelectionBar.frame.height))
        
        // Sets default tab bar image colors
        for item in (self.createEventSelectionBar.items)! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(self.themeBackGroundColor).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        self.eventType = self.createEventSelectionBar.items?.indexOf(item) == 0 ? .Event : .Deadline
        tabBar.selectedItem = item
        self.showStartDatePicker = false
        self.showEndDatePicker = false
        self.dateAndTimeTable.reloadData()
        // Have to use this to set height for table view due to constraints used in story board.
        UIView.animateWithDuration(0.0, animations: { () -> Void in
        self.dateAndTimeTableHeightConstraint.constant = CGFloat(self.dateAndTimeTable.numberOfRowsInSection(0)) * 40.0
            self.view.layoutIfNeeded()
        })
    }
    

    ///////////////////////////////
    // TABLE VIEW DELEGATE & DATASOURCE FUNCTIONS
    ///////////////////////////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let datePickerDisplayRow = self.showEndDatePicker == true || self.showStartDatePicker == true ? 1 : 0
        switch tableView {
        case self.eventNameAndLocationTable:
            return 2
        case self.dateAndTimeTable:
            if self.eventType == .Event {
                return self.switchState! ? 2 + datePickerDisplayRow : 4 + datePickerDisplayRow
            } else {
                return 2 + datePickerDisplayRow
            }
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
            return setUpEventNameAndLocationCells(tableView, indexPath: indexPath)
            
        case self.dateAndTimeTable:
            switch indexPath.row {
            case 0:
                if self.eventType == .Event {
                return setupFullDayEventCell(tableView, indexPath: indexPath)
                } else {
                    return setupStartDateCell(tableView, indexPath: indexPath, startDate: self.startDate!)
                }
            case 1:
                if self.eventType == .Event {
                    if self.switchState != true {
                        return setupStartDateCell(tableView, indexPath: indexPath, startDate: self.startDate!)
                    } else {
                        return setupRepeatsCell(tableView, indexPath: indexPath)
                    }

                } else if self.showStartDatePicker == true {
                    return setupDatePickerCell(tableView, indexPath: indexPath, forDateCell: "startDateCell")
                    } else {
                    return setupRepeatsCell(tableView, indexPath: indexPath)
                    }
            case 2:
                if self.eventType == .Event {
                    if self.showStartDatePicker == true {
                    return setupDatePickerCell(tableView, indexPath: indexPath, forDateCell: "startDateCell")
                    } else {
                        return setupEndDateCell(tableView, indexPath: indexPath, endDate: self.endDate!)
                    }
                } else {
                    if self.showStartDatePicker == true {
                        return setupRepeatsCell(tableView, indexPath: indexPath)
                    }
                }

            case 3:
                if self.showStartDatePicker == true {
                    return setupEndDateCell(tableView, indexPath: indexPath, endDate: self.endDate!)
                } else if self.showEndDatePicker == true {
                    return setupDatePickerCell(tableView, indexPath: indexPath, forDateCell: "endDateCell")
                } else {
                    return setupRepeatsCell(tableView, indexPath: indexPath)
                }
            default:
                return setupRepeatsCell(tableView, indexPath: indexPath)
            }
            let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath)
            return tableViewCell
            
            
        case self.attendeesTable:
            cellIdentifier = "attendeesCell"
            let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath)
            return tableViewCell
        case self.alertsTable:
            cellIdentifier = "alertsCell"
            let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath) as! AlertsAndRepeatsCell
            for (key, _) in self.alerts! {
                tableViewCell.alertsStatus.text = key
            }
            return tableViewCell
        default:
            cellIdentifier = "alertsCell"
            let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath)
            return tableViewCell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch self.eventType! {
        case .Event:
            if self.showStartDatePicker == true {
                if self.switchState == false {
                    if indexPath.row == 2 {
                        return 200.0
                    }
                }
            }
            if self.showEndDatePicker == true {
                if indexPath.row == 3 {
                    return 200.0
                }
            }
        case .Deadline:
            if self.showStartDatePicker == true {
                if indexPath.row == 1 {
                    return 200.0
                }
            }
        }
        return 40.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let cellIdentifier = cell?.reuseIdentifier
        
        if cellIdentifier == "fullDayEventCell" {
            print("fullDayEventCell selected")
        }
        
        if cellIdentifier == "startDateCell" {
            self.showStartDatePicker = self.showStartDatePicker == true ? false : true
            self.showEndDatePicker = false
            tableView.reloadData()
            UIView.animateWithDuration(0.0, animations: { () -> Void in
                if self.showEndDatePicker == true || self.showStartDatePicker == true {
                    self.dateAndTimeTableHeightConstraint.constant = CGFloat(self.dateAndTimeTable.numberOfRowsInSection(0) - 1) * 40.0 + 200.0
                } else {
                    self.dateAndTimeTableHeightConstraint.constant = CGFloat(self.dateAndTimeTable.numberOfRowsInSection(0)) * 40.0
                }
                self.view.layoutIfNeeded()
            })

        }
        
        if cellIdentifier == "endDateCell" {
            self.showEndDatePicker = self.showEndDatePicker == true ? false : true
            self.showStartDatePicker = false
            tableView.reloadData()
            UIView.animateWithDuration(0.0, animations: { () -> Void in
                if self.showEndDatePicker == true || self.showStartDatePicker == true {
                    self.dateAndTimeTableHeightConstraint.constant = CGFloat(self.dateAndTimeTable.numberOfRowsInSection(0) - 1) * 40.0 + 200.0
                } else {
                    self.dateAndTimeTableHeightConstraint.constant = CGFloat(self.dateAndTimeTable.numberOfRowsInSection(0)) * 40.0
                }
                self.view.layoutIfNeeded()
            })
        }
        
        if cellIdentifier == "repeatCell" {
        }
        
        if cellIdentifier == "attendeesCell" {
        }
        
        if cellIdentifier == "alertsCell" {
        }
    }
    
    ///////////////////////////////
    // TABLE VIEW SELECTION SEGUES
    ///////////////////////////////
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "alertsSelectionSegue" {
            let alertsVC = segue.destinationViewController as! AlertsSelectionViewController
            alertsVC.masterVC = self
            alertsVC.selectedAlert = self.alerts
        }
        
        if segue.identifier == "repeatsSelectionSegue" {
            let repeatsVC = segue.destinationViewController as! RepeatsSelectionViewController
            repeatsVC.masterVC = self
            repeatsVC.selectedRepeat = self.repeats
        }
        
//        if segue.identifier == "displayAttendeesContainerView" {
//            let containerVC = segue.destinationViewController as! AttendeesContainerViewController
//            
//        }
    }
    
    
    ///////////////////////////////
    // TABLE VIEW CELL RELATED FUNCTIONS
    ///////////////////////////////
    
    // Remove keyboard on touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    // Full day switch delegate method
    func switchValueChange(sender: UISwitch, state: Bool) {
        self.switchState = state
        if self.switchState == true {
            self.showStartDatePicker = false
            self.showEndDatePicker = false
        }
        self.dateAndTimeTable.reloadData()
        // Have to use this to set height for table view due to constraints used in story board.
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            self.dateAndTimeTableHeightConstraint.constant = CGFloat(self.dateAndTimeTable.numberOfRowsInSection(0)) * 40.0
            self.view.layoutIfNeeded()
        })
    }
    
    ///////////////////////////////
    // TABLE VIEW CELL TYPE SET UPS
    ///////////////////////////////
    func setupRepeatsCell (tableView: UITableView, indexPath: NSIndexPath) -> AlertsAndRepeatsCell{
        let cellIdentifier = "repeatCell"
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AlertsAndRepeatsCell
        for (key, _) in self.repeats! {
            tableViewCell.alertsStatus.text = key
        }
        return tableViewCell
    }
    
    func setupStartDateCell (tableView: UITableView, indexPath: NSIndexPath, startDate: NSDate) -> StartEndDateCell {
        let cellIdentifier = "startDateCell"
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StartEndDateCell
        let label = tableViewCell.viewWithTag(1) as! UILabel
        label.text = self.eventType == .Event ? "Start Date" : "Deadline"
        tableViewCell.setCellDateTime(startDate)
        return tableViewCell
    }
    
    func setupEndDateCell (tableView: UITableView, indexPath: NSIndexPath, endDate: NSDate) -> StartEndDateCell {
        let cellIdentifier = "endDateCell"
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StartEndDateCell
        tableViewCell.setCellDateTime(endDate)
        return tableViewCell
    }
    
    func setupFullDayEventCell (tableView: UITableView, indexPath: NSIndexPath) -> FullDayEventCell {
        let cellIdentifier = "fullDayEventCell"
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FullDayEventCell
        tableViewCell.switchDelegate = self
        return tableViewCell
    }
    
    func setUpEventNameAndLocationCells (tableView: UITableView, indexPath: NSIndexPath) -> EventTitleLocationTableViewCell {
        let cellIdentifier = "eventTitleLocationCell"
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EventTitleLocationTableViewCell
        tableViewCell.textField.placeholder = indexPath.row == 1 ? "Location" : "Event Name"
        tableViewCell.textField.delegate = tableViewCell
        return tableViewCell
    }
    
    func setupDatePickerCell (tableView: UITableView, indexPath: NSIndexPath, forDateCell: String) -> DatePickerCell {
        let cellIdentifier = "datePickerCell"
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DatePickerCell
        let datePicker = tableViewCell.datePicker as! StartEndDatePicker
        datePicker.forDate = forDateCell
        tableViewCell.datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: .ValueChanged)
        return tableViewCell
    }
    
    func datePickerChanged (datePicker: UIDatePicker) {
        let newDatePicker = datePicker as! StartEndDatePicker
        if newDatePicker.forDate == "startDateCell" {
            self.startDate = newDatePicker.date
        } else {
            self.endDate = newDatePicker.date
        }
        self.dateAndTimeTable.reloadData()
    }
}




enum TypeOfEvent {
    case Event
    case Deadline
}

