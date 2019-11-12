//
//  AnnouncementDTO.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 12/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import Foundation

class AnnouncementDTO: Decodable {
    private var id: Int
    private var text: String?
    private var startPublicationTime: String?
    private var endPublicationTime: String?
    private var announcementType: Int?
    private var platform: Int?
    
    public var Id: Int {
        get {
            return self.id
        }
    }
    
    public var Text: String? {
        get {
            return self.text
        }
    }
    
    public var StartPublicationTime: String? {
        get {
            return self.startPublicationTime
        }
    }
    
    public var EndPublicationTime: String? {
        get {
            return self.endPublicationTime
        }
    }
    
    public var AnnouncementType: Int? {
        get {
            return self.announcementType
        }
    }
    
    public var Platform: Int? {
        get {
            return self.platform
        }
    }
    
    init(id: Int) {
        self.id = id
    }
}
