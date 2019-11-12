//
//  ClassroomDTO.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 12/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import Foundation

class ClassroomDTO: Decodable {
    private var classroom: String?
    private var availability: String?
    private var endAvailability: String?
    
    public var Room: Any? {
        get {
            return self.classroom
        }
    }
    
    public var Duration: Any? {
        get {
            return self.availability
        }
    }
    
    public var End: Any? {
        get {
            return self.endAvailability
        }
    }

}
