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
        let myDatas: [SelectedWidget] = getItem().map{ data in

            let myData = SelectedWidget(identifier: data.id.stringValue, display: data.title)

            myData.name = data.title
            return myData

        }

        let collection = INObjectCollection(items: myDatas)
 
        completion(collection, nil)

    }
}

func getItem() -> [Item]{
    let items = Repository().readItem()!

    return Array(items)
}
