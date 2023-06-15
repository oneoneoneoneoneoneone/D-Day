//
//  API.swift
//  D-Day
//
//  Created by hana on 2023/06/14.
//

import Foundation

enum UnsplashAPI{
    case getPhotos(page: Int)
    case getSearchPhotos(query: String, page: Int)
    case getRandomPhotos
    
    var scheme: String {
        "https"
    }
    
    var host: String {
        "api.unsplash.com"
    }
    
    var method: String{
        "GET"
    }
    
    var path: String {
        switch self{
        case .getPhotos:
            return "/photos"
        case .getSearchPhotos:
            return "/search/photos"
        case .getRandomPhotos:
            return "/photos/random"
        }
    }
    
    var query: [String: String]? {
        switch self {
        case .getPhotos(let page):
            return [
                "page": "\(page)",
                "per_page": "10"
            ]
        case .getSearchPhotos(let query, let page):
            return [
                "query": query,
                "page": "\(page)",
                "per_page": "10"
            ]
        case .getRandomPhotos:
            return [
                "count": "10"
            ]
        }
    }
    
    var headers: [String: String]? {
        return ["Authorization": "Client-ID \(UnsplashAPIKey.accessKey)"]
    }
    
    var getComponents: URLComponents {
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = self.path
        components.queryItems = self.query?.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        return components
    }
}
