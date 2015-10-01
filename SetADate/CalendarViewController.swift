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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("master VC: %@", masterVC)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.calendarRect = self.view.frame
        self.calendarRect?.origin.y = self.monthLabel.frame.height
        self.calendarRect?.size.height = self.view.frame.height - self.monthLabel.frame.height
        self.currentDate = NSDate()
        self.calendar = NSCalendar.currentCalendar()
        self.calendarView = CalendarView(frame: self.calendarRect!, date: self.currentDate!, calendar: self.calendar!)
        self.calendarView!.delegate = masterVC
        self.calendarViewButtons = self.calendarView?.dayButtonsArray
        self.masterVC?.calendarDayButtons = self.calendarViewButtons!
        self.view.addSubview(self.calendarView!)
    }
    
    @IBAction func nextMonthButtonPressed(sender: UIButton) {
    }
    @IBAction func previousMonthButtonPressed(sender: UIButton) {
    }
    
    func resetDayButtonBackgrounds (){
        // Reset background colors
    }
    
}

