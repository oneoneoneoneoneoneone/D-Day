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
    func valueChanged(_ cell: EditCellList?, didChangeValue value: Any?)
    func valueChanged(_ cell: EditCellList?, didChangeValue value: UIColor?)
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
    
    private let item: Item
    private let editItem = Item(id: "")
    private var image: UIImage?
    
    final let textViewPlaceHolder = EditCellList.memo.subText.first
    private final let cellList = EditCellList.allCases

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
        if editItem.title?.text == "" {
            viewController.showToast(message: EditCellList.title.text)
            return
        }
        
        if editItem.background?.isImage == true{
            guard let image = image else {
                viewController.showToast(message: EditCellList.backgroundImage.subText.first!)
                return
            }
            repository.saveImageToDocumentDirectory(imageName: item.id.stringValue, image: image)
        }
        
        let saveItem = Item()
        saveItem.id = item.id
        saveItem.title = editItem.title
        saveItem.dday = editItem.dday
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
    
    func valueChanged(_ cell: EditCellList?, didChangeValue value: Any?) {
        guard let cell = cell else { return }
        
        switch cell{
        case .title:
            if value is String{
                editItem.title?.text = value as? String ?? Title().text
            }
        case .date:
            if value is Date{
                editItem.dday?.date = value as? Date ??  DDay().date
            }
        case .isStartCount:
            if value is Bool{
                editItem.dday?.isStartCount = value as? Bool ?? DDay().isStartCount
            }
        case .backgroundColor:
            if value is Bool{
                editItem.background?.isColor = value as? Bool ?? Background().isColor
                if editItem.background?.isColor == editItem.background?.isImage{
                    viewController.setBgToggle(cell)
                }
                editItem.background?.isImage = (value as? Bool ?? Background().isImage) == false
            }
        case .backgroundImage:
            if value is UIImage{
                image = value as? UIImage ?? UIImage()
            }
            if value is Bool{
                editItem.background?.isImage = value as? Bool ?? Background().isImage
                if editItem.background?.isColor == editItem.background?.isImage{
                    viewController.setBgToggle(cell)
                }
                editItem.background?.isColor = (value as? Bool ?? Background().isColor) == false
            }
        case .isCircle:
            if value is Bool{
                editItem.background?.isCircle = value as? Bool ?? Background().isCircle
            }
        case .textAttribute:
            if value is TextAttributes{
                editItem.title?.textAttributes = value as? TextAttributes
            }
            if value is List<TextAttributes>{
                editItem.dday?.textAttributes = value as? List<TextAttributes> ?? List()
            }
        case .memo:
            if value is String{
                editItem.memo = value as? String ?? Item().memo
            }
        }
    }
    
    func valueChanged(_ cell: EditCellList?, didChangeValue value: UIColor?) {
        guard let cell = cell else { return }
        
        switch cell{
        case .title:
            editItem.title?.color = value?.rgbString ?? Title().color
        case .backgroundColor:
            editItem.background?.color = value?.rgbString ?? "FFFFFFFF"
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewTitleCell", for: indexPath) as? EditTableViewTitleCell
            cell?.selectionStyle = .none
            cell?.bind(delegate: self, cell: cellList[row])
            cell?.setData(text: item.title?.text, color: item.title?.color)

            return cell ?? UITableViewCell()
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewDateCell", for: indexPath) as? EditTableViewDateCell
            cell?.selectionStyle = .none
            cell?.bind(delegate: self, cell: cellList[row])
            cell?.setData(date: item.dday?.date)

            return cell ?? UITableViewCell()
        case .isStartCount:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewToggleCell", for: indexPath) as? EditTableViewToggleCell
            cell?.selectionStyle = .none
            cell?.bind(delegate: self, cell: cellList[row])
            cell?.setData(isOn: item.dday?.isStartCount)

            return cell ?? UITableViewCell()
        case .backgroundColor:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewColorCell", for: indexPath) as? EditTableViewColorCell
            cell?.selectionStyle = .none
            cell?.bind(delegate: self, cell: cellList[row])
            cell?.setData(isOn: item.background?.isColor, color: item.background?.color)

            return cell ?? UITableViewCell()
        case .backgroundImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewImageCell", for: indexPath) as? EditTableViewImageCell
            cell?.selectionStyle = .none
            cell?.bind(delegate: self, cell: cellList[row])
            cell?.setData(isOn: item.background?.isImage, id: item.id.stringValue)

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
            cell?.setData(id: item.id.stringValue, title: item.title, dday: item.dday, background: item.background)

            return cell ?? UITableViewCell()
        case .memo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewMenoCell", for: indexPath) as? EditTableViewMemoCell
            cell?.selectionStyle = .none
            cell?.bind(delegate: self, cell: cellList[row])
            cell?.setData(text: item.memo)

            return cell ?? UITableViewCell()
        }
    }
}
