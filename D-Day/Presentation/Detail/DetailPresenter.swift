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
    func setData(_ item: Item)
    
    func presentToEditViewController(item: Item)
    func showShareActivityViewController(title: String, date: String, image: UIImage)
    func showDeleteAlertController()
    
    func transformToImage() -> UIImage?
}


final class DetailPresenter{
    private let viewController: DetailProtocol
    
    private let userNotificationCenter = UNUserNotificationCenter.current()
    private let id: ObjectId
    private var item = Item()
    
    init(viewController: DetailProtocol, id: ObjectId) {
        self.viewController = viewController
        self.id = id
    }
    
    func viewDidLoad(){
        viewController.setNavigation()
        viewController.setLayout()
    }
    
    func viewWillAppear(){
        self.item = Repository().read().filter(NSPredicate(format: "id = %@", id )).first ?? Item()
        
        viewController.setData(item)
    }
    
    func rightEditButtonTap(){
        viewController.presentToEditViewController(item: item)
    }
    
    func shareButtonTap(){
        guard let image = viewController.transformToImage() else {return}
        
        viewController.showShareActivityViewController(title: item.title, date: Util.StringFromDate(date: item.date), image: image)
    }
    
    func deleteButtonTap(){
        viewController.showDeleteAlertController()
    }
    
    func deleteRepository(){
        self.userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [self.item.id.stringValue])
        Repository().deleteImageToDocumentDirectory(imageName: self.item.id.stringValue)
        Repository().delete(data: self.item)
    }
}

//extension DetailPresenter: EditDelegate{
//    func updateData(_ item: Item) {
//        self.item = item
//        viewController.setData(item)
//    }
//}
