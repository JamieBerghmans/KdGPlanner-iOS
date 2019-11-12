//
//  ClassroomCell.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 12/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import UIKit

class ClassroomCell: UITableViewCell {

    @IBOutlet private weak var roomLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var endLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var clockImageView: UIImageView!
    @IBOutlet weak var alarmImageView: UIImageView!
    
    public func setRoomLabelText(text: String) {
        self.roomLabel.text = text
    }
    
    public func setDurationLabelText(text: String) {
        self.durationLabel.text = text
    }
    
    public func setEndLabelText(text: String) {
        self.endLabel.text = text
    }
    
    public func set(hidden: Bool) {
        self.bookImageView.isHidden = hidden
        self.clockImageView.isHidden = hidden
        self.alarmImageView.isHidden = hidden
    }
}
