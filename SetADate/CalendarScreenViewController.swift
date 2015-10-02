//
//  CalendarScreenViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 27/9/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class CalendarScreenViewController: UIViewController, UITabBarDelegate, CalendarViewDelegate {

    @IBOutlet weak var selectionBar: UITabBar!
    @IBOutlet weak var calendarScreenBarButton: UITabBarItem!
    @IBOutlet weak var groupsBarButtonItems: UITabBarItem!
    @IBOutlet weak var pendingRequestsBarButtonItem: UITabBarItem!
    var calendarDayButtons: [CalendarDayButton] = [CalendarDayButton]()

    
    let themeBackGroundColor = UIColor(red: 59.0/255, green: 186.0/255, blue: 174.0/255, alpha: 1.0)
    let themeForeGroundColor = UIColor.whiteColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionBar.delegate = self
        selectionBar.selectedItem = selectionBar.items?.first
        performTabBarConfigurations()
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
    
    
    func tabBar(tabBar: UITabBar, willBeginCustomizingItems items: [UITabBarItem]) {
        tabBar.selectedItem = tabBar.items?.first
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        tabBar.selectedItem = item
    }
    
    func dayButtonClicked(button: CalendarDayButton) {
        for buttons in self.calendarDayButtons {
            let buttonState = buttons.dayButtonState!
            switch buttonState {
            case .Today:
                buttons.dayButtonState = .Today
            case .ChosenAndToday:
                buttons.dayButtonState = .Today
            default:
                buttons.dayButtonState = .Nothing
            }
            buttons.stateChanged()
        }
        if button.dayButtonState == .Today || button.dayButtonState == .ChosenAndToday {
            button.dayButtonState = .ChosenAndToday
        } else {
            button.dayButtonState = .Chosen
        }
        button.stateChanged()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == "displayContainerView" {
                let calendarVC = segue.destinationViewController as? CalendarViewController
                calendarVC!.masterVC = self
            }
        }
    }
}