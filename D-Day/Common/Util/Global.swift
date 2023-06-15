//
//  Foundation+.swift
//  D-Day
//
//  Created by hana on 2023/06/14.
//

import Foundation


public func NSLog(_ format: String, _ args: CVarArg...){
    #if DEBUG
    Foundation.NSLog(String(format: format, arguments: args))
    #endif
}

