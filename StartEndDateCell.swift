//
//  StartEndDateCell.swift
//  SetADate
//
//  Created by Joshua  Tan on 15/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class StartEndDateCell : UITableViewCell {
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    func setCellDateTime (date: NSDate) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle
        dateFormatter.locale = NSLocale.currentLocale()
        let dateString = dateFormatter.stringFromDate(date)
        self.dateTimeLabel.text = dateString
    }
}