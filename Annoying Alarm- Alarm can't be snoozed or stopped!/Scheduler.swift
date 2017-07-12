//
//  Scheduler.swift
//  Annoying Alarm- Alarm can't be snoozed or stopped!
//
//  Created by Ali Abouelatta on 7/12/17.
//  Copyright © 2017 Ali Abouelatta. All rights reserved.
//

import UIKit
import UserNotifications

class Scheduler {
    
    static let sharedInstance = Scheduler()
    private init() {}
    

    let center = UNUserNotificationCenter.current()     // Where Notifications are managed
    let options: UNAuthorizationOptions = [.alert, .sound, .badge];
    
    func requestauthorizationFirstTime() {
        
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("ALi: Authorization Went Wrong")
            }
        }
    
    } // end of function
    
    
    func generateTestAlarm() {
    
        let content = UNMutableNotificationContent()
        content.title = "WAKE UP"
        content.body = "ITS TIMEE!!!"
        content.sound = UNNotificationSound.default()

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print ("ALI: Something wrong with Firing alarm Line 47 ")
            }
        })
        
    }
    
    
    
    
    
    

}// end of class
