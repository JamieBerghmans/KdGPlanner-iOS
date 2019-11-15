//
//  SegmentedControlFilter.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 08/10/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import UIKit

class SegmentedControlFilter: UISegmentedControl {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
    }

}
