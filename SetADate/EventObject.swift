//
//  EventObject.swift
//  SetADate
//
//  Created by Joshua  Tan on 12/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class EventObject : NSObject {
    var eventTitle : String?
    var eventLocation : String?
    var eventStartDate : NSDate?
    var eventEndDate : NSDate?
    var alerts : [String : Int]?
    var repeats : [String : Int]?
    var notes : String?
    
    
    init (eventTitle: String, eventLocation: String, eventStartDate: NSDate, eventEndDate: NSDate, alerts: [String : Int], repeats: [String: Int], notes: String) {
        super.init()
        self.eventTitle = eventTitle
        self.eventLocation = eventLocation
        self.eventStartDate = eventStartDate
        self.eventEndDate = eventEndDate
        self.alerts = alerts
        self.repeats = repeats
        self.notes = notes
    }
    
    func describe() -> String {
        return "Event Name: \(self.eventTitle) /nEvent Location: \(self.eventLocation)/nStart Date: \(self.eventStartDate)/nEnd Date: \(self.eventEndDate)/nAlerts: \(self.alerts)/nRepeats: \(self.repeats)/nNotes: \(self.notes)"
    }
}