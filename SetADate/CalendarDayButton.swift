//
//  CalendarDayButton.swift
//  SetADate
//
//  Created by Joshua  Tan on 29/9/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class CalendarDayButton: UIButton {
    var isChosen: Bool = false
    var isToday: Bool = false
    var dayFrame: CGRect?
    let dayOftheMonth: Int?
    
    // Button should not be called from storyboard!
    required init?(coder aDecoder: NSCoder) {
        fatalError("Class does not support NSCoding")
    }
    
    init(frame: CGRect, day: Int) {
        self.dayFrame = frame
        self.dayOftheMonth = day
        super.init(frame: frame)
        setTitle(String(day), forState: .Normal)
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        enabled = true
    }
}
