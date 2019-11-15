//
//  DateFormatterType.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 14/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import Foundation

struct DateType {
    
    static let DATE = DateType(format: "EEEE dd LLL HH:mm")
    static let TIME = DateType(format: "HH:mm")
    static let API = DateType(format: "HH:mm:ss")
    static let DTO_TIME = DateType(format: "yyyy/MM/dd%20HH:mm")
    static let DTO_DATE = DateType(format: "yyyy-MM-dd'T'HH:mm:ss")
    static let DURATION = DateType(format: "duration")
    
    var format: String
    
    private init(format: String) {
        self.format = format
    }
    
    static func ==(lhs: DateType, rhs: DateType) -> Bool {
        return lhs.format == rhs.format
    }
}
