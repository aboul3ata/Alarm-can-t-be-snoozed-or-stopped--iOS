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

class Scheduler {
    
    //Creating Singleton
    static let sharedInstance = Scheduler()
    private init() {}
    
    
    var controller: NSFetchedResultsController<Alarm>!
    

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
    
    func createAnnoyingAlarm(durationIndex:Int ,date: Date , identifierString: String){
        
        
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
                
                // append counter to be two digits eg 01 instead of 1
                // needed later to retriever identifierString by removing last two digits
                var identifier: String
                
                if counter < 10 {
                    identifier = "\(identifierString)0\(counter)" // This is the titleofalarm so can be easily accessed
                } else {
                    identifier = "\(identifierString)\(counter)" // This is the titleofalarm so can be easily accessed
                }
                
                
                
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
    }
    
    
    
    
    // 2 functions Called from app delegate when user presses dismiss
    // one to cancel ongoing alarm
    //one to schedule alarms again called 5 minutes later
    func cancelAlarm(identifier: String){
        
        for num in 0...35 {
            if num < 10 {
                let identifierwithNumber = "\(identifier)0\(num)"
                center.removePendingNotificationRequests(withIdentifiers: [identifierwithNumber])
            } else {
                let identifierwithNumber = "\(identifier)\(num)"
                center.removePendingNotificationRequests(withIdentifiers: [identifierwithNumber])
            }
        }
        
        print ("ALI REMOVED ALARMS SUCCESSFULLY")
    }
    
    
    
    
    // Annoying alarms cant be dismissed however this is needed
    // when switch is toggled to cancel alarm inside app
    func cancelspecialAnnoyingAlarm(identifier: String, durationIndex: Int) {
        
        for y in 0...durationIndex{
            for x in 0...5 {
                let identifierwithNumber = "\(identifier)\(x)\(y)"
                center.removePendingNotificationRequests(withIdentifiers: [identifierwithNumber])
            }
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
            let error = error as NSError
            print("\(error)")
            
        } // end of catch
        
        
        self.controller = controller
        
        for object in self.controller.fetchedObjects!{
            if object.timeTitle == identifier {
                let date = object.time as! Date
                let duration = Int(object.duration)
                if normalAlarm {
                    createNormalAlarm(date: date, identifierString: identifier)
                } else {
                    createAnnoyingAlarm(durationIndex: duration, date: date, identifierString: identifier)
                }

            }
        }
    }
    
    
    
    
    //generate Alarm after 5 minutes 
    func regenerateSnoozedAlarm() {
        
            for num in 0...35 {
                let content = UNMutableNotificationContent()
                content.title = "WAKE UP 2.0"
                content.body = "ITS TIMEE!!! YOU ALREADY SNOOZED !!"
                content.sound = UNNotificationSound.init(named:"oldClock.wav")
                content.categoryIdentifier = "normalAlarmCategory"
                
                let extraSeconds = Double(num * 10)
                let timeInterval: Double = 370 + extraSeconds
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                
                var identifier: String
                
                
                if num < 10 {
                    identifier = "snoozedAlarm0\(num)"
                } else {
                    identifier = "snoozedAlarm\(num)"
                }
        
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
    

    
}// end of class
