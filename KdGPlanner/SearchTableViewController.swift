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
    
    //Consts
    let DATE_PICKER_HEIGHT: CGFloat = 250
    let CAMPUS_PICKER_HEIGHT: CGFloat = 200
    let DURATION_PICKER_HEIGHT: CGFloat = 250
    let ANIMATION_DURATION = 0.1
    let CONSTRAINT_DATE_PICKERVIEW_BOTTOM = "datePickerViewBottomConstraint"
    let CONSTRAINT_CAMPUS_PICKERVIEW_BOTTOM = "campusPickerViewBottomConstraint"
    let CONSTRAINT_DURATION_PICKERVIEW_BOTTOM = "durationPickerViewBottomConstraint"
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    let apiFormatter = DateFormatter()
    let dtoTimeFormatter = DateFormatter()
    let dtoDateFormatter = DateFormatter()
    let campusList = ["Groenplaats", "Pothoek", "Stadswaag"]
    let campusDict = ["Groenplaats": "GR", "Pothoek": "PH", "Stadswaag": "SW"]
    let API_BASE = "https://kdgplanner.be/api"
    let API_LESSONS = "/Lessons?"
    let API_ANNOUNCEMENT = "/Announcement"
    
    var classroomList: [Classroom] = []
    
    //Variables
    let campusTag = "campusKey"
    let availabilityTag = "availabilityKey"
    let announcementsTag = "announcementsKey"
    var datePickerViewOpen = false
    var campusPickerViewOpen = false
    var durationPickerViewOpen = false
    var selectedDate: Date = Date()
    var previousDate: Date?
    var announcement: Announcement?
    var refreshCount = 0
    
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
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        if #available(iOS 13.0, *) {
            self.tableView.separatorColor = .quaternarySystemFill
        }
        
        //Set custom date format
        dateFormatter.dateFormat = "EEEE dd LLL HH:mm"
        timeFormatter.dateFormat = "HH:mm"
        dtoTimeFormatter.dateFormat = "HH:mm:ss"
        apiFormatter.dateFormat = "yyyy/MM/dd%20HH:mm"
        dtoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        initializePopups()
        
        self.applyDatePickerViewChanges(date: Date())

        self.campusPickerViewPicker.delegate = self
        self.campusPickerViewPicker.dataSource = self
        
        //Load user saved preferences
        let defaults = UserDefaults.standard
        
        //Check if a different campus was previously selected
        if let campus = defaults.string(forKey: campusTag) {
            self.applyCampusPickerViewChanges(campus: campus)
        } else {
            self.applyCampusPickerViewChanges(campus: campusList[0])
        }
        
        //Check if a different minimum availability was previously selected
        if let availability = defaults.value(forKey: availabilityTag),
            let duration = availability as? Date {
            self.applyDurationPickerViewChanges(date: duration)
        } else {
            self.applyDurationPickerViewChanges(date: stringToDate(formatter: timeFormatter, string: "00:30"))
        }
        
        self.reload(refresh: false)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        //DatePickerView
        self.datePickerView.translatesAutoresizingMaskIntoConstraints = false
        let leftDatePickerViewConstraint = NSLayoutConstraint(item: self.datePickerView!, attribute: .left, relatedBy: .equal, toItem: self.datePickerView!.superview!, attribute: .left, multiplier: 1, constant: 0)
        let rightDatePickerViewConstraint = NSLayoutConstraint(item: self.datePickerView!, attribute: .right, relatedBy: .equal, toItem: self.datePickerView!.superview!, attribute: .right, multiplier: 1, constant: 0)
        let heightDatePickerViewConstraint = NSLayoutConstraint(item: self.datePickerView!, attribute: .height, relatedBy: .equal, toItem: self.datePickerView!.superview!, attribute: .height, multiplier: 0, constant: DATE_PICKER_HEIGHT)
        let bottomDatePickerViewConstraint = NSLayoutConstraint(item: self.datePickerView!, attribute: .bottom, relatedBy: .equal, toItem: self.datePickerView!.superview!, attribute: .bottom, multiplier: 1, constant: DATE_PICKER_HEIGHT)
        bottomDatePickerViewConstraint.identifier = CONSTRAINT_DATE_PICKERVIEW_BOTTOM
        self.datePickerView!.superview!.addConstraints([leftDatePickerViewConstraint, rightDatePickerViewConstraint, heightDatePickerViewConstraint, bottomDatePickerViewConstraint])
        NSLayoutConstraint.activate([leftDatePickerViewConstraint, rightDatePickerViewConstraint, heightDatePickerViewConstraint, bottomDatePickerViewConstraint])
        
        //CampusPickerView
        self.campusPickerView.translatesAutoresizingMaskIntoConstraints = false
        let leftCampusPickerViewConstraint = NSLayoutConstraint(item: self.campusPickerView!, attribute: .left, relatedBy: .equal, toItem: self.campusPickerView!.superview!, attribute: .left, multiplier: 1, constant: 0)
        let rightCampusPickerViewConstraint = NSLayoutConstraint(item: self.campusPickerView!, attribute: .right, relatedBy: .equal, toItem: self.campusPickerView!.superview!, attribute: .right, multiplier: 1, constant: 0)
        let heightCampusPickerViewConstraint = NSLayoutConstraint(item: self.campusPickerView!, attribute: .height, relatedBy: .equal, toItem: self.campusPickerView!.superview!, attribute: .height, multiplier: 0, constant: CAMPUS_PICKER_HEIGHT)
        let bottomCampusPickerViewConstraint = NSLayoutConstraint(item: self.campusPickerView!, attribute: .bottom, relatedBy: .equal, toItem: self.campusPickerView!.superview!, attribute: .bottom, multiplier: 1, constant: CAMPUS_PICKER_HEIGHT)
        bottomCampusPickerViewConstraint.identifier = CONSTRAINT_CAMPUS_PICKERVIEW_BOTTOM
        self.campusPickerView!.superview!.addConstraints([leftCampusPickerViewConstraint, rightCampusPickerViewConstraint, heightCampusPickerViewConstraint, bottomCampusPickerViewConstraint])
        NSLayoutConstraint.activate([leftCampusPickerViewConstraint, rightCampusPickerViewConstraint, heightCampusPickerViewConstraint, bottomCampusPickerViewConstraint])
        
        //DurationPickerView
        self.durationPickerView.translatesAutoresizingMaskIntoConstraints = false
        let leftDurationPickerViewConstraint = NSLayoutConstraint(item: self.durationPickerView!, attribute: .left, relatedBy: .equal, toItem: self.durationPickerView!.superview!, attribute: .left, multiplier: 1, constant: 0)
        let rightDurationPickerViewConstraint = NSLayoutConstraint(item: self.durationPickerView!, attribute: .right, relatedBy: .equal, toItem: self.durationPickerView!.superview!, attribute: .right, multiplier: 1, constant: 0)
        let heightDurationPickerViewConstraint = NSLayoutConstraint(item: self.durationPickerView!, attribute: .height, relatedBy: .equal, toItem: self.durationPickerView!.superview!, attribute: .height, multiplier: 0, constant: DURATION_PICKER_HEIGHT)
        let bottomDurationPickerViewConstraint = NSLayoutConstraint(item: self.durationPickerView!, attribute: .bottom, relatedBy: .equal, toItem: self.durationPickerView!.superview!, attribute: .bottom, multiplier: 1, constant: DURATION_PICKER_HEIGHT)
        bottomDurationPickerViewConstraint.identifier = CONSTRAINT_DURATION_PICKERVIEW_BOTTOM
        self.durationPickerView!.superview!.addConstraints([leftDurationPickerViewConstraint, rightDurationPickerViewConstraint, heightDurationPickerViewConstraint, bottomDurationPickerViewConstraint])
        NSLayoutConstraint.activate([leftDurationPickerViewConstraint, rightDurationPickerViewConstraint, heightDurationPickerViewConstraint, bottomDurationPickerViewConstraint])
        
    }
    
    func initializePopups() {
        //Background
        self.background = UIView(frame: UIApplication.shared.keyWindow!.frame)
        self.background!.alpha = 0
        self.background!.backgroundColor = UIColor.black
        UIApplication.shared.keyWindow!.addSubview(background!)
        let closeBackgroundTap = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        self.background!.addGestureRecognizer(closeBackgroundTap)
        
        //DatePickerView
        UIApplication.shared.keyWindow!.addSubview(self.datePickerView)
        
        //CampusPickerView
        UIApplication.shared.keyWindow!.addSubview(self.campusPickerView)
        
        //DurationPickerView
        UIApplication.shared.keyWindow!.addSubview(self.durationPickerView)
    }
    
    @objc func backgroundTap() {
        applyCampusPickerViewChanges(campus: nil)
        applyDatePickerViewChanges(date: nil)
        applyDurationPickerViewChanges(date: nil)
        closePopups()
    }
    
    func closePopups() {
        if self.background!.alpha < 0.4 {
            return
        }
        
        if datePickerViewOpen, let constraint = getConstraint(withIdentifier: CONSTRAINT_DATE_PICKERVIEW_BOTTOM, view: self.datePickerView.superview) {
            constraint.constant = DATE_PICKER_HEIGHT
            
            UIView.animate(withDuration: ANIMATION_DURATION, delay: 0, options: .curveLinear, animations: {
                self.datePickerView!.superview!.layoutIfNeeded()
            }, completion: nil)
        }
        
        if campusPickerViewOpen, let constraint = getConstraint(withIdentifier: CONSTRAINT_CAMPUS_PICKERVIEW_BOTTOM, view: self.campusPickerView.superview) {
            constraint.constant = CAMPUS_PICKER_HEIGHT
            
            UIView.animate(withDuration: ANIMATION_DURATION, delay: 0, options: .curveLinear, animations: {
                self.campusPickerView!.superview!.layoutIfNeeded()
            }, completion: nil)
        }
        
        if durationPickerViewOpen, let constraint = getConstraint(withIdentifier: CONSTRAINT_DURATION_PICKERVIEW_BOTTOM, view: self.durationPickerView.superview) {
            constraint.constant = DURATION_PICKER_HEIGHT
            
            UIView.animate(withDuration: ANIMATION_DURATION, delay: 0, options: .curveLinear, animations: {
                self.durationPickerView!.superview!.layoutIfNeeded()
            }, completion: nil)
        }
        
        UIView.animate(withDuration: ANIMATION_DURATION, delay: 0, options: .curveLinear, animations: {
            self.background!.alpha = 0
        }, completion: {(Bool) in
            self.datePickerViewOpen = false
            self.campusPickerViewOpen = false
            self.durationPickerViewOpen = false
        })
    }
    
    func openPopupBackground() {
        UIView.animate(withDuration: ANIMATION_DURATION, delay: 0, options: .curveLinear, animations: {
            self.background!.alpha = 0.4
        }, completion: nil)
    }
    
    @IBAction func searchButtonTap(_ sender: Any) {
        reload(refresh: false)
    }
    
    @IBAction func datePickerTextFieldEditingDidBegin(_ sender: Any) {
        self.view.endEditing(true)
        
        if let constraint = getConstraint(withIdentifier: CONSTRAINT_DATE_PICKERVIEW_BOTTOM, view: self.datePickerView.superview) {
            constraint.constant = 0
            self.datePickerViewDatePicker.setDate(self.selectedDate, animated: false)
            
            UIView.animate(withDuration: ANIMATION_DURATION, delay: 0, options: .curveLinear, animations: {
                self.datePickerView!.superview!.layoutIfNeeded()
            }, completion: {(Bool) in
                self.datePickerViewOpen = true
            })
            
            openPopupBackground()
        }
    }
    
    @IBAction func campusPickerTextFieldEditingDidBegin(_ sender: Any) {
        self.view.endEditing(true)
        
        if let constraint = getConstraint(withIdentifier: CONSTRAINT_CAMPUS_PICKERVIEW_BOTTOM, view: self.campusPickerView.superview) {
            constraint.constant = 0
            self.campusPickerViewPicker.selectRow(self.campusList.firstIndex(of: self.campusPickerTextField.text!)!, inComponent: 0, animated: false)
            
            UIView.animate(withDuration: ANIMATION_DURATION, delay: 0, options: .curveLinear, animations: {
                self.campusPickerView!.superview!.layoutIfNeeded()
            }) { (Bool) in
                self.campusPickerViewOpen = true
            }
            
            openPopupBackground()
        }
    }
    
    @IBAction func durationPickerTextFieldEditingDidBegin(_ sender: Any) {
        self.view.endEditing(true)
        
        if let constraint = getConstraint(withIdentifier: CONSTRAINT_DURATION_PICKERVIEW_BOTTOM, view: self.durationPickerView.superview) {
            constraint.constant = 0
            
            UIView.animate(withDuration: ANIMATION_DURATION, delay: 0, options: .curveLinear, animations: {
                self.durationPickerView!.superview!.layoutIfNeeded()
            }) { (Bool) in
                self.durationPickerViewOpen = true
            }
            
            openPopupBackground()
        }
    }
    
    @IBAction func cancelTap(_ sender: Any) {
        self.closePopups()
    }
    
    @IBAction func datePickerViewDoneTap(_ sender: Any) {
        applyDatePickerViewChanges(date: nil)
        closePopups()
    }
    
    func applyDatePickerViewChanges(date: Date?) {
        if let _date = date {
            self.datePickerViewDatePicker.setDate(_date, animated: false)
        }
        
        self.datePickerTextField.text = dateToString(formatter: self.dateFormatter, date: self.datePickerViewDatePicker.date)
        selectedDate = self.datePickerViewDatePicker.date
    }
    
    @IBAction func campusPickerViewDoneTap(_ sender: Any) {
        applyCampusPickerViewChanges(campus: nil)
        closePopups()
    }
    
    func applyCampusPickerViewChanges(campus: String?) {
        let row = self.campusPickerViewPicker.selectedRow(inComponent: 0)
        var selection = self.campusList[row]
        if let _campus = campus {
            selection = _campus
        }
        self.campusPickerTextField.text = selection
        let defaults = UserDefaults.standard
        defaults.set(selection, forKey: campusTag)
    }
    
    @IBAction func durationPickerViewDoneTap(_ sender: Any) {
        applyDurationPickerViewChanges(date: nil)
        closePopups()
    }
    
    @objc func refresh() {
        reload(refresh: true)
    }
    
    func reload(refresh: Bool) {
        var date = self.selectedDate
        if refresh, let prevDate = self.previousDate {
            date = prevDate
        } else {
            previousDate = date
            self.refreshControl?.beginRefreshing()
        }
        
        self.refreshCount = 2
        pullClassrooms(date: date)
        pullAnnouncements()
    }
    
    func pullClassrooms(date: Date) {
        let url = URL(string: "\(self.API_BASE)\(self.API_LESSONS)dateTime=\(self.dateToString(formatter: self.apiFormatter, date: date))&campus=\(self.getCampusInSubstitute())&minAvailabilityMinutes=\(self.getDurationInMinutes())&client=ios")
        
        let task = URLSession.shared.dataTask(with: url!) { data, _, error in
                
            guard error == nil else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Something went wrong", message: "An error occurred while trying to connect to the server. Please try again later.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
                
            guard let data = data else {
                self.classroomList.removeAll()
                
                DispatchQueue.main.async {
                    self.refreshCount -= 1
                    if self.refreshCount == 0 {
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                }
                return
            }
            
            if let json = try? JSONDecoder().decode([ClassroomDTO].self, from: data) {
                self.classroomList.removeAll()
                
                for (value) in json {
                    let room = Classroom(room: value.Room! as! String)
                    
                    if let duration = value.Duration as? String {
                        room.Duration = self.stringToDate(formatter: self.dtoTimeFormatter, string: duration)
                    }
                    
                    if let end = value.End as? String {
                        room.End = self.stringToDate(formatter: self.dtoDateFormatter, string: end)
                    }
                    
                    self.classroomList.append(room)
                }
            }
            
            DispatchQueue.main.async {
                self.sort()
                self.refreshCount -= 1
                if self.refreshCount == 0 {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }

        task.resume()
    }
    
    func pullAnnouncements() {
        let url = URL(string: "\(self.API_BASE)\(self.API_ANNOUNCEMENT)")
        
        let task = URLSession.shared.dataTask(with: url!) { data, _, error in
                
            guard error == nil, let data = data else {
                self.announcement = nil
                
                DispatchQueue.main.async {
                    self.refreshCount -= 1
                    if self.refreshCount == 0 {
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                }
                return
            }
            
            if let json = try? JSONDecoder().decode(AnnouncementDTO.self, from: data) {
                self.announcement = nil
                
                
                let announcement = Announcement(id: json.Id)
                
                let defaults = UserDefaults.standard
                if let ids = defaults.array(forKey: self.announcementsTag) as? [Int], ids.contains(announcement.Id) {
                    DispatchQueue.main.async {
                        self.refreshCount -= 1
                        if self.refreshCount == 0 {
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
                    }
                    return
                }
                
                announcement.Text = json.Text
                
                guard json.Platform == nil || json.Platform! > 1 else {
                    DispatchQueue.main.async {
                        self.refreshCount -= 1
                        if self.refreshCount == 0 {
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
                    }
                    return
                }
                
                if let type = json.AnnouncementType {
                    announcement.AnnouncementType = type
                } else {
                    announcement.AnnouncementType = 3
                }
            }
            
            DispatchQueue.main.async {
                self.refreshCount -= 1
                if self.refreshCount == 0 {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }

        task.resume()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        self.sort()
    }
    
    func sort() {
        if segmentedControl.selectedSegmentIndex == 0 {
            //Sorted availability
            self.classroomList.sort {
                
                if $0.Duration == $1.Duration {
                    return $0.Room < $1.Room
                }
                
                guard $0.Duration != nil else {
                    return true
                }
                
                guard $1.Duration != nil else {
                    return false
                }
                
                return $0.Duration! > $1.Duration!
            }
        } else {
            //Sorted classroom
            self.classroomList.sort {
                return $0.Room < $1.Room
            }
        }
        
        self.tableView.reloadData()
    }
    
    func applyDurationPickerViewChanges(date: Date?) {
        if let _date = date {
            self.durationPickerViewPicker.setDate(_date, animated: false)
        }
        
        let selection = self.durationPickerViewPicker.date
        let text = dateToDurationString(date: selection)
        self.minimumAvailabilityPickerTextField.text = text
        let defaults = UserDefaults.standard
        defaults.set(selection, forKey: availabilityTag)
    }
    
    func dateToDurationString(date: Date) -> String {
        var text = ""
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        
        
        if hour > 0 {
            text += "\(hour) hour"
            if hour > 1 {
                text += "s"
            }
            
            if minute > 0 {
                text += " and "
            }
        }
        
        if minute > 0 {
            text += "\(minute) minute"
            
            if minute > 1 {
                text += "s"
            }
        }
        
        if hour == 0, minute == 0 {
            text += "0 hours and 0 minutes"
        }
        
        return text
    }
    
    func dateToString(formatter: DateFormatter, date: Date) -> String {
        return formatter.string(from: date)
    }
    
    func stringToDate(formatter: DateFormatter, string: String) -> Date {
        return formatter.date(from: string)!
    }
    
    func getConstraint(withIdentifier: String, view: UIView?) -> NSLayoutConstraint? {
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
    
    func getDurationInMinutes() -> Int {
        let defaults = UserDefaults.standard
        let date = defaults.value(forKey: availabilityTag) as! Date
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        return minute + (hour * 60)
    }
    
    func getCampusInSubstitute() -> String {
        let defaults = UserDefaults.standard
        let campus = defaults.string(forKey: campusTag)
        return campusDict[campus!]!
    }
}

extension SearchTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return campusList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return campusList[row]
    }
}

extension SearchTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.announcement != nil ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && self.announcement != nil {
            return 1
        } else {
            return self.classroomList.count > 0 ? self.classroomList.count : 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, let announcement = self.announcement {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell", for: indexPath) as! AnnouncementCell
            cell.selectionStyle = .none
            cell.Id = announcement.Id
            cell.setDescription(text: announcement.Text!)
            cell.setWarningLevel(level: announcement.AnnouncementType!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClassroomCell", for: indexPath) as! ClassroomCell
            cell.selectionStyle = .none
            
            if self.classroomList.count > 0 {
                let classroom = classroomList[indexPath.row]
                cell.setRoomLabelText(text: classroom.Room)
                cell.set(hidden: false)
                
                if let date = classroom.Duration {
                    cell.setDurationLabelText(text: dateToDurationString(date: date))
                } else {
                    cell.setDurationLabelText(text: "-")
                }
                
                if let date = classroom.End {
                    cell.setEndLabelText(text: dateToString(formatter: timeFormatter, date: date))
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
        if indexPath.section == 0 && self.announcement != nil {
            return [UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
                let cell = tableView.cellForRow(at: indexPath) as! AnnouncementCell
                self.announcement = nil
                let defaults = UserDefaults.standard

                if var ids = defaults.array(forKey: self.announcementsTag) as? [Int] {
                    ids.append(cell.Id)
                    defaults.set(ids, forKey: self.announcementsTag)
                } else {
                    defaults.set([cell.Id], forKey: self.announcementsTag)
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
}
