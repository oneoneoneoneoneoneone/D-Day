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
protocol EditCellDelegate{
    func valueChanged(_ cell: EditViewController.CellList, didChangeValue value: Any?)
    func valueChanged(_ cell: EditViewController.CellList, didChangeValue value: UIColor?)
}

protocol EditProtocol{
    func setNavigation()
    func setLayout()
    
    func showCloseAlertController()
    func showToast(message: String)
    func dismiss()
}

final class EditPresenter: NSObject{
    private let viewController: EditProtocol
    private let delegate: EditDelegate
    private let userDefaultsManager: UserDefaultsManager
    private let repository: Repository
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    final let textViewPlaceHolder = "메모를 입력해주세요."
    private final let cellList = EditViewController.CellList.allCases
    
    private let item: Item
    
    private let editItem = Item()
    private var image: UIImage

    init(viewController: EditProtocol, delegate: EditDelegate, userDefaultsManager: UserDefaultsManager = UserDefaultsManager(), repository: Repository = Repository(), item: Item, image: UIImage = UIImage(systemName: "photo")!) {
        self.viewController = viewController
        self.delegate = delegate
        self.userDefaultsManager = userDefaultsManager
        self.repository = repository
        self.item = item
        self.image = image
    }
    
    func viewDidLoad(){
        viewController.setNavigation()
        viewController.setLayout()
    }
    
    func leftCancelButtonTap(){
        viewController.showCloseAlertController()
    }
    
    func rightSaveButtonTap(){
        if editItem.title == "" {
            viewController.showToast(message: "제목을 입력해주세요.")
            return
        }
        if editItem.isBackgroundImage && image == UIImage(systemName: "photo"){
            viewController.showToast(message: "배경이미지를 선택해주세요.")
            return
        }
        
        if image != UIImage(systemName: "photo"){
            repository.saveImageToDocumentDirectory(imageName: item.id.stringValue, image: image)
        }
        
        let saveItem = Item()
        saveItem.id = item.id
        saveItem.title = editItem.title
        saveItem.titleColor = editItem.titleColor
        saveItem.date = editItem.date
        saveItem.isBackgroundColor = editItem.isBackgroundColor
        saveItem.backgroundColor = editItem.backgroundColor
        saveItem.isBackgroundImage = editItem.isBackgroundImage
        saveItem.isCircle = editItem.isCircle
        saveItem.memo = editItem.memo == textViewPlaceHolder ? "" : editItem.memo
        
        //저장
        repository.editItem(saveItem)
        
        //알림시간 불러오기
        let alertTime = userDefaultsManager.getAlertTime()
        
        //알림 추가
        userNotificationCenter.addNotificationRequest(by: item, alertTime: alertTime ?? AlertTime(isOn: true, day: 0, time: Date.now))
        
        viewController.dismiss()
        delegate.selectItem(item.id)
    }
}


extension EditPresenter: EditCellDelegate{
    
    func valueChanged(_ cell: EditViewController.CellList, didChangeValue value: Any?) {
        switch cell{
        case .title:
            if value is String{
                editItem.title = value as! String
            }
        case .date:
            if value is Date{
                editItem.date = value as! Date
            }
        case .backgroundColor:
            if value is Bool{
                editItem.isBackgroundColor = value as! Bool
            }
        case .backgroundImage:
            if value is UIImage{
                image = value as! UIImage
            }
            if value is Bool{
                editItem.isBackgroundImage = value as! Bool
            }
        case .isCircle:
            if value is Bool{
                editItem.isCircle = value as! Bool
            }
        case .memo:
            if value is String{
                editItem.memo = value as! String
            }
        }
    }
    
    func valueChanged(_ cell: EditViewController.CellList, didChangeValue value: UIColor?) {
        switch cell{
        case .title:
            editItem.titleColor = value?.rgbString ?? "FF000000"
        case .backgroundColor:
            editItem.backgroundColor = value?.rgbString ?? "FFFFFFFF"
        default: break
        }
    }
}

extension EditPresenter: UITableViewDelegate{
}

extension EditPresenter: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        cellList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellList.filter{ item in
            item.section.rawValue == section
        }.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row + cellList.filter{ item in
            item.section.rawValue < indexPath.section
        }.count

        if cellList[row] == .date{
            return 240
        }
        else if cellList[row] == .backgroundImage{
            return 120
        }
        else if cellList[row] == .memo{
            return 120
        }
        else{
            return 60
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        				let row = indexPath.row + cellList.filter{ cell in
            cell.section.rawValue < indexPath.section
        }.count

        switch cellList[row] {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewTitleCell", for: indexPath) as! EditTableViewTitleCell
            cell.selectionStyle = .none
            cell.bind(delegate: self, cell: cellList[row])
            cell.setDate(text: item.title, color: item.titleColor)

            return cell
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewDateCell", for: indexPath) as! EditTableViewDateCell
            cell.selectionStyle = .none
            cell.bind(delegate: self, cell: cellList[row])
            cell.setDate(date: item.date)

            return cell
        case .backgroundColor:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewColorCell", for: indexPath) as! EditTableViewColorCell
            cell.selectionStyle = .none
            cell.bind(delegate: self, cell: cellList[row])
            cell.setDate(isOn: item.isBackgroundColor, color: item.backgroundColor)

            return cell
        case .backgroundImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewImageCell", for: indexPath) as! EditTableViewImageCell
            cell.selectionStyle = .none
            cell.bind(delegate: self, cell: cellList[row])
            cell.setDate(isOn: item.isBackgroundImage, id: item.id.stringValue)

            return cell
        case .isCircle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewToggleCell", for: indexPath) as! EditTableViewToggleCell
            cell.selectionStyle = .none
            cell.bind(delegate: self, cell: cellList[row])
            cell.setDate(isOn: item.isCircle)

            return cell
        case .memo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewMenoCell", for: indexPath) as! EditTableViewMemoCell
            cell.selectionStyle = .none
            cell.bind(delegate: self, cell: cellList[row])
            cell.setDate(text: item.memo)

            return cell
        }
    }
}
