//
//  Util.swift
//  D-Day
//
//  Created by hana on 2023/01/27.
//

import Foundation
import UIKit
import Toast

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
        view.hideAllToasts()
        view.makeToast(message, duration: 0.8, position: .bottom)
    }
}


extension UIColor{
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex >> 16) & 0xff) / 255
        let g = CGFloat((hex >> 08) & 0xff) / 255
        let b = CGFloat((hex >> 00) & 0xff) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(hexCode: String) {
        let hex = hexCode.trimmingCharacters(in: NSCharacterSet.alphanumerics.inverted)// alphanumericCharacterSet().invertedSet)
//        let hex = hexCode.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64

        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
    
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    var rgbString: String {
//        if self == nil
//        {
//            return ""
//        }
        
        switch self.cgColor.components?.count{
        case 2:
            let r = NSString(format: "%02x", Int((self.cgColor.components?.map{$0}[0])! * 255) & 0xFF)
            let a = NSString(format: "%02x", Int((self.cgColor.components?.map{$0}[1])! * 255) & 0xFF)
            return "\(a)\(r)\(r)\(r)"
        default:
            let r = NSString(format: "%02x", Int((self.cgColor.components?.map{$0}[0])! * 255) & 0xFF)
            let g = NSString(format: "%02x", Int((self.cgColor.components?.map{$0}[1])! * 255) & 0xFF)
            let b = NSString(format: "%02x", Int((self.cgColor.components?.map{$0}[2])! * 255) & 0xFF)
            let a = NSString(format: "%02x", Int((self.cgColor.components?.map{$0}[3])! * 255) & 0xFF)
            return "\(a)\(r)\(g)\(b)"
        }
        
    }
    
}
