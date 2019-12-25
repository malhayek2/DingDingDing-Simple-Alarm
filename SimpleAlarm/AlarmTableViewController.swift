//
//  AlarmTableViewController.swift
//  SimpleAlarm
//
//  Created by Mohanad Alhayek .
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class AlarmTableViewController: UITableViewController {

    // Properties
    var alarms = [Alarm]()
    let dateFormatter = DateFormatter()
    let locale = NSLocale.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Set Formatter date setting
      //  dateFormatter.locale = locale
        dateFormatter.timeStyle = .short
        
        // load alarm
        if let savedAlarm = loadAlarm() {
            alarms += savedAlarm
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if alarms.count == 0 {
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        }
        else {
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        }
        return alarms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath)

        // Configure the cell
        tableView.rowHeight = 100
        
        let alarm = alarms[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 50)
        cell.textLabel?.text = dateFormatter.string(from: alarm.time as Date)
        cell.detailTextLabel?.text = alarm.name

        // Create switch
        let sw = UISwitch(frame: CGRect())
        sw.setOn(false, animated: true)
        sw.tag = indexPath.row
        sw.addTarget(self, action: #selector(self.switchChanged(_:)), for: UIControl.Event.valueChanged)
        sw.isOn = UserDefaults.standard.bool(forKey: "isDarkMode")
        
        
        cell.accessoryView = sw
        
        return cell
    }
    
    @IBAction func switchChanged(_ sender: UISwitch!) {
        if sender.isOn {
            print("ON")
        }
        else {
            print("OFF")
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
         //   UIApplication.shared.cancelAllLocalNotifications()
        }
        
    }
    

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _ = alarms.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            savedAlarm()
        }   
    }
    
    @IBAction func unwindtoAlarm(sender:UIStoryboardSegue) {
        if let sourceView = sender.source as? AddAlarmViewController, let alarm = sourceView.alarm {
            let newIndexPath = NSIndexPath(row: alarms.count, section: 0)
            alarms.append(alarm)
            tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
            savedAlarm()
            tableView.reloadData()
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: NSCoding
    
    func savedAlarm() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(alarms, toFile: Alarm.ArchiveURL.path)
        if (isSuccessfulSave) { print("Save alarm successfully")}
        else { print("Failed to save alarm")}
    }
    
    func loadAlarm() -> [Alarm]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Alarm.ArchiveURL.path) as? [Alarm]
    }

}
