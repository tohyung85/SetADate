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

class InitialAddAttendeesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    var addAttendeesCompleteBarButton : UIBarButtonItem?
    var attendees : [CNContact]?
    var textViewHeight : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Attendees"
        let barButton = UIBarButtonItem(title: "Add", style: .Done, target: self, action: "addAttendeesComplete:")
        self.navigationItem.rightBarButtonItem = barButton
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.attendees = [CNContact]()
        self.textViewHeight = 40.0
        
        // Have to use this to set height for table view due to constraints used in story board.
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            self.tableViewHeightConstraint.constant = CGFloat(self.tableView.numberOfRowsInSection(0)) * 44.0
            self.view.layoutIfNeeded()
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        for contact in self.attendees! {
            print(contact.givenName)
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! InitialAddAttendeesTableCell
        cell.attendeesTextField.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.textViewHeight!
    }
    
    func addAttendeesComplete (button: UIBarButtonItem) {
        print("press")
        let indexOfPreviousVC = (self.navigationController?.childViewControllers.count)! - 2
        print(indexOfPreviousVC)
        let previousVC = self.navigationController?.childViewControllers[indexOfPreviousVC]
        self.navigationController?.popToViewController((previousVC)!, animated: true)
    }
    
    
    func textViewDidChange(textView: UITextView) {
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! InitialAddAttendeesTableCell
        let contentSize = cell.attendeesTextField.sizeThatFits(cell.attendeesTextField.bounds.size)
        var frame = cell.attendeesTextField.frame
        frame.size.height = contentSize.height
        cell.attendeesTextField.frame = frame
        self.textViewHeight = cell.attendeesTextField.frame.size.height
        
        self.tableView.beginUpdates() // Used to animate updates to cell height
        self.tableView.endUpdates() // cannot use reloaddata() or the cell will be gone and textview cease to be first responder
        
        // Have to use this to set height for table view due to constraints used in story board.
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            self.tableViewHeightConstraint.constant = cell.attendeesTextField.frame.size.height
            print(cell.attendeesTextField.frame.height)
            self.view.layoutIfNeeded()
        })
    }
    
}