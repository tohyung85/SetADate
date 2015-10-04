//
//  CalendarViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 27/9/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Calendar View Controller Methods and propreties. Create calendar and functionalities
    @IBOutlet weak var monthLabel: UILabel!
    var currentDate: NSDate?
    var calendar: NSCalendar?
    var calendarRect: CGRect?
    var calendarView: CalendarView?
    var masterVC: CalendarScreenViewController?
    var calendarViewButtons: [CalendarDayButton]?
    var todayComponents: NSDateComponents?
    var currentComponents: NSDateComponents?
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var addEventsButton: UIButton!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar = NSCalendar.currentCalendar()
        self.currentDate = NSDate()
        self.todayComponents = self.calendar?.dayMonthYearComponentsFromDate(self.currentDate!)
        self.currentComponents = self.todayComponents

    }
    
    override func viewWillAppear(animated: Bool) {
        self.calendarRect = self.view.frame
        self.calendarRect?.origin.y = self.monthLabel.frame.height
        self.calendarRect?.size.height = self.view.frame.height - self.monthLabel.frame.height
        self.updateView()
    }
    
    @IBAction func nextMonthButtonPressed(sender: UIButton) {
        if self.currentComponents?.month == 12 {
            self.currentComponents?.month = 1
            self.currentComponents?.year += 1
        } else {
            self.currentComponents?.month += 1
        }
        self.currentComponents?.day = 1
        self.updateView()
    }
    @IBAction func previousMonthButtonPressed(sender: UIButton) {
        if self.currentComponents?.month == 1 {
            self.currentComponents?.month = 12
            self.currentComponents?.year -= 1
        } else {
            self.currentComponents?.month -= 1
        }
        self.currentComponents?.day = 1
        self.updateView()
    }
    
    func updateView() {
        self.currentDate = self.calendar?.dateFromComponents(self.currentComponents!)
        for view in self.view.subviews {
            if view .isKindOfClass(CalendarView) {
                view.removeFromSuperview()
            }
        }
        self.calendarView = CalendarView(frame: self.calendarRect!, date: self.currentDate!, calendar: self.calendar!)
        self.calendarView!.delegate = masterVC
        self.masterVC?.calendarDayButtons = (self.calendarView?.dayButtonsArray)!
        self.view.addSubview(self.calendarView!)
        self.monthLabel.text = self.stringFromComponents(self.currentComponents!)
        
        // Have to use this to set height for table view due to constraints used in story board.
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            self.tableViewHeightConstraint.constant = self.view.frame.size.height - (self.calendarView?.frame.height)! - self.monthLabel.frame.size.height - self.addEventsButton.frame.size.height
            self.view.layoutIfNeeded()
        })
    }
    
    func stringFromComponents (components:NSDateComponents) -> String {
        var string = ""
        switch components.month {
        case 1:
            string = "January "
        case 2:
            string = "February "
        case 3:
            string = "March "
        case 4:
            string = "April "
        case 5:
            string = "May "
        case 6:
            string = "June "
        case 7:
            string = "July "
        case 8:
            string = "August "
        case 9:
            string = "September "
        case 10:
            string = "October "
        case 11:
            string = "November "
        case 12:
            string = "December "
        default:
            string = "Invalid Month "
        }
        
        string += String(components.year)
        
        return string
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CalendarScreenTableViewCell
        tableViewCell.groupNameLabel.text = "Avengers"
        tableViewCell.eventNameLabel.text = "Assemble!"
        tableViewCell.timeLabel.text = "2pm - 3pm"
        tableViewCell.locationLabel.text = "Stark Tower"
        tableViewCell.groupImage.image = UIImage(named: "testImage")
        
        return tableViewCell
    }
}
