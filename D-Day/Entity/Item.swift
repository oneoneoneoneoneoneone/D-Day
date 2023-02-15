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
    @Persisted(primaryKey: true) var id: ObjectId//String = UUID().uuidString
    @Persisted var title: String //= ""
    @Persisted var titleColor: String = "FF000000"//0xff000000
    @Persisted var memo: String = ""
    @Persisted var date: Date = Date.now
    @Persisted var isStartCount: Bool = false
    @Persisted var repeatCode: Repeat.RawValue //= .none
    @Persisted var backgroundColor: String //= "FFFFFFFF"//0xff000000
    @Persisted var isCircle: Bool = false

    @Persisted var isBackgroundColor: Bool = true
    @Persisted var isBackgroundImage: Bool = false
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
}

enum Repeat: Int, PersistableEnum{
    case none, week, mount, year
}

class WidgetItem: Object{
    @Persisted var id: String = ""
    @Persisted var title: String = ""
    @Persisted var dDay: String = ""
//    @Persisted var Image: UIImage = UIImage()
}
