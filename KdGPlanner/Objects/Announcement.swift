//
//  Announcement.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 12/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import Foundation

class Announcement {
    private var id: Int
    private var text: String?
    private var announcementType: Int?
    
    public var Id: Int {
        get {
            return self.id
        }
    }
    
    public var Text: String? {
        get {
            return self.text
        }
        set {
            self.text = newValue
        }
    }
    
    public var AnnouncementType: Int? {
        get {
            return self.announcementType
        }
        set {
            self.announcementType = newValue
        }
    }
    
    init(id: Int) {
        self.id = id
    }
}
