//
//  MainVC.swift
//  Annoying Alarm- Alarm can't be snoozed or stopped!
//
//  Created by Ali Abouelatta on 6/16/17.
//  Copyright © 2017 Ali Abouelatta. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Alarm>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        attemptFetch()
        Scheduler.sharedInstance.requestauthorizationFirstTime()


        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         attemptFetch()
    }


    
    // Table View data Source and Delegate functions

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell" , for: indexPath) as! AlarmCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
//        return UITableViewCell()
    }
    
    func configureCell(cell: AlarmCell, indexPath:NSIndexPath){
    
    let alarm = controller.object(at: indexPath as IndexPath)
        cell.configureCell(alarm: alarm, indexPath: indexPath as IndexPath)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
        
        return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    
    // core data set up
    func attemptFetch() {
    
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
        
    } // end of attempt fetch
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        
        
        case.insert:
            if let indexPath = newIndexPath {
            
            tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        
        
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            break
            
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! AlarmCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            
            }
            break
        }
    }
    
    // END of Core Data set up
    

    //Cancelling or scheduling alarm when switch is toggled
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        

        //toggling switch back to original state upon changing view
        // improvement can be done by disallowing users to toggle switch
        
        
        
        if player?.isPlaying == true {
            
            if sender.isOn {
            
                sender.isOn = false
                
            } else {
            
                sender.isOn = true
            }
        }
        
        // shouldnt be able to toggle switch if alarm is already fired
        if player?.isPlaying != true {
        
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! AlarmCell!
            let identifier = cell!.time.text
            let isNormalAlarm = cell!.img.isHidden
            let durationLbl: String = cell!.duration.text!
            let durationLblNew = durationLbl.toLengthOf(length: 10)
            let durationIndex = durationArray.index(of: durationLblNew)
            
            attemptFetch()
            
            
            for object in self.controller.fetchedObjects!{
                if object.timeTitle == identifier {
                    
                    //cell!.enabledswitch.isOn = false
                    print("\(durationIndex) \(durationLblNew)")
                    if sender.isOn {
                        //Normal alarm switched on
                        if isNormalAlarm {
                            object.enabled = true
                            Scheduler.sharedInstance.rescheduleAlarm(identifier: identifier!, normalAlarm: true)
                            print(object)
                            //Annoying alarm switched on
                        } else {
                            object.enabled = true
                            Scheduler.sharedInstance.rescheduleAlarm(identifier: identifier!, normalAlarm: false)
                            print(object)
                        }
                        
                    } else {
                        //Normal alarm switched off
                        if isNormalAlarm {
                            object.enabled = false
                            Scheduler.sharedInstance.cancelAlarm(identifier: identifier!)
                            print(object)
                        } else {
                            //Annoying alarm switched off
                            object.enabled = false
                            Scheduler.sharedInstance.cancelspecialAnnoyingAlarm(identifier: identifier!, durationIndex: durationIndex!, warning: object.warning)
                            print(object)
                            
                        } // end of else 2
                    } // end of else 1
                    
                    ad.saveContext()
                }// end of first if HUGE
            }// end of first FOR HUGE
            //CHECK TO SEE IF attemptFetch is really necessary
            attemptFetch()
            tableView.reloadData()
        
        
        }
  
    }// end of function
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    // Delete a row from table view by swiping to left
    //removing from core data + cancel any notifications from that
     
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
 
            if editingStyle == .delete {
            
            let cell = tableView.cellForRow(at: indexPath) as! AlarmCell
            let identifier = cell.time.text

            for object in self.controller.fetchedObjects!{
                if object.timeTitle == identifier {
                    if object.annoying {
                        Scheduler.sharedInstance.cancelspecialAnnoyingAlarm(identifier: identifier!, durationIndex: Int(object.duration), warning: object.warning)
                    } else {
                        Scheduler.sharedInstance.cancelAlarm(identifier: identifier!)
                    }

                    print(identifier!)
                   context.delete(object)
                    ad.saveContext()
                    attemptFetch()
                    //tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                    
                }
            }

        }

    }
    

    
/*
    func generateTestData() {
    
        let alarm = Alarm(context:context)
        alarm.duration = 10
        
        let alarm2 = Alarm(context:context)
        alarm2.duration = 20
        
        let alarm3 = Alarm(context:context)
        alarm3.duration = 20
        
        ad.saveContext()
    }
    
    */
    
    
    
    
} // end of class

