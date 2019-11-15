//
//  ConstraintHelper.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 15/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import UIKit

class ConstraintsHelper {
    
    static func getConstraint(withIdentifier: String, view: UIView?) -> NSLayoutConstraint? {
        if let _view = view {
            if _view.constraints.count == 0 {
                return nil
            }
            
            if let constraint = (_view.constraints.first { (constraint) -> Bool in
                return constraint.identifier == withIdentifier
            }) {
                return constraint
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
}
