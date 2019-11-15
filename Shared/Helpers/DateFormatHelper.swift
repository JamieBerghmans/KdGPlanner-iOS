//
//  DateFormatHelper.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 14/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import Foundation

class DateFormatHelper {
    static func dateToString(type: DateType, date: Date) -> String {
        if type == DateType.DURATION {
            return dateToDurationString(date: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = type.format
            return formatter.string(from: date)
        }
    }
    
    static func stringToDate(type: DateType, string: String) -> Date {
        if type == DateType.DURATION {
            return Date()
        }
        let formatter = DateFormatter()
        formatter.dateFormat = type.format
        return formatter.date(from: string)!
    }
    
    private static func dateToDurationString(date: Date) -> String {
        var text = ""
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        
        
        if hour > 0 {
            text += "\(hour) hour"
            if hour > 1 {
                text += "s"
            }
            
            if minute > 0 {
                text += " and "
            }
        }
        
        if minute > 0 {
            text += "\(minute) minute"
            
            if minute > 1 {
                text += "s"
            }
        }
        
        if hour == 0, minute == 0 {
            text += "0 hours and 0 minutes"
        }
        
        return text
    }
}
