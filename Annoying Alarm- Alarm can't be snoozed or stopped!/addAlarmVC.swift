//
//  addAlarmVC.swift
//  Annoying Alarm- Alarm can't be snoozed or stopped!
//
//  Created by Ali Abouelatta on 7/6/17.
//  Copyright © 2017 Ali Abouelatta. All rights reserved.
//

import UIKit

class addAlarmVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var alarmTime: UIDatePicker!
    @IBOutlet weak var warningBOL: UISwitch!
    @IBOutlet weak var annoyingAlarmBOL: UISwitch!
    @IBOutlet weak var durationPicker: UIPickerView!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var stackViewWarning: UIStackView!
    
    
    
    private var _timeofAlarmTitle:String!
    private var _warningofAlarm:Bool!
    private var _annoyingAlarm:Bool!
    private var _durationAlarm:Double!
    private var _timeofAlarm:Date!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        durationPicker.delegate = self
        durationPicker.dataSource = self
    
        durationPicker.selectRow(4, inComponent: 0, animated: false)
    }
    

    //returns date in GMT so needs to be formatted
    func timeChanged(_ sender: UIDatePicker) -> Date {
        return sender.date
    }
    
    // return in format 06:00 AM for display
    func getTimeString(alarmTime: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone.current
        let localAlarmTime = formatter.string(from: alarmTime)
        return localAlarmTime
    }
    
    //set up duration picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durationArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return durationArray[row]
        
    }
    

    
     //pressing CONFIRM BUTTON
    //Setting up new Alarm in core data and calling Save Function
    //return back to original screen
    @IBAction func confirm(_ sender: Any) {
        
        // Setting up variables and saving to core data
        let timeofAlarm =  timeChanged(alarmTime)
        let timeofAlarmTitle = getTimeString(alarmTime: timeofAlarm)
        let warningofAlarm = warningBOL.isOn
        let annoyingAlarm = annoyingAlarmBOL.isOn
        let durationOfAlarm = durationPicker.selectedRow(inComponent: 0)
        self._timeofAlarm = timeofAlarm
        self._timeofAlarmTitle = timeofAlarmTitle
        self._warningofAlarm = warningofAlarm
        self._annoyingAlarm = annoyingAlarm
        self._durationAlarm = Double(durationOfAlarm)
        print("ALI: time is \(timeofAlarm)  warning is \(warningofAlarm)  duration is\(durationOfAlarm) is annoying \(annoyingAlarm)")
        saveNewAlarmCoreData()
        
        
        
        //Setting Up Alarm using Notifications according to its type
        
        if annoyingAlarm == true {
            Scheduler.sharedInstance.createAnnoyingAlarm(durationIndex: durationOfAlarm, date: timeofAlarm, identifierString: timeofAlarmTitle, warning: warningofAlarm)
        } else {
            Scheduler.sharedInstance.createNormalAlarm(date: timeofAlarm, identifierString: timeofAlarmTitle)
        }
        performSegue(withIdentifier: "backtoMain", sender: nil)
    }
    
    // remove display of duration and warning if its
    // a normal alarm
    @IBAction func annoyingSwitched(_ sender: Any) {
        if annoyingAlarmBOL.isOn == false{
        
            durationPicker.isHidden = true
            stackViewWarning.isHidden = true
            durationLbl.isHidden = true
        } else {
        
            durationPicker.isHidden = false
            stackViewWarning.isHidden = false
            durationLbl.isHidden = false
        }
    }

    
    func saveNewAlarmCoreData () {
        let newAlarm = Alarm(context:context)
        newAlarm.warning = self._warningofAlarm
        newAlarm.duration = self._durationAlarm
        newAlarm.time = self._timeofAlarm as NSDate?
        newAlarm.annoying = self._annoyingAlarm
        newAlarm.timeTitle = self._timeofAlarmTitle
        newAlarm.enabled = true
        ad.saveContext()
    }


}
