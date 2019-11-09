//
//  ViewController.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 11/09/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    //Consts
    let DATE_PICKER_HEIGHT: CGFloat = 250
    
    //Variables
    let campusTag = "campusKey"
    let availabilityTag = "availabilityKey"
    var datePickerViewOpen = 0
    
    //Popup views used
    var background: UIView?
    @IBOutlet var datePickerView: UIView!
    
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
        
        initializePopups()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        //DatePickerView
        self.datePickerView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self.datePickerView!, attribute: .width, relatedBy: .equal, toItem: self.datePickerView!.superview!, attribute: .width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: self.datePickerView!, attribute: .height, relatedBy: .equal, toItem: self.datePickerView!.superview!, attribute: .height, multiplier: 0, constant: DATE_PICKER_HEIGHT)
        let bottomConstraint = NSLayoutConstraint(item: self.datePickerView!, attribute: .bottom, relatedBy: .equal, toItem: self.datePickerView!.superview!, attribute: .bottom, multiplier: 1, constant: DATE_PICKER_HEIGHT)
        bottomConstraint.identifier = "datePickerViewBottomConstraint"
        self.datePickerView!.superview!.addConstraints([widthConstraint, heightConstraint, bottomConstraint])
        //NSLayoutConstraint.activate([widthConstraint, heightConstraint, bottomConstraint])
    }
    
    func initializePopups() {
        //Background
        self.background = UIView(frame: UIApplication.shared.keyWindow!.frame)
        self.background!.alpha = 0
        self.background!.backgroundColor = UIColor.black
        UIApplication.shared.keyWindow!.addSubview(background!)
        let closeBackgroundTap = UITapGestureRecognizer(target: self, action: #selector(closePopups))
        self.background!.addGestureRecognizer(closeBackgroundTap)
        
        //DatePickerView
        UIApplication.shared.keyWindow!.addSubview(self.datePickerView)
    }
    
    @objc func closePopups() {
        if self.background!.alpha < 0.4 {
            return
        }
        
        
        
        if datePickerViewOpen == 1 {
            let constraint = self.datePickerView!.superview!.constraints.first { (constraint) -> Bool in
                return constraint.identifier == "datePickerViewBottomConstraint"
            }
            
            constraint!.constant = DATE_PICKER_HEIGHT
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.datePickerView!.superview!.layoutIfNeeded()
            }, completion: nil)
        }
        
        
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.background!.alpha = 0
        }, completion: {(Bool) in
            self.datePickerViewOpen = 0
        })
        
        self.datePickerViewOpen = 0
    }
    
    @IBAction func searchButtonTap(_ sender: Any) {
        let constraint = self.datePickerView!.superview!.constraints.first { (constraint) -> Bool in
            return constraint.identifier == "datePickerViewBottomConstraint"
        }
        
        constraint!.constant = 0
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.background!.alpha = 0.4
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.datePickerView!.superview!.layoutIfNeeded()
        }, completion: {(Bool) in
            self.datePickerViewOpen = 1
        })
    }
}

