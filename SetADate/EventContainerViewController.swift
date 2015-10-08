//
//  EventContainerViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 7/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class EventContainerViewController: UIViewController {
    var newView: Int?
    var currentView: Int?
    var containerViewControllers = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let eventViewController = storyboard.instantiateViewControllerWithIdentifier("eventVC")
        
        self.addChildViewController(eventViewController)
        eventViewController.didMoveToParentViewController(self)
        self.containerViewControllers.append(eventViewController)
        
        let deadlineViewController = storyboard.instantiateViewControllerWithIdentifier("deadlineVC")
        self.addChildViewController(deadlineViewController)
        deadlineViewController.didMoveToParentViewController(self)
        self.containerViewControllers.append(deadlineViewController)
        
        self.view.addSubview(eventViewController.view)
        
    }
    
    func changeContainerView () {
        self.transitionFromViewController(self.containerViewControllers[self.currentView!] as! UIViewController, toViewController: self.containerViewControllers[self.newView!] as! UIViewController, duration: 0.0, options: .TransitionNone, animations: nil, completion: nil)
        self.currentView = self.newView
    }
}