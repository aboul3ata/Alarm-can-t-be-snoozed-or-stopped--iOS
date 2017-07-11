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
    

    private var _timeofAlarmTitle:String!
    private var _warningofAlarm:Bool!
    private var _annoyingAlarm:Bool!
    private var _durationAlarm:Double!
    private var _timeofAlarm:Date!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        durationPicker.delegate = self
        durationPicker.dataSource = self
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
        print("\(localAlarmTime) and \(alarmTime)")
        return localAlarmTime
    }
    
    //set up duration picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _durationArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("\(_durationArray[row])")
        return _durationArray[row]
        
    }
    

    //Setting up new Alarm in core data and calling Save Function
    //return back to original screen
    @IBAction func confirm(_ sender: Any) {
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
        print("\(timeofAlarm) \(warningofAlarm) \(annoyingAlarm ) \(durationOfAlarm) is annoying \(annoyingAlarm)")
        saveNewAlarmCoreData()
        performSegue(withIdentifier: "backtoMain", sender: nil)
    }
    
    func saveNewAlarmCoreData () {
        let newAlarm = Alarm(context:context)
        newAlarm.warning = self._warningofAlarm
        newAlarm.duration = self._durationAlarm
        newAlarm.time = self._timeofAlarm as NSDate?
        newAlarm.annoying = self._annoyingAlarm
        newAlarm.timeTitle = self._timeofAlarmTitle
        ad.saveContext()
    }


}
