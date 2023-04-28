//
//  Item.swift
//  D-Day
//
//  Created by hana on 2023/01/26.
//

import Foundation
import UIKit
import RealmSwift

class Item: Object{
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var titleColor: String = "FF000000"
    @Persisted var memo: String = ""
    @Persisted var date: Date = Date.now
    @Persisted var isStartCount: Bool = false
//    @Persisted var repeatCode: Repeat.RawValue
    @Persisted var backgroundColor: String = "FFFFFFFF"
    @Persisted var isBackgroundColor: Bool = true
    @Persisted var isBackgroundImage: Bool = false
    @Persisted var isCircle: Bool = false
}

enum Repeat: Int, PersistableEnum{
    case none, week, mount, year
}
