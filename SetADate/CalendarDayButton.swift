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
    var dayButtonState: possibleButtonState?
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
        dayButtonState = .None
        enabled = true
    }
    
    func stateChanged () {
        switch self.dayButtonState! {
        case .Today:
            self.backgroundColor = UIColor.blueColor()
        case .Chosen:
            self.backgroundColor = UIColor.redColor()
        case .None:
            self.backgroundColor = UIColor.whiteColor()
        }
    }
}

enum possibleButtonState {
    case Today
    case Chosen
    case None
}
