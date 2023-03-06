//
//  UNUserNotificationCenter.swift
//  D-Day
//
//  Created by hana on 2023/02/15.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter{
    //알럿이 켜지면 요청이 추가됨
    func addNotificationRequest(by item: Item, alertTime: AlertTime){//day: Int, time: Date){
        let content = UNMutableNotificationContent()
        
        content.title = item.title
        content.body = "설정한 D-Day가 .. "
        content.sound = .default
        content.badge = 1        //생성된 뱃지는 SceneDelegate에서 없앰
        
        //트리거 설정
        
        var component = Calendar.current.dateComponents([.year, .month, .day], from: item.date.addingTimeInterval(TimeInterval(-86400*alertTime.day)))
        component.hour = Calendar.current.dateComponents([.hour], from: alertTime.time).hour
        component.minute = Calendar.current.dateComponents([.minute], from: alertTime.time).minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        let request = UNNotificationRequest(identifier: item.id.stringValue, content: content, trigger: trigger)
        //UNUserNotificationCenter에 추가
        self.add(request, withCompletionHandler: nil)
        
        print("addNotificationRequest 완 - \(item.title)")
    }
    
    ///알림 시간 변경(전체)
    func editNotificationTime(by items: [Item], alertTime: AlertTime){
        self.removeAllDeliveredNotifications()
        
        items.forEach{
            addNotificationRequest(by: $0, alertTime: alertTime)
        }
    }
    
}
