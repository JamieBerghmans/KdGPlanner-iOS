//
//  ClassroomDTO.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 12/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import Foundation

class ClassroomDTO: Decodable {
    var classroom: String!
    var availability: String?
    var endAvailability: String?
}
