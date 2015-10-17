//
//  AddAttendeesViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 17/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class AddAttendeesViewController: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var selectionBar: UITabBar!
    
    var containerVC : AttendeesContainerViewController?
    
    let themeBackGroundColor = UIColor(red: 59.0/255, green: 186.0/255, blue: 174.0/255, alpha: 1.0)
    let themeForeGroundColor = UIColor.whiteColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectionBar.delegate = self
        performTabBarConfigurations()
        self.selectionBar.selectedItem = self.selectionBar.items?.first
        
        // To remove shadow image of navigation view controller and hence the underline of the bar
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
    }
    
    
    ///////////////////////////////
    // TAB BAR FUNCTIONS
    ///////////////////////////////
    
    
    func performTabBarConfigurations() {
        // Sets default text color of tab bar items
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : self.themeBackGroundColor], forState: UIControlState.Normal)
        
        // Sets selected text color of tab bar items
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : self.themeForeGroundColor], forState: UIControlState.Selected)
        
        //Removes default grey shadow of tab bar
        self.selectionBar.clipsToBounds = true
        
        // Sets the background color of the selected UITabBarItem (using and plain colored UIImage with the width = 1/3 of the tabBar (if you have 3 items) and the height of the tabBar)
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(self.themeBackGroundColor, size: CGSizeMake(self.selectionBar.frame.width/2, self.selectionBar.frame.height))
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == "displayAttendeesContainerView" {
                self.containerVC = segue.destinationViewController as? AttendeesContainerViewController
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