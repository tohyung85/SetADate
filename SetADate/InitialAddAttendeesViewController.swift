//
//  InitialAddAttendeesViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 18/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class InitialAddAttendeesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    var addAttendeesCompleteBarButton : UIBarButtonItem?
    var attendees : [CNContact]?
    var textViewHeight : CGFloat?
    let sectionHeaderTitles = ["Groups", "Contacts"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Attendees"
        let barButton = UIBarButtonItem(title: "Add", style: .Done, target: self, action: "addAttendeesComplete:")
        self.navigationItem.rightBarButtonItem = barButton
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.attendees = [CNContact]()
        self.textViewHeight = 40.0
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        self.resizeTable()
        for contact in self.attendees! {
            print(contact.givenName)
        }

    }
    
    ///////////////////////////////
    // TABLE VIEW FUNCTIONS
    ///////////////////////////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return 1
            // TODO: should return number of groups in groups array
        case 1:
//            if self.attendees?.count > 0 {
//                print("number of rows with contacts: %d", self.attendees?.count)
//                return (self.attendees?.count)!
//            } else {
//                print("number of rows without contacts")
//                return 1
//            }
            return 1 + (self.attendees?.count)!
        default:
            return 1
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionHeaderTitles[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (self.attendees?.count)! > indexPath.row {
            let cellIdentifier = "cell"
            let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! InitialAddAttendeesTableCell
            let contact = self.attendees![indexPath.row]
            cell.textLabel?.text = contact.givenName + " " + contact.familyName
            cell.contact = self.attendees![indexPath.row]
            return cell
        } else {
            let cellIndentifier = "initialCell"
            let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIndentifier)
            cell!.textLabel?.text = indexPath.section == 1 ? "Add a Contact" : "Add a Group"
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.grayishColor()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! InitialAddAttendeesTableCell
        var indexOfContactToRemove : Int?

        if ((self.attendees?.contains(cell.contact!))! == true) {
            indexOfContactToRemove = self.attendees?.indexOf(cell.contact!)
            self.attendees?.removeAtIndex(indexOfContactToRemove!)
            if self.attendees?.count > 0 {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            } else {
                tableView.reloadData()
            }
        }
        self.resizeTable()
    }
    
    func resizeTable () {
        // Have to use this to set height for table view due to constraints used in story board.
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            let numberOfSections = self.tableView.numberOfSections
            var numberOfRows = 0
            for var i = 0; i < numberOfSections; i++ {
                numberOfRows += self.tableView.numberOfRowsInSection(i)
            }
            self.tableViewHeightConstraint.constant = CGFloat(numberOfRows + numberOfSections) * 40.0
            self.view.layoutIfNeeded()
        })
    }
    
    func addAttendeesComplete (button: UIBarButtonItem) {
        print("press")
        let indexOfPreviousVC = (self.navigationController?.childViewControllers.count)! - 2
        print(indexOfPreviousVC)
        let previousVC = self.navigationController?.childViewControllers[indexOfPreviousVC]
        self.navigationController?.popToViewController((previousVC)!, animated: true)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addAttendeesViewSegue" {
            let cell = sender as! UITableViewCell
            let destinationVC = segue.destinationViewController as! AddAttendeesViewController
            destinationVC.viewInContainerVC = cell.textLabel?.text == "Add a Contact" ? 0 : 1
        }
    }
}