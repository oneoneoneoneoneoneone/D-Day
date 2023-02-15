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
    func addNotificationRequest(by item: Item){
        let content = UNMutableNotificationContent()
        
        content.title = item.title
        content.body = "설정한 D-Day가 .. "
        content.sound = .default
        content.badge = 1        //생성된 뱃지는 SceneDelegate에서 없앰
        
        //트리거 설정
        let component = Calendar.current.dateComponents([.year, .month, .day], from: item.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
        let request = UNNotificationRequest(identifier: item.id.stringValue, content: content, trigger: trigger)
        //UNUserNotificationCenter에 추가
        self.add(request, withCompletionHandler: nil)
        
    }
    
}
