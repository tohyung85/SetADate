//
//  CalendarViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 27/9/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class CalendarViewController: UIViewController {
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
        //
        // INCLUDE WEEKDAY HEADER
        //
    }
    
    override func viewDidAppear(animated: Bool) {
        // Update view has to be done here. 
        // Changes to the elements in Main View can only be done after view did appear in main VC called. 
        // VC life cycle dictates that view did appear for main VC called only after view will appear for Container VC.
        
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
        self.view.frame.size.height = (self.calendarView?.frame.size.height)! + self.monthLabel.frame.size.height

        // Update Table and calendar view layouts
        self.masterVC?.eventsTable.frame.origin.y = (self.masterVC?.selectionBar.frame.origin.y)! + (self.masterVC?.selectionBar.frame.size.height)! + self.view.frame.size.height
        self.masterVC?.eventsTable.frame.size.height = (self.masterVC?.addEventsButton.frame.origin.y)! - (self.masterVC?.eventsTable.frame.origin.y)!
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
    
}
