//
//  MainModel.swift
//  D-Day
//
//  Created by hana on 2023/01/27.
//

import RxSwift
import UIKit

struct MainModel{
    
    func getValue() ->[Item]{
        //guard let items = UserDefaults.standard.object(forKey: "data") as? [Item] else {return []}
        
        let items = [Item(title: "B"), Item(title: "A")]
        
        return items
    }
    
    func sort(by type: MainViewController.AlertAction, of data: [Item]) -> [Item]{
        switch type{
        case .title:
            return data.sorted { $0.title < $1.title }
        case .dateAsc:
            return data.sorted { $0.date > $1.date }
        case .dateDesc:
            return data.sorted { $0.date < $1.date }
        }
    }
}
