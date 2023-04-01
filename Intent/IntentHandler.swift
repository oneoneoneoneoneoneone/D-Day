//
//  IntentHandler.swift
//  Intent
//
//  Created by hana on 2023/03/30.
//

import Intents
import RealmSwift

class IntentHandler: INExtension, WidgetIntentHandling {
    func provideSelectedWidgetOptionsCollection(for intent: WidgetIntent, with completion: @escaping (INObjectCollection<SelectedWidget>?, Error?) -> Void) {
        // ✅ intent defintion file 에서 만든 custom type 인 Card 를 사용.
        let myDatas: [SelectedWidget] = getItem().map{ data in

            // ✅ 구분자가 되는 identifier 로 card.cardName 프로퍼티 사용.
            let myData = SelectedWidget(identifier: data.id.stringValue, display: data.title)

            // ✅ 위의 convenience initializer 말고도 새로 추가한 attribute 에 대해서 초기화.
            myData.name = data.title
            return myData

        }

        // ✅ completion handler 로 넘겨줄 INObjectCollection 생성.
        let collection = INObjectCollection(items: myDatas)

        completion(collection, nil)

    }
}

func getItem() -> [Item]{
    let items = Repository().readItem()!

    return Array(items)
}
