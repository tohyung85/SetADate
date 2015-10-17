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

class AddContactsViewController: UIViewController {
    
    var store: [CNContact]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.store = [CNContact]()
        let contactStore = CNContactStore()
        
        switch CNContactStore.authorizationStatusForEntityType(.Contacts) {
        case .Authorized:
            let keysToFetch = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey]
            let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
            fetchRequest.sortOrder = .FamilyName
            do {
                try contactStore.enumerateContactsWithFetchRequest(fetchRequest) {
                    contact, stop in
//                    print(contact.familyName)
//                    print(contact.givenName)
//                    print(contact.identifier)
//                    print(contact.phoneNumbers)
                    self.store?.append(contact)
                }
            } catch let err {
                print(err)
            }

            print("Contacts access authorised")
        case .Denied:
            print("Contacts access denied")
        case .NotDetermined:
            contactStore.requestAccessForEntityType(.Contacts, completionHandler: {(Bool, NSError) in
                print("authorization success? :%@", Bool)
            })
        case .Restricted:
            print("Contacts access restricted")

        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        if let store = self.store {
            for contact in store {
                print("family name: %@", contact.familyName)
                print("given name: %@", contact.givenName)
                let phoneNumbers = contact.phoneNumbers
                for value in phoneNumbers {
                    let phoneNumber = value.value as! CNPhoneNumber
                    print("labels: %@, value:%@", value.label, phoneNumber.stringValue)
                }
            }
        }
    }
}