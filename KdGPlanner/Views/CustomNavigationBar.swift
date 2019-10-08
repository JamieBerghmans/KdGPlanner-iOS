//
//  CustomNavigationBar.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 11/09/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.barTintColor = UIColor(red: 32/255, green: 117/255, blue: 192/255, alpha: 1)
        self.tintColor = .white
        self.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }

}
