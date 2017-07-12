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
    
    //Creating Singleton
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
    
    
    
    
    // THIS IS ONLY 30 second alarm
    // This is adding local notification to function as alarm
    
    func createNewAlarm(date: Date , identifierString: String){
        
        // UI of notification
        let content = UNMutableNotificationContent()
        content.title = "WAKE UP"
        content.body = "ITS TIMEE!!!"
        content.sound = UNNotificationSound.init(named:"btn.wav")
        
        //Setting up the repeat pattern
        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        
        let identifier = identifierString // This is the titleofalarm so can be easily accessed if want to edit or deleter
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print ("ALI: Something wrong with createNewAlarm function aka firing the alarm  ")
            } else {
                print ("ALI: \(triggerDaily)")
            }
        })
        print(center)
    }
    
    
    
    //ONLY FOR TESTING
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
                print ("ALI: Something wrong with Firing alarm  ")
            }
        })
    }
    
    
    
    

}// end of class
