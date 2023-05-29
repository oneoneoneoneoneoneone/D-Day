//
//  TextAttributesPresenter.swift
//  D-Day
//
//  Created by hana on 2023/05/25.
//

import UIKit

protocol TextAttributesDelegate{
    func textAttributesValueChanged(title: TextAttributes, dday: TextAttributes, date: TextAttributes)
}

protocol TextAttributesProtocol{
    func setNavigation()
    func setLayout()
    func setData(title: Title, dday: DDay, backgound: Background, image: UIImage?)
    
    func getTitleTextAttributes() -> TextAttributes
    func getDDayTextAttributes() -> TextAttributes
    func getDateTextAttributes() -> TextAttributes
    func dismiss()
}


final class TextAttributesPresenter: NSObject{
    private let viewController: TextAttributesProtocol
    private let delegate: TextAttributesDelegate
    private let repository: Repository
    
    private var itemTitle: Title
    private var dday: DDay
    private var background: Background
    private var id: String
    
    private final let sectionCnt = TextAttributesCellType.allCases.count
    private final let cellCnt = TextAttributesCellList.allCases.count
    
    init(viewController: TextAttributesProtocol, delegate: TextAttributesDelegate, repository: Repository = Repository(), id: String, title: Title, dday: DDay, background: Background){
        self.viewController = viewController
        self.delegate = delegate
        self.repository = repository
        self.itemTitle = title
        self.dday = dday
        self.background = background
        self.id = id
    }
    
    func viewDidLoad(){
        viewController.setNavigation()
        viewController.setLayout()
    }
    
    func viewWillAppear(){
        let image = repository.loadImageFromDocumentDirectory(imageName: id)
        
        viewController.setData(title: itemTitle, dday: dday, backgound: background, image: image)
    }
    
    func leftCencelButtonTap(){
        viewController.dismiss()
    }
    
    func rightEditButtonTap(){
        let title = viewController.getTitleTextAttributes()
        let dday = viewController.getDDayTextAttributes()
        let date = viewController.getDateTextAttributes()
        
        delegate.textAttributesValueChanged(title: title, dday: dday, date: date)
        viewController.dismiss()
    }
}


extension TextAttributesPresenter: UITableViewDelegate{
    
}

extension TextAttributesPresenter: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionCnt
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
//        switch section{
//        case TextAttributesCellType.title.rawValue:
//            return cellCnt - 1
//        default:
//            return cellCnt
//        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var row = TextAttributes()
        switch indexPath.section{
        case TextAttributesCellType.title.rawValue:
            row = itemTitle.textAttributes ?? TextAttributes()
        case TextAttributesCellType.dday.rawValue:
            row = dday.textAttributes[safe: DDayText.dday.rawValue] ?? TextAttributes()
        case TextAttributesCellType.date.rawValue:
            row = dday.textAttributes[safe: DDayText.date.rawValue] ?? TextAttributes()
        default:
            break
        }
        
        switch indexPath.row{
        case TextAttributesCellList.ishidden.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextAttributesSwitchCell", for: indexPath) as? TextAttributesSwitchCell
//            cell?.bind(delegate: <#T##EditCellDelegate#>, cell: <#T##EditCellList#>)
            cell?.setData(isOn: row.isHidden)
            
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}
