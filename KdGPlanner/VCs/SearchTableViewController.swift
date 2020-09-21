//
//  ViewController.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 11/09/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    //Images
    @IBOutlet weak var iconClockImageView: UIImageView!
    @IBOutlet weak var iconLocationImageView: UIImageView!
    @IBOutlet weak var iconDurationImageView: UIImageView!
    
    //Table data
    var classroomList: [Classroom] = []
    var announcement: Announcement?
    
    //Variables
    var datePickerViewOpen = false
    var campusPickerViewOpen = false
    var durationPickerViewOpen = false
    
    var selectedDate: Date = Date()
    var previousDate: Date?
    
    var selectedCampus: String?
    var previousCampus: String?
    
    var selectedDuration: Date?
    var previousDuration: Date?
    
    let webHelper = WebHelper()
    
    
    //Popup views used
    var background: UIView?
    @IBOutlet var datePickerView: UIView!
    @IBOutlet var campusPickerView: UIView!
    @IBOutlet var durationPickerView: UIView!
    
    
    //Linked to storyboard views
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var campusPickerTextField: UITextField!
    @IBOutlet weak var minimumAvailabilityPickerTextField: UITextField!
    @IBOutlet weak var segmentedControl: SegmentedControlFilter!
    
    
    //DatePickerView
    @IBOutlet weak var datePickerViewDatePicker: UIDatePicker!
    
    
    //CampusPickerView
    @IBOutlet weak var campusPickerViewPicker: UIPickerView!
    
    
    //DurationPickerView
    @IBOutlet weak var durationPickerViewPicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        if #available(iOS 13.0, *) {
            tableView.separatorColor = .quaternarySystemFill
        }
        
        //Set custom date format
        initializePopups()

        campusPickerViewPicker.delegate = self
        campusPickerViewPicker.dataSource = self
        
        //Load user saved preferences
        loadDefaultValues()
        reload(refresh: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onResume), name:
        UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        //DatePickerView
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        let leftDatePickerViewConstraint = NSLayoutConstraint(item: datePickerView!, attribute: .left, relatedBy: .equal, toItem: datePickerView!.superview!, attribute: .left, multiplier: 1, constant: 0)
        let rightDatePickerViewConstraint = NSLayoutConstraint(item: datePickerView!, attribute: .right, relatedBy: .equal, toItem: datePickerView!.superview!, attribute: .right, multiplier: 1, constant: 0)
        let heightDatePickerViewConstraint = NSLayoutConstraint(item: datePickerView!, attribute: .height, relatedBy: .equal, toItem: datePickerView!.superview!, attribute: .height, multiplier: 0, constant: CGFloat(integerLiteral: Constants.DATE_PICKER_HEIGHT))
        let bottomDatePickerViewConstraint = NSLayoutConstraint(item: datePickerView!, attribute: .bottom, relatedBy: .equal, toItem: datePickerView!.superview!, attribute: .bottom, multiplier: 1, constant: CGFloat(integerLiteral: Constants.DATE_PICKER_HEIGHT))
        bottomDatePickerViewConstraint.identifier = Constants.CONSTRAINTS_DATE_PICKERVIEW_BOTTOM
        self.datePickerView!.superview!.addConstraints([leftDatePickerViewConstraint, rightDatePickerViewConstraint, heightDatePickerViewConstraint, bottomDatePickerViewConstraint])
        NSLayoutConstraint.activate([leftDatePickerViewConstraint, rightDatePickerViewConstraint, heightDatePickerViewConstraint, bottomDatePickerViewConstraint])
        
        //CampusPickerView
        self.campusPickerView.translatesAutoresizingMaskIntoConstraints = false
        let leftCampusPickerViewConstraint = NSLayoutConstraint(item: campusPickerView!, attribute: .left, relatedBy: .equal, toItem: campusPickerView!.superview!, attribute: .left, multiplier: 1, constant: 0)
        let rightCampusPickerViewConstraint = NSLayoutConstraint(item: campusPickerView!, attribute: .right, relatedBy: .equal, toItem: campusPickerView!.superview!, attribute: .right, multiplier: 1, constant: 0)
        let heightCampusPickerViewConstraint = NSLayoutConstraint(item: campusPickerView!, attribute: .height, relatedBy: .equal, toItem: campusPickerView!.superview!, attribute: .height, multiplier: 0, constant: CGFloat(integerLiteral: Constants.CAMPUS_PICKER_HEIGHT))
        let bottomCampusPickerViewConstraint = NSLayoutConstraint(item: campusPickerView!, attribute: .bottom, relatedBy: .equal, toItem: campusPickerView!.superview!, attribute: .bottom, multiplier: 1, constant: CGFloat(integerLiteral: Constants.CAMPUS_PICKER_HEIGHT))
        bottomCampusPickerViewConstraint.identifier = Constants.CONSTRAINTS_CAMPUS_PICKERVIEW_BOTTOM
        self.campusPickerView!.superview!.addConstraints([leftCampusPickerViewConstraint, rightCampusPickerViewConstraint, heightCampusPickerViewConstraint, bottomCampusPickerViewConstraint])
        NSLayoutConstraint.activate([leftCampusPickerViewConstraint, rightCampusPickerViewConstraint, heightCampusPickerViewConstraint, bottomCampusPickerViewConstraint])
        
        //DurationPickerView
        self.durationPickerView.translatesAutoresizingMaskIntoConstraints = false
        let leftDurationPickerViewConstraint = NSLayoutConstraint(item: durationPickerView!, attribute: .left, relatedBy: .equal, toItem: durationPickerView!.superview!, attribute: .left, multiplier: 1, constant: 0)
        let rightDurationPickerViewConstraint = NSLayoutConstraint(item: durationPickerView!, attribute: .right, relatedBy: .equal, toItem: durationPickerView!.superview!, attribute: .right, multiplier: 1, constant: 0)
        let heightDurationPickerViewConstraint = NSLayoutConstraint(item: durationPickerView!, attribute: .height, relatedBy: .equal, toItem: durationPickerView!.superview!, attribute: .height, multiplier: 0, constant: CGFloat(integerLiteral: Constants.DURATION_PICKER_HEIGHT))
        let bottomDurationPickerViewConstraint = NSLayoutConstraint(item: durationPickerView!, attribute: .bottom, relatedBy: .equal, toItem: durationPickerView!.superview!, attribute: .bottom, multiplier: 1, constant: CGFloat(integerLiteral: Constants.DURATION_PICKER_HEIGHT))
        bottomDurationPickerViewConstraint.identifier = Constants.CONSTRAINTS_DURATION_PICKERVIEW_BOTTOM
        self.durationPickerView!.superview!.addConstraints([leftDurationPickerViewConstraint, rightDurationPickerViewConstraint, heightDurationPickerViewConstraint, bottomDurationPickerViewConstraint])
        NSLayoutConstraint.activate([leftDurationPickerViewConstraint, rightDurationPickerViewConstraint, heightDurationPickerViewConstraint, bottomDurationPickerViewConstraint])
    }
    
    func loadDefaultValues() {
        self.applyDatePickerViewChanges(date: Date())
        
        let defaults = UserDefaults.standard
        
        //Check if a different campus was previously selected
        if let campus = defaults.string(forKey: Constants.TAGS_CAMPUS) {
            applyCampusPickerViewChanges(campus: campus)
        } else {
            applyCampusPickerViewChanges(campus: Constants.LIST_CAMPUSSES[0])
        }
        
        //Check if a different minimum availability was previously selected
        if let availability = defaults.value(forKey: Constants.TAGS_DURATION),
            let duration = availability as? Date {
            applyDurationPickerViewChanges(date: duration)
        } else {
            applyDurationPickerViewChanges(date: DateFormatHelper.stringToDate(type: DateType.TIME, string: "00:30"))
        }
    }
    
    func initializePopups() {
        //Background
        background = UIView(frame: UIApplication.shared.keyWindow!.frame)
        background!.alpha = 0
        background!.backgroundColor = UIColor.black
        UIApplication.shared.keyWindow!.addSubview(background!)
        let closeBackgroundTap = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        background!.addGestureRecognizer(closeBackgroundTap)
        
        //DatePickerView
        UIApplication.shared.keyWindow!.addSubview(datePickerView)
        
        //CampusPickerView
        UIApplication.shared.keyWindow!.addSubview(campusPickerView)
        
        //DurationPickerView
        UIApplication.shared.keyWindow!.addSubview(durationPickerView)
    }
    
    @objc func backgroundTap() {
        if campusPickerViewOpen {
            applyCampusPickerViewChanges(campus: nil)
        }
        
        if datePickerViewOpen {
            applyDatePickerViewChanges(date: nil)
        }
        
        if durationPickerViewOpen {
            applyDurationPickerViewChanges(date: nil)
        }

        closePopups()
    }
    
    func closePopups() {
        if background!.alpha < 0.4 {
            return
        }
        
        if datePickerViewOpen, let constraint = ConstraintsHelper.getConstraint(withIdentifier: Constants.CONSTRAINTS_DATE_PICKERVIEW_BOTTOM, view: datePickerView.superview) {
            constraint.constant = CGFloat(integerLiteral: Constants.DATE_PICKER_HEIGHT)
            
            UIView.animate(withDuration: Constants.ANIMATION_DURATION, delay: 0, options: .curveLinear, animations: {
                self.datePickerView!.superview!.layoutIfNeeded()
            }, completion: nil)
        }
        
        if campusPickerViewOpen, let constraint = ConstraintsHelper.getConstraint(withIdentifier: Constants.CONSTRAINTS_CAMPUS_PICKERVIEW_BOTTOM, view: campusPickerView.superview) {
            constraint.constant = CGFloat(integerLiteral: Constants.CAMPUS_PICKER_HEIGHT)
            
            UIView.animate(withDuration: Constants.ANIMATION_DURATION, delay: 0, options: .curveLinear, animations: {
                self.campusPickerView!.superview!.layoutIfNeeded()
            }, completion: nil)
        }
        
        if durationPickerViewOpen, let constraint = ConstraintsHelper.getConstraint(withIdentifier: Constants.CONSTRAINTS_DURATION_PICKERVIEW_BOTTOM, view: durationPickerView.superview) {
            constraint.constant = CGFloat(integerLiteral: Constants.DURATION_PICKER_HEIGHT)
            
            UIView.animate(withDuration: Constants.ANIMATION_DURATION, delay: 0, options: .curveLinear, animations: {
                self.durationPickerView!.superview!.layoutIfNeeded()
            }, completion: nil)
        }
        
        UIView.animate(withDuration: Constants.ANIMATION_DURATION, delay: 0, options: .curveLinear, animations: {
            self.background!.alpha = 0
        }, completion: {(Bool) in
            self.datePickerViewOpen = false
            self.campusPickerViewOpen = false
            self.durationPickerViewOpen = false
        })
    }
    
    func openPopupBackground() {
        UIView.animate(withDuration: Constants.ANIMATION_DURATION, delay: 0, options: .curveLinear, animations: {
            self.background!.alpha = 0.4
        }, completion: nil)
    }
    
    @IBAction func searchButtonTap(_ sender: Any) {
        reload(refresh: false)
    }
    
    @IBAction func datePickerTextFieldEditingDidBegin(_ sender: Any) {
        view.endEditing(true)
        
        if let constraint = ConstraintsHelper.getConstraint(withIdentifier: Constants.CONSTRAINTS_DATE_PICKERVIEW_BOTTOM, view: datePickerView.superview) {
            constraint.constant = 0
            datePickerViewDatePicker.setDate(selectedDate, animated: false)
            
            UIView.animate(withDuration: Constants.ANIMATION_DURATION, delay: 0, options: .curveLinear, animations: {
                self.datePickerView!.superview!.layoutIfNeeded()
            }, completion: {(Bool) in
                self.datePickerViewOpen = true
            })
            
            openPopupBackground()
        }
    }
    
    @IBAction func campusPickerTextFieldEditingDidBegin(_ sender: Any) {
        self.view.endEditing(true)
        
        if let constraint = ConstraintsHelper.getConstraint(withIdentifier: Constants.CONSTRAINTS_CAMPUS_PICKERVIEW_BOTTOM, view: campusPickerView.superview) {
            constraint.constant = 0
            self.campusPickerViewPicker.selectRow(Constants.LIST_CAMPUSSES.firstIndex(of: campusPickerTextField.text!)!, inComponent: 0, animated: false)
            
            UIView.animate(withDuration: Constants.ANIMATION_DURATION, delay: 0, options: .curveLinear, animations: {
                self.campusPickerView!.superview!.layoutIfNeeded()
            }) { (Bool) in
                self.campusPickerViewOpen = true
            }
            
            openPopupBackground()
        }
    }
    
    @IBAction func durationPickerTextFieldEditingDidBegin(_ sender: Any) {
        view.endEditing(true)
        
        if let constraint = ConstraintsHelper.getConstraint(withIdentifier: Constants.CONSTRAINTS_DURATION_PICKERVIEW_BOTTOM, view: durationPickerView.superview) {
            constraint.constant = 0
            
            UIView.animate(withDuration: Constants.ANIMATION_DURATION, delay: 0, options: .curveLinear, animations: {
                self.durationPickerView!.superview!.layoutIfNeeded()
            }) { (Bool) in
                self.durationPickerViewOpen = true
            }
            
            openPopupBackground()
        }
    }
    
    @IBAction func cancelTap(_ sender: Any) {
        closePopups()
    }
    
    @IBAction func datePickerViewDoneTap(_ sender: Any) {
        applyDatePickerViewChanges(date: nil)
        closePopups()
    }
    
    func applyDatePickerViewChanges(date: Date?) {
        if let _date = date {
            datePickerViewDatePicker.setDate(_date, animated: false)
        }
        
        datePickerTextField.text = DateFormatHelper.dateToString(type: DateType.DATE, date: datePickerViewDatePicker.date)
        selectedDate = datePickerViewDatePicker.date
    }
    
    @IBAction func campusPickerViewDoneTap(_ sender: Any) {
        applyCampusPickerViewChanges(campus: nil)
        closePopups()
    }
    
    func applyCampusPickerViewChanges(campus: String?) {
        let row = campusPickerViewPicker.selectedRow(inComponent: 0)
        var selection = Constants.LIST_CAMPUSSES[row]
        if let _campus = campus {
            selection = _campus
        }
        selectedCampus = selection
        campusPickerTextField.text = selection
        let defaults = UserDefaults.standard
        defaults.set(selection, forKey: Constants.TAGS_CAMPUS)
    }
    
    @IBAction func durationPickerViewDoneTap(_ sender: Any) {
        applyDurationPickerViewChanges(date: nil)
        closePopups()
    }
    
    @objc func refresh() {
        reload(refresh: true)
    }
    
    func reload(refresh: Bool) {
        guard !webHelper.isReloading else {
            return
        }
        
        var date = selectedDate
        var campus = selectedCampus
        var duration = selectedDuration
        
        if refresh {
            if let prevDate = previousDate {
                date = prevDate
            }
            
            if let prevCampus = previousCampus {
                campus = prevCampus
            }
            
            if let prevDuration = previousDuration {
                duration = prevDuration
            }
        } else {
            previousDate = date
            previousCampus = campus
            previousDuration = duration
            refreshControl?.beginRefreshing()
        }
        
        webHelper.reload(date: date, campus: campus!, duration: duration!) { (error, classrooms, announcement) in
            if let error = error, error {
                self.announcement = announcement
                self.classroomList.removeAll()
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Something went wrong", message: "An error occurred while trying to connect to the server. Please try again later.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        self.refreshControl?.endRefreshing()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            self.classroomList = classrooms!
            self.announcement = announcement
            
            DispatchQueue.main.async {
                self.sort()
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        self.sort()
        tableView.reloadData()
    }
    
    func sort() {
        if segmentedControl.selectedSegmentIndex == 0 {
            //Sorted availability
            classroomList.sort {
                
                if $0.duration == $1.duration {
                    return $0.room < $1.room
                }
                
                guard $0.duration != nil else {
                    return true
                }
                
                guard $1.duration != nil else {
                    return false
                }
                
                return $0.duration! > $1.duration!
            }
        } else {
            //Sorted classroom
            classroomList.sort {
                return $0.room < $1.room
            }
        }
    }
    
    func applyDurationPickerViewChanges(date: Date?) {
        if let _date = date {
            durationPickerViewPicker.setDate(_date, animated: false)
        }
        
        let selection = durationPickerViewPicker.date
        selectedDuration = selection
        let text = DateFormatHelper.dateToString(type: DateType.DURATION, date: selection)
        minimumAvailabilityPickerTextField.text = text
        let defaults = UserDefaults.standard
        defaults.set(selection, forKey: Constants.TAGS_DURATION)
    }
}

extension SearchTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.CAMPUSSES.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.LIST_CAMPUSSES[row]
    }
}

extension SearchTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return announcement != nil ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && announcement != nil {
            return 1
        } else {
            return classroomList.count > 0 ? classroomList.count : 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, let announcement = announcement {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell", for: indexPath) as! AnnouncementCell
            cell.selectionStyle = .none
            cell.Id = announcement.id
            cell.setDescription(text: announcement.text!)
            cell.setWarningLevel(level: announcement.announcementType!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClassroomCell", for: indexPath) as! ClassroomCell
            cell.selectionStyle = .none
            
            if self.classroomList.count > 0 {
                let classroom = classroomList[indexPath.row]
                cell.setRoomLabelText(text: classroom.room)
                cell.set(hidden: false)
                
                if let date = classroom.duration {
                    cell.setDurationLabelText(text: DateFormatHelper.dateToString(type: DateType.DURATION, date: date))
                } else {
                    cell.setDurationLabelText(text: "-")
                }
                
                if let date = classroom.end {
                    cell.setEndLabelText(text: DateFormatHelper.dateToString(type: DateType.TIME, date: date))
                } else {
                    cell.setEndLabelText(text: "The rest of the day")
                }
            } else {
                cell.set(hidden: true)
                cell.setRoomLabelText(text: "")
                cell.setDurationLabelText(text: "No classrooms available")
                cell.setEndLabelText(text: "")
            }
        
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 0 && announcement != nil {
            return [UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
                let cell = tableView.cellForRow(at: indexPath) as! AnnouncementCell
                self.announcement = nil
                let defaults = UserDefaults.standard

                if var ids = defaults.array(forKey: Constants.TAGS_ANNOUNCEMENTS) as? [Int] {
                    ids.append(cell.Id)
                    defaults.set(ids, forKey: Constants.TAGS_ANNOUNCEMENTS)
                } else {
                    defaults.set([cell.Id], forKey: Constants.TAGS_ANNOUNCEMENTS)
                }
                
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .left)
            }]
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && self.announcement != nil {
            return true
        }
        return false
    }
    
    @objc func onResume() {
        //Load user saved preferences
        loadDefaultValues()
        reload(refresh: false)
    }
}
