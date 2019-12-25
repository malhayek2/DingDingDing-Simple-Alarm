//
//  Alarm.swift
//  SimpleAlarm
//
//  Created by Moahand Alhayek
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
class Alarm: NSObject, NSCoding {
    var content = UNMutableNotificationContent()
    //var notification: UILocalNotification
    var time: NSDate
    var name: String
    // Archive path for Persistent Data
    static let DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentDirectory.appendingPathComponent("alarms")
    
    // enum for property keys
    struct PropertyKeys {
        static let timeKey = "time"
        static let notificationKey = "notification"
        static let nameKey = "name"
    }
    
    // Initializer
    init(time: NSDate,name: String, content : UNMutableNotificationContent )
    {
        self.time = time
        self.content = content
        self.name = name
        
        super.init()
    }
    
    // Deconstructor
    deinit {
        // Cancel Notification
        // might wanna look into different remove methods.
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        //UIApplication.shared.cancelLocalNotification(self.content)
    }
    
    // NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(time, forKey: PropertyKeys.timeKey)
        
        //aCoder.encode(content, forKey: PropertyKeys.notificationKey)
        aCoder.encode(name, forKey: PropertyKeys.nameKey)
        
    }

    
    required convenience init(coder aDecoder: NSCoder)
    {
        let time = aDecoder.decodeObject(forKey: PropertyKeys.timeKey) as! NSDate
        //decodes as a different object for some reason and cant cast it/
        // prop list is suggested 
       // let content = aDecoder.decodeObject(forKey: PropertyKeys.notificationKey) as! UNMutableNotificationContent
        let name = aDecoder.decodeObject(forKey: PropertyKeys.nameKey) as! String
        let noti = UNMutableNotificationContent()
        self.init(time: time, name: name, content: noti)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
