//
//  IndividualGroupViewController.swift
//  SetADate
//
//  Created by Joshua  Tan on 31/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class IndividualGroupViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var group : Group?
    var detailsVC : UIViewController?
    var calendar : NSCalendar?
    @IBOutlet weak var individualGroupTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.calendar = NSCalendar.currentCalendar()
        
        self.individualGroupTable.dataSource = self
        self.individualGroupTable.delegate = self
        
        let frame = UIScreen.mainScreen().bounds

        let titleView = TitleSubtitleView(frame: CGRectMake(0, 0, frame.width / 3, 50), titleText: (self.group?.name)!, subtitleText: "Tap for more info")
        let tap = UITapGestureRecognizer(target: self, action: "titleViewTapped:")
        titleView.addGestureRecognizer(tap)
        self.navigationItem.titleView = titleView
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.detailsVC = storyboard.instantiateViewControllerWithIdentifier("groupDetailsVC")
        
        let buton = UIButton(frame: CGRectMake(0, 0, 40, 40))
        let image = UIImage(named: "testImage")
        buton.setImage(image, forState: .Normal)
        buton.addTarget(self, action: "changeGroupImage:", forControlEvents: .TouchUpInside)
        let barButton = UIBarButtonItem(customView: buton)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    
    func changeGroupImage (sender: UIButton) {
        print("implement imagepicker")
    }
    
    func titleViewTapped (sender: TitleSubtitleView) {
        self.navigationController?.pushViewController(self.detailsVC!, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.group?.events?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIndentifier = "individualGroupScreenCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier) as! IndividualGroupScreenCell
        let event = self.group?.events![indexPath.row]
        cell.eventNameLabel.text = event?.eventTitle
        cell.eventStartDateLabel.text = event?.eventStartDate?.dateString(self.calendar!)
        let timeText = (event?.eventStartDate?.timeString(self.calendar!))! + " - " + (event?.eventEndDate?.timeString(self.calendar!))!
        cell.eventTimeLabel.text = timeText
        cell.eventLocationLabel.text = event?.eventLocation
        
        return cell
    }
    
}