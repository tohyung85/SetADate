//
//  ContainerViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 4/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class ContainerViewController: UIViewController {
    
    var newView: Int?
    var currentView: Int?
    var containerViewControllers = [AnyObject]()
    
    var currentSegue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let calendarViewController = storyboard.instantiateViewControllerWithIdentifier("calendarView")
        
        self.addChildViewController(calendarViewController)
        calendarViewController.didMoveToParentViewController(self)
        self.containerViewControllers.append(calendarViewController)
        
        let groupsViewController = storyboard.instantiateViewControllerWithIdentifier("groupsView")
        self.addChildViewController(groupsViewController)
        groupsViewController.didMoveToParentViewController(self)
        self.containerViewControllers.append(groupsViewController)
        
        let pendingRequestsViewController = storyboard.instantiateViewControllerWithIdentifier("pendingRequestsView")
        self.addChildViewController(pendingRequestsViewController)
        pendingRequestsViewController.didMoveToParentViewController(self)
        self.containerViewControllers.append(pendingRequestsViewController)
        
        self.view.addSubview(calendarViewController.view)
        
    }
    
    func changeContainerView () {
        self.transitionFromViewController(self.containerViewControllers[self.currentView!] as! UIViewController, toViewController: self.containerViewControllers[self.newView!] as! UIViewController, duration: 0.0, options: .TransitionNone, animations: nil, completion: nil)
        self.currentView = self.newView
    }
}