//
//  DataLoader.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 14/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import Foundation


class WebHelper {
    
    var refreshCount = 0
    var isReloading: Bool {
        get {
            return refreshCount != 0
        }
    }
    
    func reload(date: Date,campus fullCampus: String, duration: Date, handler:@escaping(_ error:Bool?,_ classrooms: [Classroom]?, _ announcement: Announcement?) -> Void) {
        
        refreshCount = 2
        
        let hour = Calendar.current.component(.hour, from: duration)
        let minute = Calendar.current.component(.minute, from: duration)
        let newDuration = minute + (hour * 60)
        
        var error: Bool?
        var classrooms: [Classroom]?
        var announcement: Announcement?
        
        let campus = Constants.CAMPUSSES[fullCampus]!
        
        pullClassrooms(date: date, campus: campus, duration: newDuration) { (_error, _classrooms) in
            error = _error
            classrooms = _classrooms
            
            self.refreshCount -= 1
            if self.refreshCount == 0 {
                handler(error, classrooms, announcement)
            }
        }
        
        pullAnnouncements() { (_announcement) in
            announcement = _announcement
            
            self.refreshCount -= 1
            if self.refreshCount == 0 {
                handler(error, classrooms, announcement)
            }
        }
    }
    
    func pullClassrooms(date: Date, campus: String, duration: Int, handler:@escaping(_ error:Bool?,_ classrooms: [Classroom]?) -> Void) {
        let url = URL(string: "\(Constants.API_BASE)\(Constants.API_LESSONS)dateTime=\(DateFormatHelper.dateToString(type: DateType.API,date: date))&campus=\(campus)&minAvailabilityMinutes=\(duration)&client=ios")
        
        print(url!)
        
        let task = URLSession.shared.dataTask(with: url!) { data, _, error in
                
            guard error == nil else {
                /*DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Something went wrong", message: "An error occurred while trying to connect to the server. Please try again later.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }*/
                handler(true, nil)
                return
            }
                
            guard let data = data else {
                handler(false, [])
                /*self.classroomList.removeAll()
                
                DispatchQueue.main.async {
                    self.refreshCount -= 1
                    if self.refreshCount == 0 {
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                }*/
                return
            }
            
            var classrooms: [Classroom] = []
            
            if let json = try? JSONDecoder().decode([ClassroomDTO].self, from: data) {
                //self.classroomList.removeAll()
                
                for (value) in json {
                    let room = Classroom(room: value.classroom!)
                    
                    if let duration = value.availability {
                        room.duration = DateFormatHelper.stringToDate(type: DateType.DTO_TIME, string: duration)
                    }
                    
                    if let end = value.endAvailability {
                        room.end = DateFormatHelper.stringToDate(type: DateType.DTO_DATE, string: end)
                    }
                    
                    classrooms.append(room)
                }
            }
            
            handler(false, classrooms)
            
            /*DispatchQueue.main.async {
                self.sort()
                self.refreshCount -= 1
                if self.refreshCount == 0 {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }*/
        }

        task.resume()
    }
    
    func pullAnnouncements(handler:@escaping(_ announcement: Announcement?) -> Void) {
        let url = URL(string: "\(Constants.API_BASE)\(Constants.API_ANNOUNCEMENT)")
        
        let task = URLSession.shared.dataTask(with: url!) { data, _, error in
                
            guard error == nil, let data = data else {
                /*self.announcement = nil
                
                DispatchQueue.main.async {
                    self.refreshCount -= 1
                    if self.refreshCount == 0 {
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                }*/
                handler(nil)
                return
            }
            
            var announcement: Announcement?
            
            if let json = try? JSONDecoder().decode(AnnouncementDTO.self, from: data) {
                announcement = Announcement(id: json.id)
                
                let defaults = UserDefaults.standard
                if let ids = defaults.array(forKey: Constants.TAGS_ANNOUNCEMENTS) as? [Int], ids.contains(announcement!.id) {
                    /*DispatchQueue.main.async {
                        self.refreshCount -= 1
                        if self.refreshCount == 0 {
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
                    }*/
                    handler(nil)
                    return
                }
                
                announcement!.text = json.text
                
                guard json.platform == nil || json.platform! > 1 else {
                    /*DispatchQueue.main.async {
                        self.refreshCount -= 1
                        if self.refreshCount == 0 {
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
                    }*/
                    handler(nil)
                    return
                }
                
                if let type = json.announcementType {
                    announcement!.announcementType = type
                } else {
                    announcement!.announcementType = 3
                }
            }
            
            /*DispatchQueue.main.async {
                self.refreshCount -= 1
                if self.refreshCount == 0 {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }*/
            handler(announcement)
        }

        task.resume()
    }
    
}
