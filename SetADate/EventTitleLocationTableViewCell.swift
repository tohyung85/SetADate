//
//  EventTitleLocationTableViewCell.swift
//  SetADate
//
//  Created by Joshua  Tan on 10/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class EventTitleLocationTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return self.textField.resignFirstResponder()
    }
    
}