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
    var dayButtonsArray: [CalendarDayButton]?
    var calendarHeight : CGFloat?
    let daysOfWeek: [Int: String] = [0: "S", 1: "M", 2: "T", 3: "W", 4: "T", 5: "F", 6: "S"]
    let daysOfWeekLabelHeight: CGFloat = 25.0
    
    // View should not be called from storyboard!
    required init?(coder aDecoder: NSCoder) {
        fatalError("Class does not support NSCoding")
    }
    
    init(frame: CGRect, date: NSDate, calendar: NSCalendar) {
        self.currentDate = date
        self.calendarInUse = calendar
        super.init(frame: frame)
        self.loadCalendar(date, calendar: calendar)
    }

    func loadCalendar(date: NSDate, calendar: NSCalendar) {
        let numberOfDays = date.numberOfDaysInMonth(calendar)
        let weekday = date.firstWeekdayOfMonth(calendar)
        let numberOfRows = self.numberOfRows(numberOfDays, firstDayOfMonth: weekday)
        self.calendarHeight = CGFloat(numberOfRows) * self.buttonSize
        self.dayButtonsArray = [CalendarDayButton]()
        let defaultChosenDate = calendar.component(.Day, fromDate: date)
        var day = 0
        
        self.setDaysOfWeek()
        
        let today = NSDate()
        if calendar.component(.Month, fromDate: today) == calendar.component(.Month, fromDate: self.currentDate!) && calendar.component(.Year, fromDate: today) == calendar.component(.Year, fromDate: self.currentDate!) {
            day = calendar.component(.Day, fromDate: today)
        }

        
        var buttonYPosition = 0.0 as CGFloat
        var buttonXPosition = 0.0 as CGFloat
        var dayCounter = 1
        buttonYPosition = self.daysOfWeekLabelHeight
        buttonXPosition = 0.0
        for var i = 1; i <= numberOfRows; i++ {
            let startDay = i == 1 ? weekday : 1
            buttonXPosition = 0.0 + CGFloat(startDay - 1) * self.buttonSize
            for var j = startDay; j <= 7; j++ {
                let buttonFrame = CGRectMake(buttonXPosition, buttonYPosition, self.buttonSize, self.buttonSize)
                let dayButton = CalendarDayButton(frame: buttonFrame, day: dayCounter)
                dayButton.addTarget(self, action: "dayButtonClicked:", forControlEvents: .TouchUpInside)
                if day == dayCounter {
                    dayButton.dayButtonState = .Today
                    dayButton.stateChanged()
                }
                if defaultChosenDate == dayCounter {
                    dayButton.dayButtonState = .Chosen
                    dayButton.stateChanged()
                }
                if defaultChosenDate == dayCounter && day == dayCounter {
                    dayButton.dayButtonState = .ChosenAndToday
                    dayButton.stateChanged()
                }
                self.dayButtonsArray?.append(dayButton)
                addSubview(dayButton)
                dayCounter++
                if dayCounter > numberOfDays {
                    break
                }
                buttonXPosition += self.buttonSize
            }
            buttonYPosition += self.buttonSize
        }
        self.frame.size.height = CGFloat(numberOfRows) * self.buttonSize + self.daysOfWeekLabelHeight
    }
    
    func setDaysOfWeek() {
        var buttonXPosition = 0.0 as CGFloat
        for var k = 0; k < 7 ; k++ {
            let label = UILabel(frame: CGRectMake(buttonXPosition, 0.0, self.buttonSize, self.daysOfWeekLabelHeight))
            label.backgroundColor = UIColor.themeColor()
            label.text = self.daysOfWeek[k]
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            label.font = UIFont(name: label.font.fontName, size: 12)
            label.layer.borderWidth = 0.5
            label.layer.borderColor = UIColor.themeColor().CGColor
            self.addSubview(label)
            buttonXPosition += self.buttonSize
        }
    }
    
    private func numberOfRows (numberOfDays: Int, firstDayOfMonth: Int) -> Int {
        let numberOfDaysInFirstRow = 8 - firstDayOfMonth
        let numberOfDaysLeft = numberOfDays - numberOfDaysInFirstRow
        
        return Int(ceil(Double(numberOfDaysLeft) / 7.0) + 1)
    }
    
    func dayButtonClicked(sender: CalendarDayButton) {
        // Do not set to private. when day button is clicked the day button class needs to access the method in the calendar view file.
        if let delegate = self.delegate {
            delegate.dayButtonClicked(sender)
        }
    }
}

protocol CalendarViewDelegate {
//    var calendarDayButtons: [CalendarDayButton] {get set}
    func dayButtonClicked (sender: CalendarDayButton)
}
