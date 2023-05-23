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
    @Persisted var textAttributes = List<TextAttributes>()
    @Persisted var backgroundColor: String = "FFFFFFFF"
    @Persisted var isBackgroundColor: Bool = true
    @Persisted var isBackgroundImage: Bool = false
    @Persisted var isCircle: Bool = false
    
}

//title, dday, date
class TextAttributes: Object{
    @Persisted var centerX: Double = 0.0
    @Persisted var centerY: Double = 0.0
    @Persisted var isHidden: Bool = false
}

enum Repeat: Int, PersistableEnum{
    case none, week, mount, year
}

enum ItemText: Int, PersistableEnum{
    case title, dday, date
}
