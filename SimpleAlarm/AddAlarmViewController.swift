//
//  AddAlarmViewController.swift
//  SimpleAlarm
//
//  Created by Mohanad Alhayek
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class AddAlarmViewController: UIViewController, UITextFieldDelegate {

    var alarm: Alarm?
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var alarmLbl: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.alarmLbl.delegate = self
        self.descriptionText.delegate = self
        // set minimum date/time for picker
        timePicker.minimumDate = NSDate() as Date
        timePicker.locale = NSLocale.current
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // func to check if label is empty
    func checkLabel() {
        let text = alarmLbl.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    // func to check if date has passed
    func checkDate() {
        if NSDate().earlierDate(timePicker.date) == timePicker.date {
            saveButton.isEnabled = false
        }
    }
    
    // hide keyboard when hit enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkLabel()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        checkDate()
    }
    
    @IBAction func cancelBtn(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if saveButton === sender as! UIBarButtonItem {
            let alarmName = alarmLbl.text
            var time = timePicker.date
            let timeInterval = floor(time.timeIntervalSince1970/60) * 60
            print(timeInterval)
            //print(time)
            let someDate = Date()

            // convert Date to TimeInterval (typealias for Double)
            let diffTimeInterval = timeInterval - (someDate.timeIntervalSince1970) as Double
            print(diffTimeInterval)
            
            time = NSDate(timeIntervalSinceReferenceDate: timeInterval) as Date
            //var NSDateComponents nowSecond = [cal components:NSSecondCalendarUnit fromDate:time]
            // build notification
            
            let notification = UNMutableNotificationContent()
            notification.title = "Alarm"
            notification.body = descriptionText.text!
            //notification. = time
            
            notification.sound = UNNotificationSound.default
            
            // Deliver the notification in timeInterval seconds.
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval:diffTimeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: "Alarm", content: notification, trigger: trigger) // Schedule the notification.
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error : Error?) in
                 if let theError = error {
                     // Handle any errors
                    print(theError)
                    // meh
                 }
            }

            
            
            alarm = Alarm(time: time as NSDate, name: alarmName!, content: notification)
            
            // UNUserNotificationCenterDelegate.self
            
        }
        
        
    }

}
