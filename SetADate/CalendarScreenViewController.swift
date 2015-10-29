//
//  CalendarScreenViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 27/9/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class CalendarScreenViewController: UIViewController, UITabBarDelegate{

    @IBOutlet weak var selectionBar: UITabBar!
    @IBOutlet weak var calendarScreenBarButton: UITabBarItem!
    @IBOutlet weak var groupsBarButtonItems: UITabBarItem!
    @IBOutlet weak var pendingRequestsBarButtonItem: UITabBarItem!
    
    var containerVC : ContainerViewController?
    
    let themeBackGroundColor = UIColor(red: 59.0/255, green: 186.0/255, blue: 174.0/255, alpha: 1.0)
    let themeForeGroundColor = UIColor.whiteColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionBar.delegate = self
        performTabBarConfigurations()
        
        // To remove shadow image of navigation view controller and hence the underline of the bar
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
        
//        self.navigationItem.title = "Add Attendees"
        let barButton = UIBarButtonItem(title: "Settings", style: .Done, target: self, action: "settingsButtonPressed:")
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    override func viewWillAppear(animated: Bool) {
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(self.themeBackGroundColor, size: CGSizeMake(selectionBar.frame.width/3, selectionBar.frame.height))
    }
    
    func performTabBarConfigurations() {
        // Sets default text color of tab bar items
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : self.themeBackGroundColor], forState: UIControlState.Normal)
        
        // Sets selected text color of tab bar items
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : self.themeForeGroundColor], forState: UIControlState.Selected)
        
        //Removes default grey shadow of tab bar
        selectionBar.clipsToBounds = true
        
        // Sets the background color of the selected UITabBarItem (using and plain colored UIImage with the width = 1/3 of the tabBar (if you have 3 items) and the height of the tabBar)
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(self.themeBackGroundColor, size: CGSizeMake(selectionBar.frame.width/3, selectionBar.frame.height))
        
        // Sets default tab bar image colors
        for item in (self.selectionBar.items)! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(self.themeBackGroundColor).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        self.containerVC?.newView = self.selectionBar.items?.indexOf(item)
        // Don't present the same view controller twice!
        // Prevent Unbalanced calls to begin/end appearance transitions error
        if self.containerVC?.newView != self.containerVC?.currentView {
            self.containerVC!.changeContainerView()
        }
        tabBar.selectedItem = item

    }
    
    func settingsButtonPressed () {
        print("settings")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == "displayContainerView" {
                self.containerVC = segue.destinationViewController as? ContainerViewController
                if let containerVC = self.containerVC {
                    // note: prepareForSegue called before viewDidLoad
                    if self.selectionBar.selectedItem == nil {
                        self.selectionBar.selectedItem = self.selectionBar.items?.first
                    }
                    let itemSelected = self.selectionBar.selectedItem
                    containerVC.currentView = self.selectionBar.items?.indexOf(itemSelected!)
                }
            }
        }
    }
    
}