//
//  Extensions.swift
//  SetADate
//
//  Created by Joshua  Tan on 29/9/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
// Create colors for tabbar image
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextSetBlendMode(context, .Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
// Create solid color background for UITabBar when selected
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIButton {
// Create day button for the calendar
    class func getDayButton (day: Int, rect: CGRect) -> UIButton {
        let dayButton = UIButton(frame: CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height))
        dayButton.setTitle(String(day), forState: .Normal)
        dayButton.backgroundColor = UIColor.greenColor()
        dayButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        dayButton.setTitleColor(UIColor.blackColor(), forState: .Selected)
        dayButton.addTarget(self, action: "dayButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        dayButton.enabled = true
        return dayButton
    }
}

extension NSDate {
// Calculate numbers of day in the month that the date falls in
    func numberOfDaysInMonth (calendar: NSCalendar) -> Int {
        let components = calendar.components(.Month, fromDate: self)
        components.day = 1
        let firstDate = calendar.dateFromComponents(components)
        components.month += 1
        components.day = 1
        let lastDate = calendar.dateFromComponents(components)
        let numberOfDayComponents = calendar.components(.Day, fromDate: firstDate!, toDate: lastDate!, options: .MatchStrictly)
        let numberOfDays = numberOfDayComponents.day
        
        return numberOfDays
    }
    
// Calculate the first day of the week that the first day of the month that the day falls in.
    func firstWeekdayOfMonth (calendar: NSCalendar) -> Int {
        let dateComponents = calendar.components(.Month, fromDate: self)
        dateComponents.year = calendar.component(.Year, fromDate: self)
        dateComponents.day = 1
        let firstDay = calendar.dateFromComponents(dateComponents)
        return calendar.component(.Weekday, fromDate: firstDay!)
        
    }
    
    func dateOfFirstDayOfMonthYear (calendar: NSCalendar, components: NSDateComponents) -> NSDate? {
        if let date = calendar.dateFromComponents(components){
            return date
        } else {
            return nil
        }
    }
}

extension NSCalendar {
    func dayMonthYearComponentsFromDate (date: NSDate) -> NSDateComponents {
        let dateComponents = self.components(.Month, fromDate: date)
        dateComponents.year = self.component(.Year, fromDate: date)
        dateComponents.day = self.component(.Day, fromDate: date)
        
        return dateComponents
    }
}

extension UIColor {
    class func themeColor() -> UIColor {
        let color = UIColor(red: 59.0 / 255, green: 186.0 / 255, blue: 174.0 / 255, alpha: 1.0)
        return color
    }
}

