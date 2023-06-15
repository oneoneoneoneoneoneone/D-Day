//
//  Photo.swift
//  D-Day
//
//  Created by hana on 2023/06/14.
//

import Foundation

struct SearchResult: Codable {
    let total, totalPages: Int
    let results: [Photo]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

struct Photo: Codable {
//    let identifier: UUID
    let id: String
    let width, height: Float
    let color: String
    let urls: Urls
}

struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}

extension Photo: Hashable, Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
