//
//  PhotoCollectionPresenter.swift
//  D-Day
//
//  Created by hana on 2023/06/15.
//

import Foundation
import UIKit

protocol PhotoCollectionProtocol{
    func setNavigation()
    func setLayout()
    func setDataSource()
    
    func applySnapshot(with photos: [Photo])
    func resetCollectionViewContentOffset()
}

class PhotoCollectionPresenter: NSObject{
    private let viewController: PhotoCollectionProtocol
    private let networkManager: NetworkManagerProtocol
    
    private var photos: [Photo] = []
    private var searchText: String?
    private var currentPhotos: PhotosType = .new
    private var page: Int = 0
    
    init(viewController: PhotoCollectionProtocol, networkManager: NetworkManagerProtocol = NetworkManager(network: Network())) {
        self.viewController = viewController
        self.networkManager = networkManager
    }
    
    func viewDidLoad(){
        viewController.setNavigation()
        viewController.setLayout()
        viewController.setDataSource()
    }
    
    func nextPageFetchPhotos(){
        page += 1
        
        switch currentPhotos{
        case .new: fetchNewPhotos()
        case .search: fetchSearchPhotos()
        }
    }
    
    func searchBarSearchButtonClicked(_ text: String){
        reset()
        searchText = text
        currentPhotos = .search
        nextPageFetchPhotos()
    }
    
    func searchBarCancelButtonClicked(){
        reset()
        nextPageFetchPhotos()
    }
    
    func getImageData(_ row: Int) -> Data {
        guard let url = URL(string: photos[safe: row]?.urls.regular ?? "") else { return .init() }
        
        if let data = ImageCacheManager().loadFromCache(imageURL: url) {
            return data
        }
        NSLog("cache ImageDaga nil")
        return .init()
    }
    
    func getPhotosCount() -> Int {
        return self.photos.count
    }
    
    func getPhotoWidth(_ row: Int) -> Float {
        return self.photos[row].width
    }
    
    func getPhotoHeight(_ row: Int) -> Float {
        return self.photos[row].height
    }
    
    private func fetchNewPhotos(){
        networkManager.fetchNewPhotos(page: page){ [weak self] newPhotos in
            guard let self = self else { return }
            
            photos += newPhotos
            
            if photos.isEmpty == true {
                viewController.resetCollectionViewContentOffset()
            }
            viewController.applySnapshot(with: photos)
        }
    }
    
    private func fetchSearchPhotos() {
        guard let query = searchText else { return }
        
        networkManager.fetchSearchPhotos(query: query, page: page){ [weak self] newPhotos in
            guard let self = self else { return }
            
            photos += newPhotos
            
            if photos.isEmpty == true {
                viewController.resetCollectionViewContentOffset()
            }
            viewController.applySnapshot(with: photos)
        }
    }
    
    private func reset() {
        viewController.resetCollectionViewContentOffset()
        searchText = ""
        currentPhotos = .new
        page = 0
        photos.removeAll()
    }
}

enum PhotosType{
    case new, search
}
