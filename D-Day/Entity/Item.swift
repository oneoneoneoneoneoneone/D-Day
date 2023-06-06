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
//    @Persisted var title: Title?
    @Persisted var title: String
//    @Persisted var dday: DDay?
    @Persisted var date: Date = Date.now
    @Persisted var isStartCount: Bool = false
    @Persisted var textAttributes: List<TextAttributes> = List<TextAttributes>()
    @Persisted var background: Background?
    @Persisted var memo: String = ""
    
    convenience init(id: String, title: String = "", date: Date = Date(), isStartCount: Bool = false, textAttributes: List<TextAttributes> = List<TextAttributes>(), background: Background? = Background(), memo: String = "") {
        self.init()
        
        self.title = title
        self.date = date
        self.isStartCount = isStartCount
        self.textAttributes = textAttributes
        self.background = background
        self.memo = memo
    }
}

class Title: Object{
    @Persisted var text: String
    @Persisted var color: String = "FF000000"
    @Persisted var textAttributes: TextAttributes?
}

class DDay: Object{
    @Persisted var date: Date = Date.now
    @Persisted var isStartCount: Bool = false
    @Persisted var textAttributes = List<TextAttributes>()
}

class Background: Object{
    @Persisted var color: String = "FFFFFFFF"
    @Persisted var isColor: Bool = true
    @Persisted var isImage: Bool = false
    @Persisted var isCircle: Bool = false
}

class TextAttributes: Object{
    @Persisted var isHidden: Bool = false
    @Persisted var centerX: Float = 1.0
    @Persisted var centerY: Float = 1.0
    @Persisted var color: String = "FF000000"
    
    convenience init(isHidden: Bool = false, centerX: Float = 1.0, centerY: Float, color: String = "FF000000") {
        self.init()
        
        self.isHidden = isHidden
        self.centerX = centerX
        self.centerY = centerY
        self.color = color
    }
}

enum Repeat: Int, PersistableEnum{
    case none, week, mount, year
}
