//
//  activeNormalAlarmVC.swift
//  Annoying Alarm- Alarm can't be snoozed or stopped!
//
//  Created by Ali Abouelatta on 7/16/17.
//  Copyright © 2017 Ali Abouelatta. All rights reserved.
//

import UIKit

class activeNormalAlarmVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //MOST code is repeated for each button
    // room for enhancing performance !!
    
    
    @IBAction func backtoalarms2Pressed(_ sender: Any) {
        seguePerformed = 0
        performSegue(withIdentifier: "backToMain2", sender: nil)
    }

    @IBAction func SnoozeBtnPressed(_ sender: Any) {
        
        print("ALI ur global variable is \(identifierForNormal!)")
        
        player?.pause()
        Scheduler.sharedInstance.cancelAlarm(identifier: identifierForNormal!)
        
        // If its original alarm reshedule it after 5 minutes do be functional tomorrow
        if identifierForNormal! != "snoozedAlarm" {
            
            Timer.scheduledTimer(withTimeInterval: 370, repeats: false) {
                timer in
                Scheduler.sharedInstance.rescheduleAlarm(identifier: identifierForNormal!, normalAlarm: true)
            }
            
        }
        
        Scheduler.sharedInstance.regenerateSnoozedAlarm()
        
        seguePerformed = 0
        performSegue(withIdentifier: "backToMain2", sender: nil)
    }

    @IBAction func dismissBtnPressed(_ sender: Any) {
        
        print("ALI ur global variable is \(identifierForNormal!)")
        
        player?.pause()
        Scheduler.sharedInstance.cancelAlarm(identifier: identifierForNormal!)
        
        // If its original alarm reshedule it after 5 minutes do be functional tomorrow
        if identifierForNormal! != "snoozedAlarm" {
            
            Timer.scheduledTimer(withTimeInterval: 370, repeats: false) {
                timer in
                Scheduler.sharedInstance.rescheduleAlarm(identifier: identifierForNormal!, normalAlarm: true)
            }
            
        }
        
        
        
        seguePerformed = 0
        performSegue(withIdentifier: "backToMain2", sender: nil)

    }

}
