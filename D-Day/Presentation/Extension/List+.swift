//
//  List+.swift
//  D-Day
//
//  Created by hana on 2023/05/26.
//

import RealmSwift

extension List{
    subscript (safe index: Int) -> Element?{
        return indices ~= index ? self[index] : nil
    }
}
