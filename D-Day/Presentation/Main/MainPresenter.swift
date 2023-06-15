//
//  MainPresenter.swift
//  D-Day
//
//  Created by hana on 2023/01/30.
//

import UIKit
import RealmSwift


protocol MainProtocol{
    func setNavigationBar()
    func setLayout()
    func reloadCollectionView()
    
    func presentToSideMenu()
    func presentToEditViewController()
    func presentToDetailViewController(id: String)
    
    func showToast(message: String)
}

final class MainPresenter: NSObject{
    private let viewController: MainProtocol
    private let userDefaultsManager: UserDefaultsManager
    private let repository: Repository
    
    
    private let displayList = [DisplayStyle.x11, DisplayStyle.x22, DisplayStyle.x14, DisplayStyle.x24]
    private let sortList = [SortStyle.title, SortStyle.dateDesc, SortStyle.dateAsc]
    private var currentDisplayIndex = 0
    private var currentSortIndex = 0
    
    private var items: [Item] = []
    
    init(viewController: MainProtocol, userDefaultsManager: UserDefaultsManager = UserDefaultsManager(), repository: Repository = Repository()) {
        self.viewController = viewController
        self.userDefaultsManager = userDefaultsManager
        self.repository = repository
    }
    
    private func setSort(){
        switch sortList[currentSortIndex]{
        case .title:
            items = items.sorted { $0.title < $1.title }
        case .dateAsc:
            items = items.sorted { $0.date > $1.date }
        case .dateDesc:
            items = items.sorted { $0.date < $1.date }
        }
    }
        
    private func bind(_ items: [Item]){
        self.items = items
        
    }
    
    func viewDidLoad(){
        viewController.setNavigationBar()
        viewController.setLayout()
        
        currentDisplayIndex = userDefaultsManager.getCurrentDisplay()
        currentSortIndex = userDefaultsManager.getCurrentSort()
    }
    
    func viewWillAppear(){
        let readItems = repository.readItem()
        bind(readItems)
        
        setSort()
        
        viewController.reloadCollectionView()
    }
    
    func rightDisplayButtonTap(){
        self.currentDisplayIndex = (self.currentDisplayIndex + 1) % displayList.count
        userDefaultsManager.setCurrentDisplay(index: currentDisplayIndex)
        
        viewController.reloadCollectionView()
        viewController.showToast(message: displayList[currentDisplayIndex].message)
    }
    
    func rightSortButtonTap(){
        self.currentSortIndex = (currentSortIndex + 1) % sortList.count
        userDefaultsManager.setCurrentSort(index: currentSortIndex)
        
        setSort()
        
        viewController.reloadCollectionView()
        viewController.showToast(message: sortList[currentSortIndex].message)
    }
    
    func rightSettingButtonTap(){
        viewController.presentToSideMenu()
    }
    
    func addButtonTap(){
        viewController.presentToEditViewController()
    }
}

extension MainPresenter: EditDelegate{
    func selectItem(_ id: String) {
        viewController.presentToDetailViewController(id: id)
    }
}


//MARK: UICollectionViewDelegate & DataSource method
extension MainPresenter: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewController.presentToDetailViewController(id: items[indexPath.row].id.stringValue)
    }
}


extension MainPresenter: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch displayList[currentDisplayIndex]{
        case .x11:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: displayList[currentDisplayIndex].id, for: indexPath) as? CollectionViewCell1x1 else{return UICollectionViewCell()}
            cell.setData(item: items[indexPath.row])
            
            return cell
        case .x22:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: displayList[currentDisplayIndex].id, for: indexPath) as? CollectionViewCell2x2 else{return UICollectionViewCell()}
            cell.setData(item: items[indexPath.row])
            
            return cell
        case .x14:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: displayList[currentDisplayIndex].id, for: indexPath) as? CollectionViewCell1x4 else{return UICollectionViewCell()}
            cell.setData(item: items[indexPath.row])
            
            return cell
        case .x24:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: displayList[currentDisplayIndex].id, for: indexPath) as? CollectionViewCell2x4 else{return UICollectionViewCell()}
            cell.setData(item: items[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch displayList[currentDisplayIndex]{
        case .x11:
            return CGSize(width: collectionView.frame.width/4 - 1, height: collectionView.frame.width/4 - 1)
        case .x22:
            return CGSize(width: collectionView.frame.width/2 - 1, height: collectionView.frame.width/2 - 1)
        case .x14:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width/4)// - itemInset*2)
        case .x24:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width/2)// - itemInset*2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
