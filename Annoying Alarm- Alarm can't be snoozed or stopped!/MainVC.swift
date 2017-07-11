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
       // generateTestData()
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
    cell.configureCell(alarm: alarm)
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
    
    
    @IBAction func enabledSwitchToggled(_ sender: Any) {
        attemptFetch()
        tableView.reloadData()
    }
    
    
    
    
    func generateTestData() {
    
        let alarm = Alarm(context:context)
        alarm.duration = 10
        
        let alarm2 = Alarm(context:context)
        alarm2.duration = 20
        
        let alarm3 = Alarm(context:context)
        alarm3.duration = 20
        
        ad.saveContext()
    }
    
    
    
    
    
    
    
    
    
} // end of class

