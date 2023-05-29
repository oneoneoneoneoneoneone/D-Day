//
//  AppDelegate.swift
//  D-Day
//
//  Created by hana on 2023/01/26.
//

import UIKit
import RealmSwift
import NotificationCenter
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.delegate = self
        
        //앱 설치 후 실행시 user에게 알림을 승인받음
        let authrizationOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        userNotificationCenter.requestAuthorization(options: authrizationOptions){_, error in
            if let error = error{
                print("ERROR: \(error)")
            }
        }
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    //userNotificationCenter에서 알림을 보내기 전에 어떤 처리를 할지
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .badge, .sound])    //배너, 알림, 사운드 .. 등
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
