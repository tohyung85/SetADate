//
//  RepeatsSelectionViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 12/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class RepeatsSelectionViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var masterVC : CreateEventViewController?
    var selectedRepeat : [String : Int]?
 
    @IBOutlet weak var noRepeatsTable: UITableView!
    @IBOutlet weak var repeatsSelectionTable: UITableView!
    
    @IBOutlet weak var noRepeatsTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var repeatsSelectionTableHeightConstraint: NSLayoutConstraint!
    
    
    let possibleRepeatTimes = [["Never" : 0], ["Every Day" : 60 * 24 * 1], ["Every Week" : 60 * 24 * 7], ["Every 2 Weeks" : 60 * 24 * 7 * 2], ["Every Month" : 60 * 24 * 7 * 4], ["Every Year" : 60 * 24 * 7 * 4 * 12]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noRepeatsTable.dataSource = self
        self.noRepeatsTable.delegate = self
        self.repeatsSelectionTable.dataSource = self
        self.repeatsSelectionTable.delegate = self
        
        // Have to use this to set height for table view due to constraints used in story board.
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            self.repeatsSelectionTableHeightConstraint.constant = CGFloat(self.repeatsSelectionTable.numberOfRowsInSection(0)) * 44.0 - 1.0
            self.noRepeatsTableHeightConstraint.constant = CGFloat(self.noRepeatsTable.numberOfRowsInSection(0)) * 44.0 - 1.0
            self.view.layoutIfNeeded()
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIndentifier = "repeatsSelectionCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier)
        
        if tableView == self.noRepeatsTable {
            if let unwrappedCell = cell {
                unwrappedCell.textLabel?.text = "Never"
                checkAndInsertCheckMark(unwrappedCell)
            }
        } else {
            let repeatTime = possibleRepeatTimes[indexPath.row + 1]
            for (key, _) in repeatTime {
                if let unwrappedCell = cell {
                    unwrappedCell.textLabel?.text = key
                    checkAndInsertCheckMark(unwrappedCell)
                }
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows: Int = 1
        if tableView == self.noRepeatsTable {
            numberOfRows = 1
        }
        
        if tableView == self.repeatsSelectionTable {
            numberOfRows = 5
        }
        
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cellSelected  = tableView.cellForRowAtIndexPath(indexPath)
        for types in self.possibleRepeatTimes {
            for (key, value) in types {
                if cellSelected?.textLabel?.text == key {
                    self.selectedRepeat = [key : value]
                    self.masterVC?.repeats = self.selectedRepeat
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }
    
    func checkAndInsertCheckMark (cell: UITableViewCell) {
        for (key, _) in self.selectedRepeat! {
            if key == cell.textLabel?.text {
                cell.accessoryType = .Checkmark
            }
        }
    }
}