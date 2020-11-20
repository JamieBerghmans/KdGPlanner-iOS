//
//  Announcement.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 12/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import Foundation

class Announcement {
    var id: Int
    var text: String?
    var announcementType: Int?
    
    init(id: Int) {
        self.id = id
    }
}
