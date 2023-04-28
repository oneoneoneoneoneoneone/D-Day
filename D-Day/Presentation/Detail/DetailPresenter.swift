//
//  DetailPresenter.swift
//  D-Day
//
//  Created by hana on 2023/03/02.
//

import UIKit
import NotificationCenter
import RealmSwift


protocol DetailProtocol{
    func setNavigation()
    func setLayout()
    func setData(item: Item, image: UIImage!)
    
    func presentToEditViewController(item: Item)
    func showShareActivityViewController(title: String, date: String, image: UIImage)
    func showDeleteAlertController()
    
    func transformToImage() -> UIImage?
}


final class DetailPresenter{
    private let viewController: DetailProtocol
    private let repository: Repository
    private let notificationCenter = NotificationCenterManager()
    
    private let id: String
    private var item = Item()
    
    init(viewController: DetailProtocol, repository: Repository = Repository(), id: String) {
        self.viewController = viewController
        self.repository = repository
        self.id = id
    }
    
    func viewDidLoad(){
        viewController.setNavigation()
        viewController.setLayout()
    }
    
    func viewWillAppear(){
        self.item = repository.readItem().filter{$0.id.stringValue == id}.first ?? Item()
        let image = repository.loadImageFromDocumentDirectory(imageName: item.id.stringValue)
        
        viewController.setData(item: item, image: image)
    }
    
    func rightEditButtonTap(){
        viewController.presentToEditViewController(item: item)
    }
    
    func shareButtonTap(){
        guard let image = viewController.transformToImage() else {return}
        
        viewController.showShareActivityViewController(title: item.title, date: Util.stringFromDate(date: item.date), image: image)
    }
    
    func deleteButtonTap(){
        viewController.showDeleteAlertController()
    }
    
    func deleteItem(){
        //기본 위젯
        if repository.getDefaultWidget() == self.item.id.stringValue {
            repository.setDefaultWidget(id: nil)
        }
        //알림
        notificationCenter.remove(self.item.id.stringValue)
        //이미지
        repository.deleteImageToDocumentDirectory(imageName: self.item.id.stringValue)
        //item
        repository.deleteItem(self.item)
    }
}
