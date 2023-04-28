//
//  UNUserNotificationCenter.swift
//  D-Day
//
//  Created by hana on 2023/02/15.
//

import Foundation
import UserNotifications

class NotificationCenterManager{
    private let notificationCenter = UNUserNotificationCenter.current()
    
    ///알럿이 켜지면 요청이 추가됨
    func addNotificationRequest(by item: Item, alertData: AlertData){
        if !alertData.isOn {
            return
        }
        
        //알림 내용
        let content = UNMutableNotificationContent()
        content.title = item.title
        content.body = "D-Day"
        content.sound = .default
        content.badge = 1        //생성된 뱃지는 SceneDelegate에서
        
        //트리거 설정
        var component = Calendar.current.dateComponents([.year, .month, .day], from: item.date)//.addingTimeInterval(TimeInterval(25450)))//-86400)))
        component.hour = Calendar.current.dateComponents([.hour], from: alertData.time).hour
        component.minute = Calendar.current.dateComponents([.minute], from: alertData.time).minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        
        //UNUserNotificationCenter에 추가
        let request = UNNotificationRequest(identifier: item.id.stringValue, content: content, trigger: trigger)
        notificationCenter.add(request, withCompletionHandler: nil)
        
        print("addNotificationRequest 완 - \(item.title)")
    }
    
    ///알림 시간 변경(전체)
    func editNotificationTime(by items: [Item], alertData: AlertData){
        notificationCenter.removeAllDeliveredNotifications()
        
        if alertData.isOn {
            items.forEach{
                addNotificationRequest(by: $0, alertData: alertData)
            }
        }
    }
    
    func remove(_ id: String){
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
}
