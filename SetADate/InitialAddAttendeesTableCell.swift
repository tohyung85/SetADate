//
//  InitialAddAttendeesTableCell.swift
//  SetADate
//
//  Created by Joshua  Tan on 21/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class InitialAddAttendeesTableCell : UITableViewCell {
    
    @IBOutlet weak var attendeesTextField: UITextView!
    var contact: CNContact?
}