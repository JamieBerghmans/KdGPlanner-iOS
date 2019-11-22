//
//  SessionHelper.swift
//  KdGPlanner
//
//  Created by Jamie Berghmans on 22/11/2019.
//  Copyright © 2019 Devvix. All rights reserved.
//

import Foundation
import WatchConnectivity

class SessionHandler: NSObject, WCSessionDelegate {
    
    static let shared = SessionHandler()
    private let webHelper = WebHelper()
    private var session = WCSession.default
    
    override init() {
        super.init()
        
        if isSuported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func isSuported() -> Bool {
        return WCSession.isSupported()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }

    func sessionDidDeactivate(_ session: WCSession) {
        self.session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if message["type"] as? String == "classrooms", let campus = message["campus"] as? String, let limit = message["limit"] as? Int {
            
            webHelper.reload(date: Date(), campus: campus, duration: DateFormatHelper.stringToDate(type: DateType.TIME, string: "00:30"), limit: limit) { (error, rooms) in
                NSKeyedArchiver.setClassName("Classroom", for: Classroom.self)
                if let error = error, error {
                    let result = NSKeyedArchiver.archivedData(withRootObject: [])
                    replyHandler(["result": result])
                } else {
                    let result = NSKeyedArchiver.archivedData(withRootObject: rooms!)
                    replyHandler(["result": result])
                }
            }
        }
    }
}
