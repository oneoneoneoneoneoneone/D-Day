//
//  UIColor.swift
//  D-Day
//
//  Created by hana on 2023/03/09.
//

import UIKit

extension UIColor{
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xff) / 255
        let green = CGFloat((hex >> 08) & 0xff) / 255
        let blue = CGFloat((hex >> 00) & 0xff) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     - Warning: 사용 안함
     */
    convenience init(hexCode: String) {
        let hex = hexCode.trimmingCharacters(in: NSCharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64

        switch hex.count {
        case 3:
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (1, 1, 1, 0)
        }
    
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }
    
    var rgbString: String {
        switch self.cgColor.components?.count{
        case 3:
            let red = NSString(format: "%02x", Int((self.cgColor.components?.map{$0}[0])! * 255) & 0xFF)
            let green = NSString(format: "%02x", Int((self.cgColor.components?.map{$0}[1])! * 255) & 0xFF)
            let blue = NSString(format: "%02x", Int((self.cgColor.components?.map{$0}[2])! * 255) & 0xFF)
            return "\(255)\(red)\(green)\(blue)"
        default:
            let red = NSString(format: "%02x", Int((self.cgColor.components?.map{$0}[0])! * 255) & 0xFF)
            let green = NSString(format: "%02x", Int((self.cgColor.components?.map{$0}[1])! * 255) & 0xFF)
            let blue = NSString(format: "%02x", Int((self.cgColor.components?.map{$0}[2])! * 255) & 0xFF)
            let alpha = NSString(format: "%02x", Int((self.cgColor.components?.map{$0}[3])! * 255) & 0xFF)
            return "\(alpha)\(red)\(green)\(blue)"
        }
        
    }
    
}
