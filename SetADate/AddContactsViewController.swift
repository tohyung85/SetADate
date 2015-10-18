//
//  AddContactsViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 17/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class AddContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var store: [CNContact]?
    var masterVC : CreateEventViewController?
    var contactsDictionary : [String : [CNContact]]?
    var contactsDictionaryKeys : [String]?
    var contactsSectionTitle : [String]?
    
    @IBOutlet weak var contactsTable: UITableView!
    
    let indexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T","U", "V", "W", "X" ,"Z", "#"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.store = [CNContact]()
        let contactStore = CNContactStore()
        self.contactsTable.delegate = self
        self.contactsTable.dataSource = self
        
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
                print(err)
            }
            if let store = self.store {
                self.contactsDictionaryKeys = [String]()
                self.contactsDictionary = self.classifyContactsIntoAlphabets(store, buckets: self.indexTitles)
                // TODO: PHONE NUMBERS TO LINK TO DATABASE AND CHECK IF EXISTING USER
                //                let phoneNumbers = contact.phoneNumbers
                //                for value in phoneNumbers {
                //                    let phoneNumber = value.value as! CNPhoneNumber
                //                    print("labels: %@, value:%@", value.label, phoneNumber.stringValue)
                //                }
            }

            print("Contacts access authorised")
        case .Denied:
            print("Contacts access denied")
            // TODO: FREEZE UI
        case .NotDetermined:
            contactStore.requestAccessForEntityType(.Contacts, completionHandler: {(Bool, NSError) in
                print("authorization success? :%@", Bool)
            })
        case .Restricted:
            print("Contacts access restricted")
            // TODO: FREEZE UI
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionAlphabet = self.contactsDictionaryKeys![section]
        if let contactDictionary = self.contactsDictionary {
            let contactsInSection = contactDictionary[sectionAlphabet]
            return (contactsInSection?.count)!
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        let sectionAlphabet = self.contactsDictionaryKeys![indexPath.section]
        let contactsInSection = self.contactsDictionary![sectionAlphabet]
        let contact = contactsInSection![indexPath.row]
        cell?.textLabel?.text = contact.givenName + " " + contact.familyName
        cell?.detailTextLabel?.text = "Number"
        return cell!
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.contactsDictionaryKeys!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.contactsDictionaryKeys![section]
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.indexTitles
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {

        var sectionToShow = self.indexTitles.indexOf(title)!
        var nearestLargeAlphabet = sectionToShow
        var nearestSmallAlphabet = sectionToShow
        
        outerloop : for var i = sectionToShow ; i < self.indexTitles.count ; i++ {
            for key in self.contactsDictionaryKeys! {
                if self.indexTitles[i] == key {
                    nearestLargeAlphabet = i
                    break outerloop
                }
            }
        }
        
        outerloop: for var i = sectionToShow ; i > 0 ; i-- {
            for key in self.contactsDictionaryKeys! {
                if self.indexTitles[i] == key {
                    nearestSmallAlphabet = i
                    break outerloop
                }
            }
        }
        
        if nearestSmallAlphabet == nearestLargeAlphabet {
            sectionToShow = nearestLargeAlphabet
        } else {
            sectionToShow = nearestLargeAlphabet - sectionToShow > sectionToShow - nearestSmallAlphabet ? nearestSmallAlphabet : nearestLargeAlphabet
        }
        
        return sectionToShow
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexOfPreviousVC = (self.navigationController?.childViewControllers.count)! - 2
        print(indexOfPreviousVC)
        let previousVC = self.navigationController?.childViewControllers[indexOfPreviousVC]
        self.navigationController?.popToViewController((previousVC)!, animated: true)
    }
    
    func classifyContactsIntoAlphabets (store: [CNContact], buckets: [String]) -> [String : [CNContact]] {
        var returnDictionary = [String : [CNContact]]()
        
        for sectionLabel in buckets {
            let dictionaryKey = sectionLabel
            var contactArray = [CNContact]()
            for contact in store {
                if contact.familyName.getFirstLetter() == sectionLabel {
                    contactArray.append(contact)
                }
            }
            if contactArray.isEmpty == false {
                returnDictionary[dictionaryKey] = contactArray
                self.contactsDictionaryKeys?.append(dictionaryKey)
            }
        }
        
        for contact in store {
            var contactArray = [CNContact]()
            if buckets.contains(contact.familyName.getFirstLetter()) == false {
                contactArray.append(contact)
            }
            if contactArray.isEmpty == false {
                returnDictionary["#"] = contactArray
                self.contactsDictionaryKeys?.append("#")
            }
        }
        
        return returnDictionary
    }
}
