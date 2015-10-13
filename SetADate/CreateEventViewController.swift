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
    
    let themeBackGroundColor = UIColor(red: 59.0/255, green: 186.0/255, blue: 174.0/255, alpha: 1.0)
    let themeForeGroundColor = UIColor.whiteColor()
    
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
        self.switchState = false
        
        self.alerts = ["None" : 0]
        self.repeats = ["Never" : 0]
    }
    
    override func viewWillAppear(animated: Bool) {
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(self.themeBackGroundColor, size: CGSizeMake(createEventSelectionBar.frame.width/2, createEventSelectionBar.frame.height))
        
        self.alertsTable.reloadData()
        self.dateAndTimeTable.reloadData()
    }
    
    
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
        self.dateAndTimeTable.reloadData()
        // Have to use this to set height for table view due to constraints used in story board.
        UIView.animateWithDuration(0.0, animations: { () -> Void in
        self.dateAndTimeTableHeightConstraint.constant = CGFloat(self.dateAndTimeTable.numberOfRowsInSection(0)) * 40.0
            self.view.layoutIfNeeded()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.eventNameAndLocationTable:
            return 2
        case self.dateAndTimeTable:
            if self.eventType == .Event {
                return self.switchState! ? 2 : 4
            } else {
                return 2
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
            cellIdentifier = "eventTitleLocationCell"
            let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath) as! EventTitleLocationTableViewCell
            tableViewCell.textField.placeholder = indexPath.row == 1 ? "Location" : "Event Name"
            tableViewCell.textField.delegate = tableViewCell
            return tableViewCell
            
        case self.dateAndTimeTable:
            switch indexPath.row {
            case 0:
                if self.eventType == .Event {
                cellIdentifier = "fullDayEventCell"
                let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath) as! FullDayEventCell
                tableViewCell.switchDelegate = self
                return tableViewCell
                } else {
                    cellIdentifier = "startDateCell"
                    let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath)
                    let label = tableViewCell.viewWithTag(1) as! UILabel
                    label.text = "Deadline"
                    return tableViewCell
                }
            case 1:
                cellIdentifier = self.switchState == true ? "repeatCell" : "startDateCell"
                if self.eventType == .Event {
                    if cellIdentifier == "startDateCell" {
                    let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath)
                    let label = tableViewCell.viewWithTag(1) as! UILabel
                    label.text = "Start Date"
                    return tableViewCell
                    } else {
                        return setupRepeatsCell(tableView, indexPath: indexPath)
                    }

                } else {
                    return setupRepeatsCell(tableView, indexPath: indexPath)
                }
            case 2:
                cellIdentifier = "endDateCell"
            case 3:
                return setupRepeatsCell(tableView, indexPath: indexPath)
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
    
    
    
    // Remove keyboard on touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    // Full day switch delegate method
    func switchValueChange(sender: UISwitch, state: Bool) {
        self.switchState = state
        self.dateAndTimeTable.reloadData()
        // Have to use this to set height for table view due to constraints used in story board.
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            self.dateAndTimeTableHeightConstraint.constant = CGFloat(self.dateAndTimeTable.numberOfRowsInSection(0)) * 40.0
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let cellIdentifier = cell?.reuseIdentifier
        print("cell selected: %@", cellIdentifier)
        
        if cellIdentifier == "fullDayEventCell" {
            print("fullDayEventCell selected")
        }
        
        if cellIdentifier == "startDateCell" {
            print("startDateCell selected")
        }
        
        if cellIdentifier == "endDateCell" {
            print("endDateCell selected")
        }
        
        if cellIdentifier == "repeatCell" {
            print("repeat cell selected")
        }
        
        if cellIdentifier == "attendeesCell" {
            print("attendees cell selected")
        }
        
        if cellIdentifier == "alertsCell" {
            print("alertsCell selected")
        }
    }
    
    
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
    }
    
    func setupRepeatsCell (tableView: UITableView, indexPath: NSIndexPath) -> AlertsAndRepeatsCell{
        let cellIdentifier = "repeatCell"
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AlertsAndRepeatsCell
        for (key, _) in self.repeats! {
            tableViewCell.alertsStatus.text = key
        }
        return tableViewCell
    }
    
    
}




enum TypeOfEvent {
    case Event
    case Deadline
}

