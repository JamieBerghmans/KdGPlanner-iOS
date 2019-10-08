//
//  ViewController.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 11/09/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Variables
    let campusTag = "campusKey"
    let availabilityTag = "availabilityKey"
    
    //Linked to storyboard views
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var campusPickerTextField: UITextField!
    @IBOutlet weak var minimumAvailabilityPickerTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get current date
        let date = Date()
        let dateFormatter = DateFormatter()
        
        //Set custom date format
        dateFormatter.dateFormat = "EEEE dd LLL HH:mm"
        self.datePickerTextField.text = dateFormatter.string(from: date)
        
        //Load user saved preferences
        let defaults = UserDefaults.standard
        
        //Check if a different campus was previously selected
        if let campus = defaults.string(forKey: campusTag) {
            self.campusPickerTextField.text = campus
        }
        
        //Check if a different minimum availability was previously selected
        if let availability = defaults.string(forKey: availabilityTag) {
            self.minimumAvailabilityPickerTextField.text = availability
        }
    }
}

