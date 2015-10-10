//
//  FullDayEventCell.swift
//  SetADate
//
//  Created by Joshua  Tan on 10/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class FullDayEventCell: UITableViewCell {
    @IBOutlet weak var fullDayEventSwitch: UISwitch!
    var switchDelegate: FullDayEventSwitchDelegate?
    
    
    @IBAction func switchValueChanged(sender: UISwitch) {
        self.switchDelegate?.switchValueChange(sender, state: sender.on)
    }
    
}

protocol FullDayEventSwitchDelegate {
    func switchValueChange(sender: UISwitch, state: Bool)
}