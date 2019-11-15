//
//  AnnouncementDTO.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 12/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import Foundation

class AnnouncementDTO: Decodable {
    var id: Int!
    var text: String!
    var startPublicationTime: String!
    var endPublicationTime: String!
    var announcementType: Int?
    var platform: Int?
}
