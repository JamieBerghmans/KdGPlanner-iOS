//
//  Classroom.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 12/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import Foundation

class Classroom: NSObject, NSCoding, NSSecureCoding {

    var room: String
    var duration: Date?
    var end: Date?
    static var supportsSecureCoding: Bool = true
    
    init(room: String) {
        self.room = room
    }
    
    convenience init(room: String, duration: Date?, end: Date?) {
        self.init(room: room)
        self.duration = duration
        self.end = end
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(room, forKey: "room")
        coder.encode(duration, forKey: "duration")
        coder.encode(end, forKey: "end")
    }
    
    required init?(coder: NSCoder) {
        room = coder.decodeObject(forKey: "room") as! String
        duration = coder.decodeObject(forKey: "duration") as? Date
        end = coder.decodeObject(forKey: "end") as? Date
    }
}
