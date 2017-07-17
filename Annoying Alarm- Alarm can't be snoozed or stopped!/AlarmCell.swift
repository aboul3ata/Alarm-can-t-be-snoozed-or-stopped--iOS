//
//  AlarmCell.swift
//  Annoying Alarm- Alarm can't be snoozed or stopped!
//
//  Created by Ali Abouelatta on 6/17/17.
//  Copyright © 2017 Ali Abouelatta. All rights reserved.
//

import UIKit
class AlarmCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var warning: UILabel!
    @IBOutlet weak var normalLabel: UILabel!
    @IBOutlet weak var enabledswitch: UISwitch!
    @IBOutlet weak var allCell: UIView!

    func configureCell(alarm: Alarm, indexPath: IndexPath){
        
        
        // displaying labels of duration and enabled on cell only if its annoying kind
        
        if alarm.annoying == true {
            
            let durationConverted = durationArray[Int(alarm.duration)] // changing the index of duration to appropiate value for display
            duration.text = "Duration: \(durationConverted)"

            if alarm.warning {
                warning.text = "Warning is ENABLED"

            } else {
                warning.text = "Warning is DISABLED"
            }
        } else {
        
        warning.text = ""
        duration.text = " Ability to snooze and dismiss"
        
        }

    time.text = "\(alarm.timeTitle)"

        
        if alarm.annoying != true {
            normalLabel.isHidden = false
            img.isHidden = true
        }

        // Making Cell opaque when alarm is not enabled

        
        
        if alarm.enabled == true {
            enabledswitch.isOn = true
            
        } else {
            enabledswitch.isOn = false
        }
        
        
        if enabledswitch.isOn {
            allCell.alpha = CGFloat(1)
        } else {
            allCell.alpha = CGFloat(0.4)
        }
        
        duration.tag = indexPath.row
        warning.tag = indexPath.row
        time.tag = indexPath.row
        enabledswitch.tag = indexPath.row
        normalLabel.tag =  indexPath.row
        img.tag = indexPath.row
        
        
        
        
     } // end of Configure Cell

    
    


} // end of Class
