//
//  LocalNotificationHandler.swift
//  LocalNotificationProject
//
//  Created by zhifu360 on 2019/5/17.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotificationHandler: NSObject {

    static let sharedHandler = LocalNotificationHandler()
    
    let LocalNotiReqIdentifer = "LocalNotiReqIdentifer"
    let LOCAL_NOTIFY_SCHEDULE_ID = "LOCAL_NOTIFY_SCHEDULE_ID"
    
    ///注册通知
    func registAPNS() {
        
        if #available(iOS 10, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [UNAuthorizationOptions.alert, UNAuthorizationOptions.badge, UNAuthorizationOptions.sound]) { (granted, error) in
                
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
    }
    
    ///发送本地通知
    func sendLocalNotification() {
        
        let title = "通知-title"
        let subTitle = "通知-subTitle"
        let body = "通知-body"
        let badge: NSNumber = 1
        let timeInteval: TimeInterval = 5
        let usreInfo = ["noticeID": LOCAL_NOTIFY_SCHEDULE_ID]
        
        if #available(iOS 10, *) {
            //创建通知内容
            let content = UNMutableNotificationContent()
            content.sound = .default
            content.title = title
            content.subtitle = subTitle
            content.body = body
            content.badge = badge
            content.userInfo = usreInfo
            //设置通知附件内容
            //设置声音
            //触发模式
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInteval, repeats: false)
            //设置UNNotificationRequest
            let request = UNNotificationRequest(identifier: LocalNotiReqIdentifer, content: content, trigger: trigger)
            //添加通知
            UNUserNotificationCenter.current().add(request) { (error) in
                print("成功添加推送")
                if let tmpError = error {
                    print(tmpError.localizedDescription)
                }
            }
            
        } else {
            let localNotification = UILocalNotification()
            //设置触发时间
            localNotification.fireDate = Date(timeIntervalSinceNow: 5)
            //设置通知标题
            localNotification.alertBody = title
            //设置通知动作按钮标题
            localNotification.alertAction = "查看"
            //设置传递的userInfo
            localNotification.userInfo = usreInfo
            //设置规定日期触发
            UIApplication.shared.scheduleLocalNotification(localNotification)
            //立即触发
//            UIApplication.shared.presentLocalNotificationNow(localNotification)
        }
    }
    
    ///取消本地通知
    func cancelLocalNotificationWith(noticeID: String) {
        
        if #available(iOS 10, *) {
            let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests { requests in
                for request in requests {
                    print("存在的ID = \(request.identifier)")
                }
            }
            
            //根据ID移除
            center.removePendingNotificationRequests(withIdentifiers: [noticeID])
        } else {
            guard let array = UIApplication.shared.scheduledLocalNotifications else {return}
            for localNotifications in array {
                guard let ID = localNotifications.userInfo?[noticeID] as? String else {return}
                if ID == noticeID {
                    UIApplication.shared.cancelLocalNotification(localNotifications)
                }
            }
            
        }
        
    }
    
    ///移除所有通知
    func removeAllLocalNotifications() {
        if #available(iOS 10, *) {
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
        } else {
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }
    
}
