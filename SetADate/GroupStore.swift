//
//  GroupStore.swift
//  SetADate
//
//  Created by Joshua  Tan on 28/10/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import Foundation
import UIKit

class GroupStore : NSObject {
    var groups : [Group]
    
    init(groups: [Group]) {
        self.groups = groups
    }
    
    convenience override init() {
        let groups = [Group]()
        self.init(groups: groups)
    }
}