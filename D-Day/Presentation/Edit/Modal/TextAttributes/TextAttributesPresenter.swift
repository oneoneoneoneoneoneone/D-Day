//
//  TextAttributesPresenter.swift
//  D-Day
//
//  Created by hana on 2023/05/25.
//

import UIKit

protocol TextAttributesDelegate{
    func textAttributesValueChanged(textAttributes: [TextAttributes])
}
protocol DetailViewDelegate{
    func valueChanged(_ cell: TextType?, didChangeValue: Any?)
    func reset()
}

protocol TextAttributesProtocol{
    func setNavigation()
    func setLayout()
    func setData(textAttributes: [TextAttributes])
    func setIsHidden(_ cell: TextType?, value: Bool)
    func setTextColor(_ cell: TextType?, value: String)
    func resetPosition()
    
    func getTableViewEditCell() -> [UITableViewCell]
    func getTitleTextAttributes() -> TextAttributes
    func getDDayTextAttributes() -> TextAttributes
    func getDateTextAttributes() -> TextAttributes
    func dismiss()
}


final class TextAttributesPresenter: NSObject{
    private let viewController: TextAttributesProtocol
    private let delegate: TextAttributesDelegate
    private let repository: Repository
    
    var textAttributes: [TextAttributes]
    
    private final let sectionList = TextTypeSection.allCases
    private final let cellList = TextType.allCases
    
    init(viewController: TextAttributesProtocol, delegate: TextAttributesDelegate, repository: Repository = Repository(), textAttributes: [TextAttributes]){
        self.viewController = viewController
        self.delegate = delegate
        self.repository = repository
        self.textAttributes = textAttributes
        
        if textAttributes.count == 0{
            self.textAttributes.append(viewController.getTitleTextAttributes())
            self.textAttributes.append(viewController.getDDayTextAttributes())
            self.textAttributes.append(viewController.getDateTextAttributes())
        }
    }
    
    func viewDidLoad(){
        viewController.setNavigation()
        viewController.setLayout()
    }
    
    func viewWillAppear(){        
        viewController.setData(textAttributes: textAttributes)
    }
    
    func leftCencelButtonTap(){
        viewController.dismiss()
    }
    
    func rightEditButtonTap(){
        let title = viewController.getTitleTextAttributes()
        let dday = viewController.getDDayTextAttributes()
        let date = viewController.getDateTextAttributes()
        
        delegate.textAttributesValueChanged(textAttributes: [title, dday, date])
        viewController.dismiss()
    }
}


extension TextAttributesPresenter: UITableViewDelegate{
    
}

extension TextAttributesPresenter: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case TextTypeSection.edit.rawValue:
            return cellList.count
        case TextTypeSection.reset.rawValue:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case TextTypeSection.edit.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextAttributesCell", for: indexPath) as? TextAttributesCell
            cell?.selectionStyle = .none
            cell?.bind(delegate: self, cell: cellList[safe: indexPath.row])
            cell?.setData(isHidden: textAttributes[safe: indexPath.row]?.isHidden)
            cell?.setData(color: textAttributes[safe: indexPath.row]?.color)
            return cell ?? UITableViewCell()
            
        case TextTypeSection.reset.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextAttributesButtonCell", for: indexPath) as? TextAttributesButtonCell
            cell?.selectionStyle = .none
            cell?.bind(delegate: self, cell: sectionList[safe: indexPath.section])
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

extension TextAttributesPresenter: TextAttributesDelegate{
    func textAttributesValueChanged(textAttributes: [TextAttributes]) {
        self.textAttributes = textAttributes
    }
}

extension TextAttributesPresenter: DetailViewDelegate{
    func valueChanged(_ cell: TextType?, didChangeValue: Any?) {
        if didChangeValue is Bool{
            guard let isHidden = didChangeValue as? Bool else {return}
            viewController.setIsHidden(cell, value: isHidden)
        }
        if didChangeValue is String{
            guard let color = didChangeValue as? String else {return}
            viewController.setTextColor(cell, value: color)
        }
    }
    
    func reset(){
        let cells = viewController.getTableViewEditCell() as? [TextAttributesCell]
        cells?.forEach{
            let textAttributes = TextAttributes()
            $0.setData(isHidden: textAttributes.isHidden)
            $0.setData(color: textAttributes.color)
        }
        viewController.resetPosition()
    }
}
