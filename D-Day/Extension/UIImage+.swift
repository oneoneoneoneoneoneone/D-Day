////
////  UIImage+.swift
////  D-Day
////
////  Created by hana on 2023/06/15.
////
//
//import UIKit
//
//extension UIImage{
//
//    convenience init(url: URL){
//        if let data = ImageCacheManager().loadFromCache(imageURL: url) {
//            guard let image = UIImage(data: data) else {
//                NSLog("Initializing UIImage cache fail - \(url)")
//                return
//            }
//
//            DispatchQueue.main.async {
//                image = image
//            }
//        }
//        else {
//            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
//
//            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
//                guard let self = self,
//                      error == nil,
//                      let response = response,
//                      let data = data,
//                      let image = UIImage(data: data) else {
//                    NSLog("Initializing UIImage dataTask fail - \(url)")
//                    return
//                }
//
//                let cachedData = CachedURLResponse(response: response, data: data)
//                ImageCacheManager().storeCachedResponse(response: cachedData, request: request)
//
//                DispatchQueue.main.async {
//                    UIView.transition(with: self, duration: 0.25, options: [.transitionCrossDissolve], animations: {
//                        self = image
//                    }, completion: nil)
//                }
//            }.resume()
//        }
//    }
//
//    func downloadPhoto(_ url: URL) {
//        if let data = ImageCacheManager().loadFromCache(imageURL: url) {
//            guard let image = UIImage(data: data) else {
//                NSLog("Initializing UIImage cache fail - \(url)")
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.ini = image
//            }
//        }
//        else {
//            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
//
//            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
//                guard let self = self,
//                      error == nil,
//                      let response = response,
//                      let data = data,
//                      let image = UIImage(data: data) else {
//                    NSLog("Initializing UIImage dataTask fail - \(url)")
//                    return
//                }
//
//                let cachedData = CachedURLResponse(response: response, data: data)
//                ImageCacheManager().storeCachedResponse(response: cachedData, request: request)
//
//                DispatchQueue.main.async {
//                    UIView.transition(with: self, duration: 0.25, options: [.transitionCrossDissolve], animations: {
//                        self = image
//                    }, completion: nil)
//                }
//            }.resume()
//        }
//    }
//}
