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


    var userNotificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        //앱 설치 후 실행시 user에게 알림을 승인받음
        let authrizationOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        userNotificationCenter.requestAuthorization(options: authrizationOptions){_, error in
            if let error = error{
                print("ERROR: \(error)")
            }
        }
        
        //필드 이름 변경 , 기존 데이터 값 추가 , 디폴트 관계 데이터 추가
//        let config = Realm.Configuration(
//            schemaVersion: 3,   //새로운 스키마 버전
//            migrationBlock: {migration, oldSchemaVersion in
//                if oldSchemaVersion < 3{    //실행되는 버전이 새스키마 버전보다 작을 경우 수정하도록
//                    migration.renameProperty(onType: Item.className(), from: "backgroundColor", to: "bgColor")
//                }
//            }
//        )
//        
//        Realm.Configuration.defaultConfiguration = config
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
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
