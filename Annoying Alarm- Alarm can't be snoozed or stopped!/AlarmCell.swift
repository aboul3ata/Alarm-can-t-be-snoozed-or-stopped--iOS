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
    
    
    func configureCell(alarm: Alarm){
    
    //time.text = alarm.time
    duration.text = "Duration: \(alarm.duration) minutes"
    warning.text = "Warning is \(alarm.warning)"
        
    
    }
}
