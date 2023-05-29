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
    @Persisted var title: Title?
    @Persisted var dday: DDay?
    @Persisted var background: Background?
    @Persisted var memo: String = ""
    
    convenience init(id: String, title: Title? = Title(), dday: DDay? = DDay(), background: Background? = Background(), memo: String = "") {
        self.init()
        
        self.title = title
        self.dday = dday
        self.background = background
        self.memo = memo
    }
}

class Title: Object{
    @Persisted var text: String
    @Persisted var color: String = "FF000000"
    @Persisted var textAttributes: TextAttributes?
}

//dday, date
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
    @Persisted var centerX: Float = 0.0
    @Persisted var centerY: Float = 0.0
    @Persisted var isHidden: Bool = false
}

enum Repeat: Int, PersistableEnum{
    case none, week, mount, year
}

enum DDayText: Int, PersistableEnum{
    case dday, date
}
