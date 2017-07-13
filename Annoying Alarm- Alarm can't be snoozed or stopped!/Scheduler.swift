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
    
    
    
    
    // THIS repetitive notification every 10 seconds to simulate alarm
    // This is adding local notification to function as alarm
    // THIS IS FOR ANNOYING ALARM OPTION ONLY
    
    func createNewAlarm(durationIndex:Int ,date: Date , identifierString: String){
        
        
        // UI of notification
        let content = UNMutableNotificationContent()
        content.title = "WAKE UP"
        content.body = "ITS TIMEE!!!"
        content.sound = UNNotificationSound.init(named:"oldClock.wav")
        content.categoryIdentifier = "myNotificationCategory"
        print("\(durationIndex)")
        
        // Setting multiple (every 10 seconds) notifications
        // Based on duration of alarm
        for y in 0...durationIndex {
    
            for x in 0...5 {
    
                var triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
                triggerDaily.second = x*10
                
                triggerDaily.minute = triggerDaily.minute! + y
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                let identifier = "\(identifierString)\(x)\(y)" // This is the titleofalarm so can be easily accessed if want to edit or delete
                let request = UNNotificationRequest(identifier: identifier,
                                                    content: content, trigger: trigger)
                center.add(request, withCompletionHandler: { (error) in
                    if error != nil {
                        print ("ALI: Something wrong with createNewAlarm function aka firing the alarm  ")
                    } else {
                        print ("ALI: \(triggerDaily)")
                    }
                })
            }
        } // end of first For loop
        self.center.getPendingNotificationRequests(completionHandler: { (notifications) in
            print("count", notifications.count)
            for notification in notifications{
                print(notification.description)
            }
        })
        
    }
    
    
    
    
    // THIS IS FOR NORMAL ALARM OPTION ONLY
    // Difference #1 in normal alarm duration is set to 5 minutes (no duration input)
    // Difference #2 handling of snooze and dismiss functionality
    
    func createNormalAlarm(date: Date, identifierString: String){
        
        // UI of notification
        let content = UNMutableNotificationContent()
        content.title = "WAKE UP"
        content.body = "ITS TIMEE!!!"
        content.sound = UNNotificationSound.init(named:"oldClock.wav")
        content.categoryIdentifier = "normalAlarmCategory" //Adds the action buttons for snooze and dismiss check app delegate!
        
        
        
        var counter:Int = 0
        
        for y in 0...5 {
            
            for x in 0...5 {
                
                var triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
                triggerDaily.second = x*10
                triggerDaily.minute = triggerDaily.minute! + y
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                let identifier = "\(identifierString)\(counter)" // This is the titleofalarm so can be easily accessed if want to edit or delete
                let request = UNNotificationRequest(identifier: identifier,
                                                    content: content, trigger: trigger)
                center.add(request, withCompletionHandler: { (error) in
                    if error != nil {
                        print ("ALI: Something wrong with createNormalAlarm function aka firing the alarm  ")
                    } else {
                        print ("ALI: \(triggerDaily)")
                    }
                })
                counter += 1
            } // end of second for loop
        } // end of first For loop
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
