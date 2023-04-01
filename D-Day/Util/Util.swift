//
//  Util.swift
//  D-Day
//
//  Created by hana on 2023/01/27.
//

import Foundation
import UIKit

struct Util{    
    static func stringFromDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        return dateFormatter.string(from: date)
    }
    
    static func numberOfDaysFromDate(from: Date, to: Date = Date.now) -> String{
        let calendar = NSCalendar.current
        let numberOfDays = calendar.dateComponents([.day], from: from, to: to)
        
        if numberOfDays.day! > 0{
            return "D+\(numberOfDays.day!)"
        }
        else if numberOfDays.day! < 0{
            return "D\(numberOfDays.day!)"
        }
        else{
            return "D-Day"
        }
    }
}
