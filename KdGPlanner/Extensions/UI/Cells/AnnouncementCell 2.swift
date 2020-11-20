//
//  NotificationCell.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 12/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import UIKit

class AnnouncementCell: UITableViewCell {
    
    private var id: Int?
    @IBOutlet private weak var announcementImageView: UIImageView!
    @IBOutlet private weak var AnnouncementHeaderTextField: UILabel!
    @IBOutlet private weak var AnnouncementDescriptionTextField: UILabel!
    
    public func setWarningLevel(level: Int) {
        switch (level) {
            case 1:
                self.AnnouncementHeaderTextField.text = "Danger"
                self.AnnouncementHeaderTextField.textColor = .red
                self.announcementImageView.image = UIImage(named: "icon_announcement_error")?.withRenderingMode(.alwaysTemplate)
                self.announcementImageView.tintColor = .red
                break
            case 2:
                self.AnnouncementHeaderTextField.text = "Warning"
                self.AnnouncementHeaderTextField.textColor = .orange
                self.announcementImageView.image = UIImage(named: "icon_announcement_warning")?.withRenderingMode(.alwaysTemplate)
                self.announcementImageView.tintColor = .orange
                break
            default:
                self.AnnouncementHeaderTextField.text = "Info"
                if #available(iOS 13.0, *) {
                    self.AnnouncementHeaderTextField.textColor = .label
                } else {
                    // Fallback on earlier versions
                    self.AnnouncementHeaderTextField.textColor = .black
                }
                self.announcementImageView.image = UIImage(named: "icon_announcement_normal")
                return
        }
    }
    
    public func setDescription(text: String) {
        self.AnnouncementDescriptionTextField.text = text
    }
    
    public var Id: Int {
        get {
            return self.id!
        }
        set {
            self.id = newValue
        }
    }
}
