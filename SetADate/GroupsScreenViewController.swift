//
//  GroupsScreenViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 4/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class GroupsScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var groupsTable: UITableView!
    
    var groupStore : GroupStore?
    var calendar : NSCalendar?
    let contactStore = CNContactStore()
    var store : [CNContact]?
    
    override func viewDidLoad() {
        self.store = [CNContact]()
        self.groupsTable.dataSource = self
        self.groupsTable.delegate = self
        
        
        switch CNContactStore.authorizationStatusForEntityType(.Contacts) {
        case .Authorized:
            let keysToFetch = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey]
            let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
            fetchRequest.sortOrder = .FamilyName
            do {
                try contactStore.enumerateContactsWithFetchRequest(fetchRequest) {
                    contact, stop in
                    self.store?.append(contact)
                }
            } catch let err {
                print("error")
                print(err)
            }
            if let store = self.store {
                print("store loaded: %@", store)
            }
            print("Contacts access authorised")
        case .NotDetermined:
            contactStore.requestAccessForEntityType(.Contacts, completionHandler: {(Bool, NSError) in
                print("authorization success? :%@", Bool)
                self.viewDidLoad()
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.viewWillAppear(true)
                })
            })
        case .Denied, .Restricted:
            print("Contacts access authorised")
            break
        }
        print("view did load")
    

    
        
        self.calendar = NSCalendar.currentCalendar()
        let today = NSDate()
        let components = self.calendar!.dayMonthYearComponentsFromDate(today)
        components.day += 1
        let tomorrow = self.calendar?.dateFromComponents(components)
        let event = EventObject (eventTitle: "Assemble", eventLocation: "Stark Tower", eventStartDate: today, eventEndDate: tomorrow!, alerts: ["Every Week" : 60 * 24 * 7], repeats: ["Every Week" : 60 * 24 * 7], notes: "NA")
        let group = Group(name: "Avengers", contacts: self.store!)
        group.events = [event]
        self.groupStore = GroupStore(groups: [group])
    }
    
    override func viewWillAppear(animated: Bool) {
        switch CNContactStore.authorizationStatusForEntityType(.Contacts) {
        case .Restricted, .Denied :
            let alertController = UIAlertController(title: "Access to Contacts Required!", message: "Please provide access via Settings -> Privacy -> Contacts", preferredStyle: .Alert)
            print("Contacts access denied")
            let alertAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    
    ///////////////////////////////
    // TABLE VIEW FUNCTIONS
    ///////////////////////////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.groupStore?.groups.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "groupsScreenCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! GroupsScreenTableCell
        let group = self.groupStore?.groups[indexPath.row]
        cell.groupNameLabel.text = group?.name
        return cell
        
    }
    
    
    
    @IBAction func newGroupButtonPressed(sender: UIButton) {
    }
    
    @IBAction func editButtonPressed(sender: UIButton) {
    }
    
    
}