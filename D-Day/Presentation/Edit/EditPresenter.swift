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
    func selectItem(_ id: String)
}
protocol EditCellDelegate{
    func valueChanged(_ cell: EditCellList, didChangeValue value: Any?)
    func valueChanged(_ cell: EditCellList, didChangeValue value: UIColor?)
}

protocol EditProtocol{
    func setNavigation()
    func setLayout()
    
    func setBgToggle(_ cell: EditCellList)
    func showCloseAlertController()
    func showToast(message: String)
    func dismiss()
}

final class EditPresenter: NSObject{
    private let viewController: EditProtocol
    private let delegate: EditDelegate
    private let userDefaultsManager: UserDefaultsManager
    private let repository: Repository
    private let notificationCenter = NotificationCenterManager()
    
    final let textViewPlaceHolder = EditCellList.memo.subText.first
    private final let cellList = EditCellList.allCases
    
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
            viewController.showToast(message: EditCellList.title.text)
            return
        }
        if editItem.isBackgroundImage && image == UIImage(systemName: "photo"){
            viewController.showToast(message: EditCellList.backgroundImage.subText.first!)
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
        saveItem.isStartCount = editItem.isStartCount
        saveItem.isBackgroundColor = editItem.isBackgroundColor
        saveItem.backgroundColor = editItem.backgroundColor
        saveItem.isBackgroundImage = editItem.isBackgroundImage
        saveItem.isCircle = editItem.isCircle
        saveItem.memo = editItem.memo == textViewPlaceHolder ? "" : editItem.memo
        
        //저장
        repository.editItem(saveItem)
        
        //알림추가
        let alertData = userDefaultsManager.getAlertTime()
        notificationCenter.addNotificationRequest(by: item, alertData: alertData)
        
        //기본 위젯
        if repository.getDefaultWidget() == nil {
            repository.setDefaultWidget(id: item.id.stringValue)
        }
        
        //위젯 새로고침
        Util.widgetReload()
        
        viewController.dismiss()
        delegate.selectItem(item.id.stringValue)
    }
}


extension EditPresenter: EditCellDelegate{
    
    func valueChanged(_ cell: EditCellList, didChangeValue value: Any?) {
        switch cell{
        case .title:
            if value is String{
                editItem.title = value as! String
            }
        case .date:
            if value is Date{
                editItem.date = value as! Date
            }
        case .isStartCount:
            if value is Bool{
                editItem.isStartCount = value as! Bool
            }
        case .backgroundColor:
            if value is Bool{
                editItem.isBackgroundColor = value as! Bool
                viewController.setBgToggle(cell)
                editItem.isBackgroundImage = !(value as! Bool)
            }
        case .backgroundImage:
            if value is UIImage{
                image = value as! UIImage
            }
            if value is Bool{
                editItem.isBackgroundImage = value as! Bool
                viewController.setBgToggle(cell)
                editItem.isBackgroundColor = !(value as! Bool)
            }
        case .isCircle:
            if value is Bool{
                editItem.isCircle = value as! Bool
            }
        case .textAttribute:
            if value is List<TextAttributes>{
                editItem.textAttributes = value as! List<TextAttributes>
            }
        case .memo:
            if value is String{
                editItem.memo = value as! String
            }
        }
    }
    
    func valueChanged(_ cell: EditCellList, didChangeValue value: UIColor?) {
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
        case .isStartCount:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewToggleCell", for: indexPath) as! EditTableViewToggleCell
            cell.selectionStyle = .none
            cell.bind(delegate: self, cell: cellList[row])
            cell.setDate(value: item.isStartCount)

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
            cell.setDate(value: item.isCircle)

            return cell
        case .textAttribute:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewPresentButtonCell", for: indexPath) as! EditTableViewPresentButtonCell
            cell.selectionStyle = .none
            cell.bind(delegate: self, cell: cellList[row])
            cell.setData(textAttributes: item.textAttributes, id: item.id.stringValue)

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
