//
//  Util.swift
//  D-Day
//
//  Created by hana on 2023/01/27.
//

import Foundation
import UIKit

struct Util{
    static func getAlertTime() -> AlertTime!{
        guard let savedData = UserDefaults.standard.object(forKey: "alertTime") as? Foundation.Data else {return nil}

        do{
            return try JSONDecoder().decode(AlertTime.self, from: savedData)
        }
        catch{
            print("UserData decode Error - \(error.localizedDescription)")
            return nil
        }
    }
    
    static func setAlertTime(data: AlertTime!){
        do{
            let encoded = try JSONEncoder().encode(data)
            UserDefaults.standard.setValue(encoded, forKey: "alertTime")
        }
        catch{
            print("UserData encode Error - \(error.localizedDescription)")
        }
    }
    
    static func StringFromDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        return dateFormatter.string(from: date)
    }
    
    static func NumberOfDaysFromDate(from: Date, to: Date = Date.now) -> String{
        let calendar = NSCalendar.current
        let numberOfDays = calendar.dateComponents([.day], from: from, to: to)
        
        if numberOfDays.day! > 0{
            return "+\(numberOfDays.day!)"
        }
        else if numberOfDays.day! < 0{
            return "\(numberOfDays.day!)"
        }
        else{
            return "-Day"
        }
    }
    
    static func showToast(view: UIView, message: String){
        //남아있는 토스트뷰 지우기
        ToastView().removeToast(view: view)
        ToastView().showToast(view: view, message: message)
    }
}
