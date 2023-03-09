//
//  EditPresenter.swift
//  D-Day
//
//  Created by hana on 2023/03/02.
//

import UIKit
import RealmSwift


//main
protocol EditDelegate{
    func selectItem(_ id: ObjectId)
}

protocol EditProtocol{
    func setAttribute()
    func setNavigation()
    func setLayout()
    func setData(_ item: Item)
    func setImage(_ image: UIImage!)
    
    func showCloseAlertController()
    func showImageSelectAlertController()
    func showToast(message: String)
    func dismiss()
}

final class EditPresenter: NSObject{
    private let viewController: EditProtocol
    private let delegate: EditDelegate
    private let userDefaultsManager: UserDefaultsManager
    private let repository: Repository
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    let textViewPlaceHolder = "메모를 입력해주세요."
    private let cellList = EditViewController2.CellList.allCases
    
    private let item: Item
    
    init(viewController: EditProtocol, delegate: EditDelegate, userDefaultsManager: UserDefaultsManager = UserDefaultsManager(), repository: Repository = Repository(), item: Item) {
        self.viewController = viewController
        self.delegate = delegate
        self.userDefaultsManager = userDefaultsManager
        self.repository = repository
        self.item = item
    }
    
    func viewDidLoad(){
        viewController.setNavigation()
        viewController.setLayout()
        viewController.setAttribute()
        
        viewController.setData(item)
        
        guard let image = Repository().loadImageFromDocumentDirectory(imageName: item.id.stringValue) else {
            viewController.setImage(.init(systemName: "photo"))
            return
        }
        viewController.setImage(image)
    }
    
    func leftCancelButtonTap(){
        viewController.showCloseAlertController()
    }
    
    func rightSaveButtonTap(title: String!, titleColor: UIColor!, date: Date!, isBgColor: Bool!, bgColor: UIColor!, isBgImage: Bool!, bgImage: UIImage!, isCircle: Bool!, memo: String!){
        
        guard let title = title, title != "" else {
            viewController.showToast(message: "제목을 입력해주세요.")
            return
        }
        
        //        if isBgColor && bgColor == nil{
        //            viewController.showToast(message: "배경색을 선택해주세요.")
        //            return
        //        }
        if isBgImage && bgImage == .init(systemName: "photo"){
            viewController.showToast(message: "배경이미지를 선택해주세요.")
            return
        }
        if bgImage != .init(systemName: "photo"){
            repository.saveImageToDocumentDirectory(imageName: item.id.stringValue, image: bgImage)
        }
        
        let saveItem = Item()
        saveItem.id = item.id
        saveItem.title = title
        saveItem.titleColor = titleColor?.rgbString ?? "FF000000"
        saveItem.date = date
        saveItem.isBackgroundColor = isBgColor
        saveItem.backgroundColor = bgColor?.rgbString ?? "FFFFFFFF"
        saveItem.isBackgroundImage = isBgImage
        saveItem.isCircle = isCircle
        saveItem.memo = memo == textViewPlaceHolder ? "" : memo
        
        //저장
        repository.editItem(saveItem)
        
        //알림시간 불러오기
        let alertTime = userDefaultsManager.getAlertTime()
        
        //알림 추가
        userNotificationCenter.addNotificationRequest(by: item, alertTime: alertTime ?? AlertTime(isOn: true, day: 0, time: Date.now))
        
        viewController.dismiss()
        delegate.selectItem(item.id)
    }
    
    func bgImageButtonTap(){
        viewController.showImageSelectAlertController()
    }
    
//    func isSwitchChangedValue(){
//        viewController.
//    }
}

//extension EditPresenter: DetailDelegate{
//    func setData(item: Item){
//        self.item = item
//    }
//}

//
//extension EditPresenter: UITableViewDelegate{
//}
//
//extension EditPresenter: UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        cellList.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        cellList.filter{ item in
//            item.section.rawValue == section
//        }.count
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let row = indexPath.row + cellList.filter{ item in
//            item.section.rawValue < indexPath.section
//        }.count
//
//        if cellList[row] == .date{
//            return 240
//        }
//        else if cellList[row] == .backgroundImage{
//            return 120
//        }
//        else if cellList[row] == .memo{
//            return 120
//        }
//        else{
//            return 60
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let row = indexPath.row + cellList.filter{ cell in
//            cell.section.rawValue < indexPath.section
//        }.count
//
//        switch cellList[row] {
//        case .title:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewTitleCell", for: indexPath) as! EditTableViewTitleCell
//            cell.selectionStyle = .none
//            cell.setPlaceholderText(text: cellList[row].text)
//            cell.bind(viewModel.title, viewModel.titleColor)
//            cell.setDate(text: item.title, color: item.titleColor)
//
//            return cell
//        case .date:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewDateCell", for: indexPath) as! EditTableViewDateCell
//            cell.selectionStyle = .none
//            cell.setLabelText(text: cellList[row].text)
//            cell.bind(viewModel.date)
//            cell.setDate(date: item.date)
//
//            return cell
////        case .isStartCount:
////            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewToggleCell", for: indexPath) as! EditTableViewToggleCell
////            cell.selectionStyle = .none
////            cell.setLabelText(text: cellList[row].text)
////            cell.bind(viewModel.isStartCount)
////            cell.setDate(isOn: item.isStartCount)
////
////            return cell
////        case .repeatCode:
////            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewSegmentCell", for: indexPath) as! EditTableViewSegmentCell
////            cell.selectionStyle = .none
////            cell.setLabelText(text: cellList[row].text)
////            cell.bind(viewModel.repeatCode)
////            cell.setDate(value: item.repeatCode)
////
////            return cell
//        case .backgroundColor:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewColorCell", for: indexPath) as! EditTableViewColorCell
//            cell.selectionStyle = .none
//            cell.setLabelText(text: cellList[row].text)
//            cell.bind(viewModel.isBgColor, viewModel.bgColor)
//            cell.setDate(isOn: item.isBackgroundColor, color: item.backgroundColor)
//
//            return cell
//        case .backgroundImage:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewImageCell", for: indexPath) as! EditTableViewImageCell
//            cell.selectionStyle = .none
//            cell.setLabelText(text: cellList[row].text)
//            cell.bind(viewModel.isBgImage)
//            cell.setDate(isOn: item.isBackgroundImage, id: item.id.stringValue)
//
//            return cell
//        case .isCircle:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewToggleCell", for: indexPath) as! EditTableViewToggleCell
//            cell.selectionStyle = .none
//            cell.setLabelText(text: cellList[row].text)
//            delegate.bind(item.isCircle)
//            delegate.setDate(item.isCircle)
//
//            return cell
//        case .memo:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewMenoCell", for: indexPath) as! EditTableViewMemoCell
//            cell.selectionStyle = .none
////            cell.setPlaceholderText(text: cellList[row].text)
//            cell.bind(viewModel.memo)
//            cell.setDate(text: item.memo)
//
//            return cell
//        }
//    }
//}
