//
//  NotificationList.swift
//  recipeapp
//
//  Created by Damir Kazbekov on 6/4/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import Foundation
import UIKit

class NotificationList {
    class var sharedInstance : NotificationList {
        struct Static {
            static let instance: NotificationList = NotificationList()
        }
        return Static.instance
    }
    
    fileprivate let ITEMS_KEY = "notificationItems"
    
    func allItems() -> [NotificationItem] {
        let todoDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? [:]
        let items = Array(todoDictionary.values)
        return items.map({
            let item = $0 as! [String:AnyObject]
            return NotificationItem(deadline: item["deadline"] as! Date, title: item["title"] as! String, UUID: item["UUID"] as! String!)
        }).sorted(by: {(left: NotificationItem, right:NotificationItem) -> Bool in
            (left.deadline.compare(right.deadline) == .orderedAscending)
        })
    }
    
    func addItem(_ item: NotificationItem) {
        // persist a representation of this todo item in NSUserDefaults
        var todoDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        todoDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
        UserDefaults.standard.set(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "\(item.title)" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = item.deadline as Date // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func removeItem(_ item: NotificationItem) {
        let scheduledNotifications: [UILocalNotification]? = UIApplication.shared.scheduledLocalNotifications
        guard scheduledNotifications != nil else {return} // Nothing to remove, so return
        
        for notification in scheduledNotifications! { // loop through notifications...
            guard let notificationUUID = notification.userInfo!["UUID"] else { return }
            if (notificationUUID as! String == item.UUID) { // ...and cancel the notification that corresponds to this TodoItem instance (matched by UUID)
                UIApplication.shared.cancelLocalNotification(notification) // there should be a maximum of one match on UUID
                break
            }
        }
        
        if var todoItems = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) {
            todoItems.removeValue(forKey: item.UUID)
            UserDefaults.standard.set(todoItems, forKey: ITEMS_KEY) // save/overwrite todo item list
        }
    }
}
