//
//  Classroom.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 12/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import Foundation

class Classroom {
    var room: String
    var duration: Date?
    var end: Date?
    
    init(room: String) {
        self.room = room
    }
    
    convenience init(room: String, duration: Date?, end: Date?) {
        self.init(room: room)
        self.duration = duration
        self.end = end
    }
}
