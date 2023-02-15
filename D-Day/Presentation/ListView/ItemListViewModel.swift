//
//  ItemListViewModel.swift
//  D-Day
//
//  Created by hana on 2023/01/27.
//

import RxSwift
import RxCocoa
import Foundation

struct CollectionViewModel{
    //var data = Observable<Item>
    let itemCellData = PublishSubject<[Item]>()
    let cellData: Driver<[Item]>
    
    init(){
        self.cellData = itemCellData
            .asDriver(onErrorJustReturn: [])
    }
}
