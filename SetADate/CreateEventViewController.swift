//
//  CreateEventViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 7/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class CreateEventViewController: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var createEventSelectionBar: UITabBar!
    var eventContainerVC : EventContainerViewController?
    
    let themeBackGroundColor = UIColor(red: 59.0/255, green: 186.0/255, blue: 174.0/255, alpha: 1.0)
    let themeForeGroundColor = UIColor.whiteColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createEventSelectionBar.delegate = self
        performTabBarConfigurations()
    }
    
    override func viewWillAppear(animated: Bool) {
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(self.themeBackGroundColor, size: CGSizeMake(createEventSelectionBar.frame.width/2, createEventSelectionBar.frame.height))
    }
    
    
    func performTabBarConfigurations() {
        // Sets default text color of tab bar items
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : self.themeBackGroundColor], forState: UIControlState.Normal)
        
        // Sets selected text color of tab bar items
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : self.themeForeGroundColor], forState: UIControlState.Selected)
        
        //Removes default grey shadow of tab bar
        createEventSelectionBar.clipsToBounds = true
        
        // Sets the background color of the selected UITabBarItem (using and plain colored UIImage with the width = 1/3 of the tabBar (if you have 3 items) and the height of the tabBar)
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(self.themeBackGroundColor, size: CGSizeMake(createEventSelectionBar.frame.width/3, createEventSelectionBar.frame.height))
        
        // Sets default tab bar image colors
        for item in (self.createEventSelectionBar.items)! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(self.themeBackGroundColor).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        self.eventContainerVC?.newView = self.createEventSelectionBar.items?.indexOf(item)
        self.eventContainerVC!.changeContainerView()
        tabBar.selectedItem = item
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == "eventContainerView" {
                self.eventContainerVC = segue.destinationViewController as? EventContainerViewController
                if let eventContainerVC = self.eventContainerVC {
                    // note: prepareForSegue called before viewDidLoad
                    if self.createEventSelectionBar.selectedItem == nil {
                        self.createEventSelectionBar.selectedItem = self.createEventSelectionBar.items?.first
                    }
                    let itemSelected = self.createEventSelectionBar.selectedItem
                    eventContainerVC.currentView = self.createEventSelectionBar.items?.indexOf(itemSelected!)
                }
            }
        }
    }

    
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        print("dismissing view controller")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

