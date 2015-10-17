//
//  AttendeesContainerViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 17/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class AttendeesContainerViewController: UIViewController {

    var newView: Int?
    var currentView: Int?
    var containerViewControllers = [AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addContactsViewController = storyboard.instantiateViewControllerWithIdentifier("addContactsView")
        
        self.addChildViewController(addContactsViewController)
        addContactsViewController.didMoveToParentViewController(self)
        self.containerViewControllers.append(addContactsViewController)
        
        let addGroupsViewController = storyboard.instantiateViewControllerWithIdentifier("addGroupsView")
        self.addChildViewController(addGroupsViewController)
        addGroupsViewController.didMoveToParentViewController(self)
        self.containerViewControllers.append(addGroupsViewController)
        
        self.view.addSubview(addContactsViewController.view)
        
    }
    
    func changeContainerView () {
        self.transitionFromViewController(self.containerViewControllers[self.currentView!] as! UIViewController, toViewController: self.containerViewControllers[self.newView!] as! UIViewController, duration: 0.0, options: .TransitionNone, animations: nil, completion: nil)
        self.currentView = self.newView
    }
}