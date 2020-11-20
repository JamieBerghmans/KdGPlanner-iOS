//
//  RoundedCorners.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 08/10/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import UIKit

class RoundedCorners: UIButton {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 7
    }

}
