//
//  CalendarView.swift
//  SetADate
//
//  Created by Joshua  Tan on 29/9/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class CalendarView: UIView {
    var currentDate: NSDate?
    let calendarInUse:NSCalendar?
    let buttonSize = UIScreen.mainScreen().bounds.size.width / 7.0
    var delegate: CalendarViewDelegate?
    
    // View should not be called from storyboard!
    required init?(coder aDecoder: NSCoder) {
        fatalError("Class does not support NSCoding")
    }
    
    init(frame: CGRect, date: NSDate, calendar: NSCalendar) {
        print("Initializing calendar")
        self.currentDate = date
        self.calendarInUse = calendar
        super.init(frame: frame)
        self.loadCalendar(date, calendar: calendar)
    }

    func loadCalendar(date: NSDate, calendar: NSCalendar) {
        let numberOfDays = date.numberOfDaysInMonth(calendar)
        let weekday = date.firstWeekdayOfMonth(calendar)
        let numberOfRows = self.numberOfRows(numberOfDays, firstDayOfMonth: weekday)
        
        var dayCounter = 1
        var buttonYPosition = 0.0 as CGFloat
        var buttonXPosition = 0.0 as CGFloat
        for var i = 1; i <= numberOfRows; i++ {
            let startDay = i == 1 ? weekday : 1
            buttonXPosition = 0.0 + CGFloat(startDay - 1) * self.buttonSize
            for var j = startDay; j <= 7; j++ {
                if dayCounter == numberOfDays {
                    break
                }
                let buttonFrame = CGRectMake(buttonXPosition, buttonYPosition, self.buttonSize, self.buttonSize)
                let dayButton = CalendarDayButton(frame: buttonFrame, day: dayCounter)
                dayButton.addTarget(self, action: "dayButtonClicked:", forControlEvents: .TouchUpInside)
                addSubview(dayButton)
                dayCounter++
                buttonXPosition += self.buttonSize
            }
            buttonYPosition += self.buttonSize
        }
    }
    
    private func numberOfRows (numberOfDays: Int, firstDayOfMonth: Int) -> Int {
        let numberOfDaysInFirstRow = 8 - firstDayOfMonth
        let numberOfDaysLeft = numberOfDays - numberOfDaysInFirstRow
        
        return Int(ceil(Double(numberOfDaysLeft) / 7.0) + 1)
    }
    
    private func dayButtonClicked(sender: CalendarDayButton) {
        if let delegate = self.delegate {
            delegate.dayButtonClicked(sender)
        }
    }
}

protocol CalendarViewDelegate {
    func dayButtonClicked (sender: CalendarDayButton)
}
