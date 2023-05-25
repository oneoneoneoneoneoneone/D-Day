//
//  Array+.swift
//  D-Day
//
//  Created by hana on 2023/05/26.
//

import Foundation

extension Array{
    subscript (safe index: Int) -> Element?{
        return indices ~= index ? self[index] : nil
    }
}

