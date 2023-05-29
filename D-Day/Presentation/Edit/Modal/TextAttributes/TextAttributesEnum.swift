//
//  TextAttributesEnum.swift
//  D-Day
//
//  Created by hana on 2023/05/25.
//

import Foundation

enum TextAttributesCellType: Int, CaseIterable{
    case title, dday, date
}

enum TextAttributesCellList: Int, CaseIterable{
    case ishidden, usedtitleColor, color
        
    var text: String{
        switch self{
        case .ishidden:
            return "숨기기"
        case .usedtitleColor:
            return "제목 색상과 동일하게"
        case .color:
            return "색상"
        }
    }
}
