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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("calendarViewController loaded")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.calendarRect = self.view.frame
        self.calendarRect?.origin.y = self.monthLabel.frame.height
        self.calendarRect?.size.height = self.view.frame.height - self.monthLabel.frame.height
        self.currentDate = NSDate()
        self.calendar = NSCalendar.currentCalendar()
        let theCalendarView = CalendarView(frame: self.calendarRect!, date: self.currentDate!, calendar: self.calendar!)
        self.view.addSubview(theCalendarView)
    }
    
    @IBAction func nextMonthButtonPressed(sender: UIButton) {
    }
    @IBAction func previousMonthButtonPressed(sender: UIButton) {
    }

    func dayButtonPressed(sender: UIButton) {
        print("day button pressed")
    }
    
}

