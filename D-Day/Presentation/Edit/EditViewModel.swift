//
//  EditViewModel.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import RxCocoa
import RxSwift
import UIKit
import RealmSwift
import NotificationCenter

struct EditViewModel{
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    let saveItem: Signal<Item>
//    let id: Driver<ObjectId?>
    let id = PublishRelay<ObjectId?>()
    
    let saveButtonTapped = PublishRelay<Void>()
    
    let title = PublishRelay<String?>()
    let titleColor = BehaviorRelay<UIColor?>(value: .label)
    let date = PublishRelay<Date?>()
    let isStartCount = BehaviorRelay<Bool?>(value: false)
    let repeatCode = BehaviorRelay<Int?>(value: 0)
    let bgColor = BehaviorRelay<UIColor?>(value: .systemBackground)
    let bgImage = BehaviorRelay<UIImage?>(value: UIImage())//이미지
    let isCircle = BehaviorRelay<Bool?>(value: false)
    let memo = BehaviorRelay<String?>(value: "")
    
    init(){
        let mainItem = Observable<Item>
        //값을 방출할 때마다 해당 클로저를 호출하여 인라인 안에 결합규칙을 적용하여 방출
            .combineLatest(id, title, titleColor, date, isStartCount, repeatCode) {id, title, titleColor, date, isStartCount, repeatCode in
                let item = Item()   //클로저 안에서 초기화 되어야함
                
                item.id = id! as! ObjectId
                item.title = title!
                item.titleColor = titleColor?.rgbString ?? "00000000"
                item.date = date!
                item.isStartCount = isStartCount!
                item.repeatCode = repeatCode!
                
                return item
            }
        
        let viewItem = Observable<Item>
        //값을 방출할 때마다 해당 클로저를 호출하여 인라인 안에 결합규칙을 적용하여 방출
            .combineLatest(mainItem, bgColor, isCircle, memo) {item, bgColor, isCircle, memo in
                item.backgroundColor = bgColor?.rgbString ?? "00000000"
                item.isCircle = isCircle!
                item.memo = memo! == "메모를 입력해주세요." ? "" : memo!
                
                return item
            }
           
//        let saveImage = Observable
//            .combineLatest(id, bgImage){id, bgImage in
//                Repository().saveImageToDocumentDirectory(imageName: id!.stringValue, image: bgImage!)
//            }
//
//        let addNoti = PublishSubject<Item>
//            .subscribe{item in
//                self.userNotificationCenter.addNotificationRequest(by: item)
//            }
        
        self.saveItem = saveButtonTapped
        //탭이벤트가 트리거가 되어,,, 조건이 맞으면 에러메시지 방출
        //첫번째 Observable에서 아이템이 방출될 때마다 그 아이템을 두번째 Observable의 가장 최근 아이템과 결합해 방출
            .withLatestFrom(viewItem)
//            .map({item in
//            })
            .asSignal(onErrorSignalWith: .empty())
        
    }
}
