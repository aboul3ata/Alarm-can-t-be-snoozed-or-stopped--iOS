//
//  AppDelegate.swift
//  Annoying Alarm- Alarm can't be snoozed or stopped!
//
//  Created by Ali Abouelatta on 6/16/17.
//  Copyright © 2017 Ali Abouelatta. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import AVFoundation



// Global variables for core data + segue when alarm in foreground
let ad = UIApplication.shared.delegate as! AppDelegate
let context = ad.persistentContainer.viewContext
var player: AVAudioPlayer?
var seguePerformed = 0 // changed to 1 when segeu performed and to zero when button pressed back to original view

var identifierForNormal: String?
var identifierForAnnoying: String?




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        configureUserNotifications()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
 
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    
    // Setting up Category(action buttons) for snooze and dismiss
    private func configureUserNotifications() {
        let snoozeAction = UNNotificationAction(identifier: "snoozeBtn", title: "Snooze", options: [])
        let dismissAction = UNNotificationAction(identifier: "dismissBtn", title: "Dismiss", options: [])
        let category = UNNotificationCategory(identifier: "normalAlarmCategory", actions: [snoozeAction, dismissAction], intentIdentifiers: [], options: [])
        //UNUserNotificationCenter.current().setNotificationCategories([])
        
        
        let warningAction = UNNotificationAction(identifier: "warningBtn", title: "I am awake", options: [])
        let categoryWarning = UNNotificationCategory(identifier: "myWarningCategory", actions: [warningAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([categoryWarning, category])
        
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Annoying_Alarm__Alarm_can_t_be_snoozed_or_stopped_")
//        let description = NSPersistentStoreDescription()
//        
//        description.shouldInferMappingModelAutomatically = true
//        description.shouldMigrateStoreAutomatically = true
//        
//        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}




// Handling pressing Snooze or Dismiss buttons
// Handling alarm in foreground
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    
    
    
    //Making sound play in foreground
    // Changing View in foreground to activeAlarm
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("ALI identifier: \(notification.request.content.categoryIdentifier)")
        center.removeAllDeliveredNotifications()
        let url = Bundle.main.url(forResource: "oldClock", withExtension: "wav")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.numberOfLoops = 2
            player.play()
            player.volume = 1
        } catch let error as NSError {
            
            print("ALI error playing audio is \(error)")
        }
        
        let typeOfNotificiation = notification.request.content.categoryIdentifier
        
        
        // special view for annoying alarm (no dismiss or snooze buttons) or without in case of normal alarm
        if typeOfNotificiation == "myNotificationCategory" {

            self.performSegueCustom(segueIdentifier: "activeAlarm")
        }
        
        if typeOfNotificiation == "normalAlarmCategory" {
            
            let identifierNew = notification.request.identifier
            identifierForNormal = identifierNew.dropLast(2)

            self.performSegueCustom(segueIdentifier: "activeAlarm2")
        
        }
//        else if typeOfNotificiation == "normalAlarmCategory" {
//            self.performSegueCustom(segueIdentifier: "activeAlarm2")
//        }
        
        

        
        
        
    } // end of function!
    
    
    
    // method for perform segues from app delegate
    // responsible for displaying the new view of activeAlarm
    
    private func performSegueCustom(segueIdentifier:String) {
        
        
        //get the root view controller
        var currentViewController = UIApplication.shared.keyWindow?.rootViewController
        
        //loop over the presented view controllers and until you get the top view controller
        while currentViewController?.presentedViewController != nil{
            currentViewController = currentViewController?.presentedViewController
        }
        
        //And finally
        if seguePerformed == 0 {
            currentViewController?.performSegue(withIdentifier: segueIdentifier , sender: nil)
            seguePerformed = 1
        }
        
        
    }
    
    
    
    // handling snooze or dismiss event
    //handling warning alarm
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        center.removeAllDeliveredNotifications()
        print("ALI Response received for \(response.actionIdentifier) ")
        var identifierNew = response.notification.request.identifier              // retrieving identifier without the numbers appended at the end
        identifierNew = identifierNew.dropLast(2)
        
        
        
        
        // need better OR format
        if (response.actionIdentifier == "dismissBtn" || response.actionIdentifier == "snoozeBtn") {
            print("ALI  \(response.notification.request.identifier)")
            Scheduler.sharedInstance.cancelAlarm(identifier: identifierNew)
            
            // If its original alarm reshedule it after 5 minutes do be functional tomorrow
            if identifierNew != "snoozedAlarm" {
                
                Timer.scheduledTimer(withTimeInterval: 370, repeats: false) {
                    timer in
                    Scheduler.sharedInstance.rescheduleAlarm(identifier: identifierNew, normalAlarm: true)
                }
                
            }
            // exclusive functionalty for snooze button
            // generate an alarm of type snoozed Alarm 
            // fires after 5 minutes from pressing
            if response.actionIdentifier == "snoozeBtn" {
                Scheduler.sharedInstance.regenerateSnoozedAlarm()
            }
        } // end of if
        
        
        if response.actionIdentifier == "warningBtn" {
        
            Scheduler.sharedInstance.cancelspecialAnnoyingAlarm(identifier: identifierNew, durationIndex: 9, warning: true)
            
            Timer.scheduledTimer(withTimeInterval: 500, repeats: false) {
                timer in
                Scheduler.sharedInstance.rescheduleAlarm(identifier: identifierNew, normalAlarm: false)
            }
        
        }
        
        
        completionHandler()
    } // end of function
    
}
