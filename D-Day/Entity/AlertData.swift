//
//  AlertData.swift
//  D-Day
//
//  Created by hana on 2023/03/09.
//

import Foundation

struct AlertData: Codable{
    var isOn: Bool = true
//    let day: Int
    var time: Date = Calendar.current.date(bySettingHour: 8, minute: 00, second: 0, of: Date())!
}
