//
//  UIView+.swift
//  D-Day
//
//  Created by hana on 2023/05/01.
//

import UIKit

extension UIView{
   open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.endEditing(true)
    }
}
