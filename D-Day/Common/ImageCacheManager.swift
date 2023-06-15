//
//  ImageCacheManager.swift
//  D-Day
//
//  Created by hana on 2023/06/14.
//

import Foundation

//URLCache의 서브클래스는 스레드로부터 안전한 방식으로 재정의된 메서드를 구현
//시스템의 디스크 공간이 부족할 때 온디스크 캐시가 제거될 수 있움
class ImageCacheManager{
    let cache = URLCache.shared
    
    func loadFromCache(imageURL: URL) -> Data? {
        let request = URLRequest(url: imageURL)

        return self.cache.cachedResponse(for: request)?.data
    }
    
    func storeCachedResponse(response: CachedURLResponse, request: URLRequest){
        cache.storeCachedResponse(response, for: request)
    }
}
