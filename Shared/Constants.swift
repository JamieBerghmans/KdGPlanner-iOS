//
//  Constants.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 14/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

class Constants {
    static let DATE_PICKER_HEIGHT = 250
    static let CAMPUS_PICKER_HEIGHT = 200
    static let DURATION_PICKER_HEIGHT = 250
    static let ANIMATION_DURATION = 0.1
    static let CONSTRAINTS_DATE_PICKERVIEW_BOTTOM = "datePickerViewBottomConstraint"
    static let CONSTRAINTS_CAMPUS_PICKERVIEW_BOTTOM = "campusPickerViewBottomConstraint"
    static let CONSTRAINTS_DURATION_PICKERVIEW_BOTTOM = "durationPickerViewBottomConstraint"
    static let LIST_CAMPUSSES = ["Groenplaats", "Pothoek", "Stadswaag"]
    static let CAMPUSSES = ["Groenplaats": "GR", "Pothoek": "PH", "Stadswaag": "SW"]
    static let API_BASE = "https://kdgplanner.be/api"
    static let API_LESSONS = "/Lessons?"
    static let API_ANNOUNCEMENT = "/Announcement"
    static let TAGS_CAMPUS = "campusKey"
    static let TAGS_DURATION = "availabilityKey"
    static let TAGS_ANNOUNCEMENTS = "announcementsKey"
}
