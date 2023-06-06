//
//  EditCellProtocol.swift
//  D-Day
//
//  Created by hana on 2023/06/05.
//

import RealmSwift
import UIKit

class UIEditCell: UITableViewCell{
    internal var id: String?
    internal var image: UIImage = UIImage()
    internal var title: String = ""
    internal var date: Date = Date()
    internal var isStartCount: Bool = false
    internal var textAttributes: [TextAttributes] = []
    internal var background: Background = Background()
    internal var memo: String = ""
    
    internal var delegate: EditCellDelegate?
    internal var cell: EditCell?
        
    internal func setLayout(){}
    internal func bind(delegate: EditCellDelegate, cell: EditCell){}

    internal func setData(id: String?){
        guard let id = id else { return }
        self.id = id
    }
    internal func setData(image: UIImage?){
        guard let image = image else { return }
        self.image = image
    }
    internal func setData(title: String?){
        guard let title = title else { return }
        self.title = title
    }
    internal func setData(date: Date?){
        guard let date = date else { return }
        self.date = date
    }
    internal func setData(isStartCount: Bool?){
        guard let isStartCount = isStartCount else { return }
        self.isStartCount = isStartCount
    }
    internal func setData(textAttributes: List<TextAttributes>?){
        guard let textAttributes = textAttributes else { return }
        self.textAttributes = Array(textAttributes)
    }
    internal func setData(backgroundColor: String?){
        guard let backgroundColor = backgroundColor else { return }
        self.background.color = backgroundColor
    }
    internal func setData(backgroundIsColor: Bool?){
        guard let backgroundIsColor = backgroundIsColor else { return }
        self.background.isColor = backgroundIsColor
    }
    internal func setData(backgroundIsImage: Bool?){
        guard let backgroundIsImage = backgroundIsImage else { return }
        self.background.isImage = backgroundIsImage
    }
    internal func setData(backgroundIsCircle: Bool?){
        guard let backgroundIsCircle = backgroundIsCircle else { return }
        self.background.isCircle = backgroundIsCircle
    }
    internal func setData(background: Background?){
        guard let background = background else { return }
        self.background.color = background.color
        self.background.isColor = background.isColor
        self.background.isImage = background.isImage
        self.background.isCircle = background.isCircle
    }
    
    internal func setData(memo: String){
        self.memo = memo
    }
}
