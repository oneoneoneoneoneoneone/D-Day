//
//  NetworkManager.swift
//  D-Day
//
//  Created by hana on 2023/06/15.
//

import Foundation

protocol NetworkManagerProtocol{
    func fetchNewPhotos(page: Int, completion: @escaping ([Photo]) -> Void)
    func fetchSearchPhotos(query: String, page: Int, completion: @escaping ([Photo]) -> Void)
}


class NetworkManager: NetworkManagerProtocol{
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func fetchNewPhotos(page: Int, completion: @escaping ([Photo]) -> Void){
        network.request(api: UnsplashAPI.getPhotos(page: page), dataType: [Photo].self) { result in
            switch result {
            case .success(let result):
                completion(result)
            case .failure(let networkError):
                NSLog("\(networkError)")
            }
        }
    }
    
    func fetchSearchPhotos(query: String, page: Int, completion: @escaping ([Photo]) -> Void){
        network.request(api: UnsplashAPI.getSearchPhotos(query: query, page: page), dataType: SearchResult.self) { result in
            switch result {
            case .success(let result):
                completion(result.results)
            case .failure(let networkError):
                NSLog("\(networkError)")
            }
        }
    }
}
