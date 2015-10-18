//
//  InitialAddAttendeesViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 18/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class InitialAddAttendeesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var addAttendeesCompleteBarButton : UIBarButtonItem?
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Attendees"
        let barButton = UIBarButtonItem(title: "Add", style: .Done, target: self, action: "addAttendeesComplete:")
        self.navigationItem.rightBarButtonItem = barButton
        self.tableView.dataSource = self
        self.tableView.delegate = self

        // Have to use this to set height for table view due to constraints used in story board.
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            self.tableViewHeightConstraint.constant = CGFloat(self.tableView.numberOfRowsInSection(0)) * 40.0
            self.view.layoutIfNeeded()
        })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        return cell!
    }
    
    func addAttendeesComplete (button: UIBarButtonItem) {
        print("press")
        let indexOfPreviousVC = (self.navigationController?.childViewControllers.count)! - 2
        print(indexOfPreviousVC)
        let previousVC = self.navigationController?.childViewControllers[indexOfPreviousVC]
        self.navigationController?.popToViewController((previousVC)!, animated: true)
    }
    
}