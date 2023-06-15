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
    func valueChanged(_ editCell: EditCell?, didChangeValue value: Any?)
}

protocol EditProtocol{
    func setNavigation()
    func setLayout()
    
    func showCloseAlertController()
    func showToast(message: String)
    func dismiss()
    func getTableViewCell(_ editCell: EditCell?) -> UITableViewCell?
}

final class EditPresenter: NSObject{
    private let viewController: EditProtocol
    private let delegate: EditDelegate
    private let userDefaultsManager: UserDefaultsManager
    private let repository: Repository
    private let notificationCenter = NotificationCenterManager()
    
    private let item: Item
    private let editItem = Item(id: "")
    private var image: UIImage?
    
    final let textViewPlaceHolder = EditCell.memo.subText.first
    private final let cellList = EditCell.allCases

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
    }
    
    func leftCancelButtonTap(){
        viewController.showCloseAlertController()
    }
    
    func rightSaveButtonTap(){
        if editItem.title == "" {
            viewController.showToast(message: EditCell.title.text)
            return
        }
        
        if editItem.background?.isImage == true{
            guard let image = image else {
                viewController.showToast(message: EditCell.backgroundImage.subText.first!)
                return
            }
            repository.saveImageToFileManager(imageName: item.id.stringValue, image: image)
        }
        
        let saveItem = Item()
        saveItem.id = item.id
        saveItem.title = editItem.title
        saveItem.date = editItem.date.getMidnightDate ?? editItem.date
        saveItem.isStartCount = editItem.isStartCount
        saveItem.textAttributes = editItem.textAttributes
        saveItem.background = editItem.background
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
    func valueChanged(_ editCell: EditCell?, didChangeValue value: Any?) {
        guard let editCell = editCell else { return }
        let textAttributeCell = viewController.getTableViewCell(EditCell.textAttribute) as? EditTableViewPresentButtonCell
        
        switch editCell{
        case .title:
            if value is String{
                let value = value as? String ?? ""
                editItem.title = value
                                
                textAttributeCell?.setData(title: value)
            }
        case .date:
            if value is Date{
                let value = value as? Date ?? Date()
                editItem.date = value
                
                textAttributeCell?.setData(date: value)
            }
        case .isStartCount:
            if value is Bool{
                let value = value as? Bool ?? false
                editItem.isStartCount = value
                
                textAttributeCell?.setData(isStartCount: value)
            }
        case .backgroundColor:
            if value is Bool{
                let value = value as? Bool ?? Background().isColor
                editItem.background?.isColor = value
                
                if editItem.background?.isColor != editItem.background?.isImage{
                    return
                }
                let toggleCell = viewController.getTableViewCell(EditCell.backgroundImage) as? EditTableViewImageCell
                toggleCell?.setToggle()
                editItem.background?.isImage = value == false
                                
                textAttributeCell?.setData(backgroundIsColor: value)
                textAttributeCell?.setData(backgroundIsImage: value == false)
            }
            if value is String{
                let value = value as? String ?? Background().color
                editItem.background?.color = value
                
                textAttributeCell?.setData(backgroundColor: value)
            }
        case .backgroundImage:
            if value is UIImage{
                let value = value as? UIImage ?? UIImage()
                image = value
                
                textAttributeCell?.setData(image: image)
            }
            if value is Bool{
                let value = value as? Bool ?? Background().isImage
                editItem.background?.isImage = value
                
                if editItem.background?.isColor != editItem.background?.isImage{
                    return
                }
                let toggleCell = viewController.getTableViewCell(EditCell.backgroundColor) as? EditTableViewColorCell
                toggleCell?.setToggle()
                editItem.background?.isColor = value == false
                
                textAttributeCell?.setData(backgroundIsImage: value)
                textAttributeCell?.setData(backgroundIsColor: value == false)
            }
        case .isCircle:
            if value is Bool{
                let value = value as? Bool ?? Background().isCircle
                editItem.background?.isCircle = value
                
                textAttributeCell?.setData(backgroundIsCircle: value)
            }
        case .textAttribute:
            if value is [TextAttributes]{
                var value = value as? [TextAttributes] ?? []
                if value.isEmpty {
                    TextType.allCases.forEach{
                        value.append($0.defualtValue)
                    }
                }
                
                let list = List<TextAttributes>()
                list.append(objectsIn: value)
                editItem.textAttributes = list
            }
        case .memo:
            if value is String{
                let value = value as? String ?? Item().memo
                editItem.memo = value
            }
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
        let row = indexPath.row + cellList.filter{
            $0.section.rawValue < indexPath.section
        }.count

        switch cellList[row] {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewTitleCell", for: indexPath) as? EditTableViewTitleCell
            cell?.selectionStyle = .none
            cell?.bind(delegate: self, cell: cellList[row])
            cell?.setData(title: item.title)

            return cell ?? UITableViewCell()
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewDateCell", for: indexPath) as? EditTableViewDateCell
            cell?.selectionStyle = .none
            cell?.bind(delegate: self, cell: cellList[row])
            cell?.setData(date: item.date)

            return cell ?? UITableViewCell()
        case .isStartCount:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewToggleCell", for: indexPath) as? EditTableViewToggleCell
            cell?.selectionStyle = .none
            cell?.bind(delegate: self, cell: cellList[row])
            cell?.setData(isOn: item.isStartCount)

            return cell ?? UITableViewCell()
        case .backgroundColor:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewColorCell", for: indexPath) as? EditTableViewColorCell
            cell?.selectionStyle = .none
            cell?.bind(delegate: self, cell: cellList[row])
            cell?.setData(backgroundIsColor: item.background?.isColor)
            cell?.setData(backgroundColor: item.background?.color)

            return cell ?? UITableViewCell()
        case .backgroundImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewImageCell", for: indexPath) as? EditTableViewImageCell
            cell?.selectionStyle = .none
            cell?.bind(delegate: self, cell: cellList[row])
            cell?.setData(id: item.id.stringValue)
            cell?.setData(backgroundIsImage: item.background?.isImage)

            return cell ?? UITableViewCell()
        case .isCircle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewToggleCell", for: indexPath) as? EditTableViewToggleCell
            cell?.selectionStyle = .none
            cell?.bind(delegate: self, cell: cellList[row])
            cell?.setData(isOn: item.background?.isCircle)

            return cell ?? UITableViewCell()
        case .textAttribute:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewPresentButtonCell", for: indexPath) as? EditTableViewPresentButtonCell
            cell?.selectionStyle = .none
            cell?.bind(delegate: self, cell: cellList[row])
            cell?.setData(image: image)
            cell?.setData(title: item.title)
            cell?.setData(date: item.date)
            cell?.setData(isStartCount: item.isStartCount)
            cell?.setData(textAttributes: item.textAttributes)
            cell?.setData(background: item.background)

            return cell ?? UITableViewCell()
        case .memo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewMemoCell", for: indexPath) as? EditTableViewMemoCell
            cell?.selectionStyle = .none
            cell?.bind(delegate: self, cell: cellList[row])
            cell?.setData(memo: item.memo)

            return cell ?? UITableViewCell()
        }
    }
}
