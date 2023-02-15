//
//  CollectionViewController.swift
//  D-Day
//
//  Created by hana on 2023/01/27.
//

import UIKit
import RxSwift
import RxCocoa

class CollectionViewController: UICollectionView{
    private final let itemInset = 5.0
    
    private let disposeBag = DisposeBag()
    private var items: [Item] = []
    private var displayStyle: MainViewController.DisplayStyle = .x11
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ items: [Item]){
        //try! self.items = items
        self.items = items
        
        self.reloadData()
    }
    
    func setDisplayStyle(style: MainViewController.DisplayStyle){
        displayStyle = style
        
        self.reloadData()
    }
    
    private func attribute(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 0       // 상하간격
//        layout.minimumInteritemSpacing = 0  // 좌우간격
                
        self.delegate = self
        self.dataSource = self
        
        self.register(CollectionViewCell_1x1.self, forCellWithReuseIdentifier: "CollectionViewCell_1x1")
        self.register(CollectionViewCell_2x2.self, forCellWithReuseIdentifier: "CollectionViewCell_2x2")
        self.register(CollectionViewCell_1x4.self, forCellWithReuseIdentifier: "CollectionViewCell_1x4")
        self.register(CollectionViewCell_2x4.self, forCellWithReuseIdentifier: "CollectionViewCell_2x4")
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch displayStyle{
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
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        UIEdgeInsets(top: itemInset, left: itemInset, bottom: itemInset, right: itemInset)
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch displayStyle{
        case .x11:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: displayStyle.id, for: indexPath) as? CollectionViewCell_1x1 else{return UICollectionViewCell()}
            cell.setData(item: items[indexPath.row])
            
            return cell
        case .x22:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: displayStyle.id, for: indexPath) as? CollectionViewCell_2x2 else{return UICollectionViewCell()}
            cell.setData(item: items[indexPath.row])
            
            return cell
        case .x14:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: displayStyle.id, for: indexPath) as? CollectionViewCell_1x4 else{return UICollectionViewCell()}
            cell.setData(item: items[indexPath.row])
            
            return cell
        case .x24:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: displayStyle.id, for: indexPath) as? CollectionViewCell_2x4 else{return UICollectionViewCell()}
            cell.setData(item: items[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.setData(item: items[indexPath.row])
        
        window?.rootViewController?.childViewControllerForPointerLock?.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
}
