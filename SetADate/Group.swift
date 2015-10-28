//
//  Group.swift
//  SetADate
//
//  Created by Joshua  Tan on 28/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class Group : NSObject {
    var name : String
    var events : [EventObject]?
    var contacts : [CNContact]
    
    init (name: String, contacts: [CNContact]){
        self.name = name
        self.contacts = contacts
    }
    
    func addContact (contact: CNContact) {
        self.contacts.append(contact)
    }
    
}