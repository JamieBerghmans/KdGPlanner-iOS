//
//  Classroom.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 12/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import Foundation

class Classroom {
    private var room: String
    private var duration: Date?
    private var end: Date?
    
    public var Room: String {
        get {
            return self.room
        }
        set {
            self.room = newValue
        }
    }
    
    public var Duration: Date? {
        get {
            return self.duration
        }
        set {
            self.duration = newValue
        }
    }
    
    public var End: Date? {
        get {
            return self.end
        }
        set {
            self.end = newValue
        }
    }
    
    init(room: String) {
        self.room = room
    }
    
    convenience init(room: String, duration: Date?, end: Date?) {
        self.init(room: room)
        self.duration = duration
        self.end = end
    }
}
