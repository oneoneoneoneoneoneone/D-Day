//
//  MainViewModel.swift
//  D-Day
//
//  Created by hana on 2023/01/27.
//

import RxSwift
import RxCocoa

struct MainViewModel{
    let disposeBag = DisposeBag()
    let AlertActionStyle = [MainViewController.AlertAction.title, MainViewController.AlertAction.dateDesc, MainViewController.AlertAction.dateAsc]
    
    let itemListViewModel = CollectionViewModel()
    
    let alertAction = PublishSubject<MainViewController.AlertAction>()
    
    let sortButtonTap = PublishRelay<Void>()
    //메인에서 알럿 셋팅할 스트림을 정의
    let shouldPresentAlert: Signal<Void>
    
//    let data: Driver<[Item]>
    
    init(model: MainModel = MainModel()){
        let cellData = BehaviorRelay<[Item]>(value: model.getValue())
            .debug("cellData")
                        
//        alertAction = BehaviorSubject<MainViewController.AlertAction>(value: sortButtonTap.map{_ in false})
        
        let sortedType = alertAction
            .debug("sortedType")
            .filter{
                switch $0 {
                case .title, .dateAsc, .dateDesc:
                    return true
                }
            }
            .startWith(.title)  //초기값
        
        Observable
            .combineLatest(
                sortedType,
                cellData,
                resultSelector: model.sort
            )
            .bind(to: itemListViewModel.itemCellData)
            .disposed(by: disposeBag)
        
        
        shouldPresentAlert = sortButtonTap
//            .map{ _ -> MainViewController.Alert in
//                return (title: nil, message: nil, actions: [.title, .dateDesc, .dateAsc, .cancel], style: .actionSheet)
//            }
            .asSignal(onErrorSignalWith: .empty())
    }
}
