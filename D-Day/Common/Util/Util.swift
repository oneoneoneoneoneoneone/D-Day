//
//  Util.swift
//  D-Day
//
//  Created by hana on 2023/01/27.
//

import Foundation
import UIKit
import WidgetKit

struct Util{
    static func numberOfDaysFromDate(isStartCount: Bool, from: Date, to: Date? = Date.now.getMidnightDate) -> String{
        guard var numberOfDays = numberOfDaysFromDate(from: from, to: to) else {return "" }
        if isStartCount{
            numberOfDays += 1
        }
        
        if numberOfDays > 0{
            return "D+\(numberOfDays)"
        }
        else if numberOfDays < 0{
            return "D\(numberOfDays)"
        }
        else{
            return "D-Day"
        }
    }
    
    static func numberOfDaysFromDate(from: Date, to: Date?) -> Int?{
        let calendar = NSCalendar.current
        let numberOfDays = calendar.dateComponents([.day], from: from, to: to ?? Date.now)
        
        return numberOfDays.day
    }
    
    static func widgetReload(){
        WidgetCenter.shared.reloadAllTimelines()
    }
}
