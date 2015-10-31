//
//  TitleSubtitleView.swift
//  SetADate
//
//  Created by Joshua  Tan on 31/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class TitleSubtitleView : UIView {

    var titleLabel : UILabel?
    var subtitleLabel : UILabel?
    
    init(frame: CGRect, titleText: String, subtitleText: String) {
        super.init(frame: frame)
        
        self.titleLabel = UILabel(frame: CGRectMake(0, 5, self.frame.width, self.frame.height / 2.0))
        self.subtitleLabel = UILabel(frame: CGRectMake(0, self.frame.height / 2.0, self.frame.width, self.frame.height/2.0))
        if let titleLabel = self.titleLabel {
            titleLabel.text = titleText
            titleLabel.textAlignment = .Center
            titleLabel.font = UIFont.boldSystemFontOfSize(16.0)
            titleLabel.textColor = UIColor.whiteColor()
            self.addSubview(titleLabel)
        }
        if let subtitleLabel = self.subtitleLabel {
            subtitleLabel.text = subtitleText
            subtitleLabel.font = UIFont.boldSystemFontOfSize(13.0)
            subtitleLabel.textAlignment = .Center
            subtitleLabel.textColor = UIColor.whiteColor()
            self.addSubview(subtitleLabel)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("view implemented programmatically only")
    }

}