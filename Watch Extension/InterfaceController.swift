//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Jamie Berghmans on 15/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    var isRefreshing = false
    
    @IBOutlet weak var table: WKInterfaceTable!
    @IBOutlet weak var refreshFrame: WKInterfaceImage!
    
    var classrooms: [Classroom]? = []
    let webHelper = WebHelper()
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        populateTable()
    }
    
    func populateTable() {
        guard !webHelper.isReloading else {
            return
        }
        
        startRefreshAnimation()
        webHelper.reload(date: Date(), campus: "Pothoek", duration: DateFormatHelper.stringToDate(type: DateType.TIME, string: "00:30")) { (error, classrooms) in
            self.classrooms = classrooms
            
            DispatchQueue.main.async {
                if self.table.numberOfRows > 0 {
                    for i in 0...(self.table.numberOfRows - 1) {
                        self.table.removeRows(at: IndexSet(integer: i))
                    }
                }
                
                if var rooms = classrooms {
                    rooms.sort {
                        
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
                    
                    self.table.setNumberOfRows(rooms.count, withRowType: "ClassroomRow")
                    
                    for (index, room) in rooms.enumerated() {
                        let row = self.table.rowController(at: index) as! ClassroomRowController
                        row.room.setText(room.room)
                        if let end = room.end {
                            row.end.setText(DateFormatHelper.dateToString(type: DateType.TIME, date: end))
                        } else {
                            row.end.setText("-")
                        }
                    }
                    
                    self.stopRefreshAnimation()
                }
            }
        }
    }
    
    @IBAction func refreshTap() {
        guard !isRefreshing else {
            return
        }
        populateTable()
    }
    
    func startRefreshAnimation() {
        isRefreshing = true
        
        refreshFrame.setImageNamed("ai")
        refreshFrame.startAnimatingWithImages(in: NSMakeRange(0, 40), duration: 1.0, repeatCount: 0)
        refreshFrame.setHidden(false)
    }
    
    func stopRefreshAnimation() {
        isRefreshing = false
        refreshFrame.setHidden(true)
        refreshFrame.stopAnimating()
        
    }
    
    @IBAction func editingHasBegun(_ value: NSString?) {
        print("test")
    }
    
    
}
