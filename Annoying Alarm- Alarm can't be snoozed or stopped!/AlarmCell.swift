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
    
    private let _durationArray = ["30 seconds", "60 seconds" ,"90 seconds","2 minutes"
        ,"3 minutes", "4 minutes","5 minutes" , "7 minutes", "10 minutes", "15 minutes"]
    func configureCell(alarm: Alarm){
        
    let durationConverted = _durationArray[Int(alarm.duration)] // changing the index of duration to appropiate value for display
    duration.text = "Duration: \(durationConverted) minutes"
    warning.text = "Warning is \(alarm.warning)"
    time.text = "\(alarm.timeTitle)"
        if alarm.annoying != true {
        
            normalLabel.isHidden = false
            img.isHidden = true
        
        
        }
    }

    


}
