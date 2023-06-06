//
//  Date+.swift
//  D-Day
//
//  Created by hana on 2023/06/06.
//

import Foundation

extension Date{
    var getMidnightDate: Date? {
        get{
            var component = Calendar.current.dateComponents([.year, .month, .day], from: self)
            component.hour = 0
            component.minute = 0
            component.second = 0
            return Calendar.current.date(from: component)
        }
    }
    
    var toString: String {
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            
            return dateFormatter.string(from: self)
        }
    }
}
