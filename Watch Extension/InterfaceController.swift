//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Jamie Berghmans on 15/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import WatchKit
import WatchConnectivity


class InterfaceController: WKInterfaceController {

    var isRefreshing = false
    
    @IBOutlet weak var table: WKInterfaceTable!
    @IBOutlet weak var refreshFrame: WKInterfaceImage!
    
    var classrooms: [Classroom]? = []
    let webHelper = WebHelper()
    
    private var session = WCSession.default
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func populateTableIndependently() {
        print("Watch request")
        webHelper.reload(date: Date(), campus: "Groenplaats", duration: DateFormatHelper.stringToDate(type: DateType.TIME, string: "00:30"), limit: 3) { (error, classrooms) in
            self.classrooms = classrooms
            
            DispatchQueue.main.async {
                self.updateTable(classrooms: classrooms)
                self.stopRefreshAnimation()
            }
        }
    }
    
    func populateTable() {
        startRefreshAnimation()
        
        guard !webHelper.isReloading else {
            return
        }
        
        if session.isReachable {
            print("Phone request")
            session.sendMessage(["type" : "classrooms", "campus": "Groenplaats", "limit": 3], replyHandler: { (response) in
                var result: [Classroom] = []
                
                do {
                    NSKeyedUnarchiver.setClass(Classroom.self, forClassName: "Classroom")
                    result = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, Classroom.self], from: response["result"] as! Data) as! [Classroom]
                } catch {
                    print("CATCH! \(error)")
                    result = []
                }
                
                DispatchQueue.main.async {
                    self.updateTable(classrooms: result)
                    self.stopRefreshAnimation()
                }
                
            }, errorHandler: { (error) in
                print("Error sending message: \(error)")
                self.populateTableIndependently()
                self.stopRefreshAnimation()
            })
        } else {
            populateTableIndependently()
        }
    }
    
    func updateTable(classrooms: [Classroom]?) {
        if self.table.numberOfRows > 0 {
            for i in 0...(self.table.numberOfRows - 1) {
                self.table.removeRows(at: IndexSet(integer: i))
            }
        }
        
        if let rooms = classrooms {
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

extension InterfaceController: WCSessionDelegate {
    
    // 4: Required stub for delegating session
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
        populateTable()
    }
}
