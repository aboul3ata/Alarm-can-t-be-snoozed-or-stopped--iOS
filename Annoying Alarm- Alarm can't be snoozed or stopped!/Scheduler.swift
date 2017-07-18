//
//  Scheduler.swift
//  Annoying Alarm- Alarm can't be snoozed or stopped!
//
//  Created by Ali Abouelatta on 7/12/17.
//  Copyright © 2017 Ali Abouelatta. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData
import EventKit


class Scheduler {
    
    //Creating Singleton
    static let sharedInstance = Scheduler()
    private init() {}
    
    
    var controller: NSFetchedResultsController<Alarm>!
    var xoxo:Int = 0

   private let center = UNUserNotificationCenter.current()     // Where Notifications are managed
   private let options: UNAuthorizationOptions = [.alert, .sound, .badge];
    
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
    
    func createAnnoyingAlarm(durationIndex:Int ,date: Date , identifierString: String, warning: Bool){
        

        
        
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
    
            for x in 0...1 {
    
                var triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
                triggerDaily.second = x*30
                
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
        
        // creating warning notification 2 minutes before original
        if warning == true {
            
            let contentWarning = UNMutableNotificationContent()
            contentWarning.title = "Are you up"
            contentWarning.body = "Your alarm will fire in 2 minutes and you wont be able to stop it the."
            contentWarning.sound = UNNotificationSound.default()
            contentWarning.categoryIdentifier = "myWarningCategory"
            
            
            var triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
            triggerDaily.second = 0
            
            
            
            // dealing with case of alarm set at 00 so need to change hour by 1 for warning
            if triggerDaily.minute! < 2 {
                
                triggerDaily.minute = (60 + triggerDaily.minute!) - 2 //basically changing 01 minute to 59 minute etc
                triggerDaily.hour = triggerDaily.hour! - 1
                
            } else {
                    triggerDaily.minute = triggerDaily.minute! - 2
            }

            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
            let identifier = "\(identifierString)W0" // This is the titleofalarm so can be easily accessed if want to edit or delete
            let request = UNNotificationRequest(identifier: identifier,
                                                content: contentWarning, trigger: trigger)
            center.add(request, withCompletionHandler: { (error) in
                if error != nil {
                    print ("ALI: Something wrong with createNewAlarm function aka firing the alarm  ")
                } else {
                    print ("ALI: \(triggerDaily)")
                }
            })
            
            
        }
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
        
        for y in 0...3 {
            
            for x in 0...1 {
                var triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
                triggerDaily.second = x*30
                triggerDaily.minute = triggerDaily.minute! + y
    
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                
                // append counter to be two digits eg 01 instead of 1
                // needed later to retriever identifierString by removing last two digits
                var identifier: String
                
                    identifier = "\(identifierString)0\(counter)" // This is the titleofalarm so can be easily accessed

                
                
                
                let request = UNNotificationRequest(identifier: identifier,
                                                    content: content, trigger: trigger)
                center.add(request, withCompletionHandler: { (error) in
                    if error != nil {
                        print ("ALI: Something wrong with createNormalAlarm function aka firing the alarm  ")
                    } else {
                        print ("ALI: \(triggerDaily) \(identifier)")
                    }
                })
                counter += 1
            } // end of second for loop
        } // end of first For loop
        
        self.center.getPendingNotificationRequests(completionHandler: { (notifications) in
            print("count", notifications.count)
            for _ in notifications{
                //print(notification.description)
            }
        })
    }
    
    
    
    
    // 2 functions Called from app delegate when user presses dismiss
    // one to cancel ongoing alarm
    //one to schedule alarms again called 5 minutes later
    func cancelAlarm(identifier: String){
        
        for num in 0...8 {
            
                let identifierwithNumber = "\(identifier)0\(num)"
                center.removePendingNotificationRequests(withIdentifiers: [identifierwithNumber])
            
        }
        
        print ("ALI REMOVED ALARMS SUCCESSFULLY")
    }
    
    
    
    
    // Annoying alarms cant be dismissed however this is needed
    // when switch is toggled to cancel alarm inside app
    func cancelspecialAnnoyingAlarm(identifier: String, durationIndex: Int, warning: Bool) {
        
        for y in 0...durationIndex{
            for x in 0...1 {
                let identifierwithNumber = "\(identifier)\(x)\(y)"
                center.removePendingNotificationRequests(withIdentifiers: [identifierwithNumber])
            }
        }
        
        if warning == true {
            let identifierWarning = "\(identifier)W0"
            center.removePendingNotificationRequests(withIdentifiers: [identifierWarning])
        
        }
    
    print (" canceled ANNOYING ALARM I guess with  duration index \(durationIndex) and identifier \(identifier)")
    
    }
    
    
    // NEED TO REDO TO ENHANCE PERFORMANE
    // RIGHT NOW I am fetching all alarms and checking against identifier time consuming and memory heavy!
    func rescheduleAlarm(identifier: String , normalAlarm: Bool){
        
        // core data fetchingggg
        let fetchRequest: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        let datasort = NSSortDescriptor(key: "time", ascending: true)
        fetchRequest.sortDescriptors = [datasort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            try controller.performFetch()
        } catch {
            _ = error as NSError
            //print("\(error)")
            
        } // end of catch
        
        
        self.controller = controller
        
        for object in self.controller.fetchedObjects!{
            if object.timeTitle == identifier {
                let date = object.time as! Date
                let duration = Int(object.duration)
                let warningBol = object.warning
                if normalAlarm {
                    createNormalAlarm(date: date, identifierString: identifier)
                } else {
                    createAnnoyingAlarm(durationIndex: duration, date: date, identifierString: identifier, warning: warningBol )
                }

            }
        }
    }
    
    
    
    
    //generate Alarm after 5 minutes 
    // s
    func regenerateSnoozedAlarm() {
        
            for num in 0...8 {
                let content = UNMutableNotificationContent()
                content.title = "WAKE UP 2.0"
                content.body = "ITS TIMEE!!! YOU ALREADY SNOOZED !!"
                content.sound = UNNotificationSound.init(named:"oldClock.wav")
                content.categoryIdentifier = "normalAlarmCategory"
                
                let extraSeconds = Double(num * 30)
                let timeInterval: Double = 370 + extraSeconds
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                
                var identifier: String
                

                identifier = "snoozedAlarm0\(num)"
                
        
                let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
                center.add(request, withCompletionHandler: { (error) in
                    if error != nil {
                        print ("ALI: Something wrong with Firing alarm  ")
                    }
                })
            }
        print("ALI successfully regenerated snooze alarm")
    } // end of regenateSnoozedAlarm
    
    
    // local notification are 64 limit here we see if limit of 59 is reached so present user
    //with an error of too many active alarms!
    func notificationLimitReached(){
        
        // core data fetchingggg
        let fetchRequest: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        let datasort = NSSortDescriptor(key: "time", ascending: true)
        fetchRequest.sortDescriptors = [datasort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            try controller.performFetch()
        } catch {
            _ = error as NSError
            //print("\(error)")
            
        } // end of catch
        
        self.controller = controller
        
        // counting pending notifications
        var pendingNotifsCounter = 0
        for object in self.controller.fetchedObjects!{
            if object.annoying {
                if object.enabled {pendingNotifsCounter += Int((object.duration + 1.0) * 2.0)}
                if object.enabled && object.warning{
                    pendingNotifsCounter += 1 //add one for the warning notif
                }
            } else {
                if object.enabled {pendingNotifsCounter += 8 }
            }
            
                
        }
        print("pending notifs \(pendingNotifsCounter)")
        
        
        
        }
    
    //Async getting count of pending notifications
    // cant use DK how:(
    /*
    func isNotificationLimitreached(completed: @escaping (Bool)-> Void = {_ in }) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            
            completed(requests.count > 59)
        })
    }
 */

    
}// end of class
