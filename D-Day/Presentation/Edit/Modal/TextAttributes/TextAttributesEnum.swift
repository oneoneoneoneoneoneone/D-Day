//
//  TextAttributesEnum.swift
//  D-Day
//
//  Created by hana on 2023/05/25.
//

import Foundation

enum TextType: Int, CaseIterable{
    case title, dday, date
    
    var text: String{
        switch self{
        case .title:
            return "제목"
        case .dday:
            return "디데이"
        case .date:
            return "날짜"
        }
    }
    
    var centerX: CGFloat{
        switch self{
        case .title:
            return 1.0
        case .dday:
            return 1.0
        case .date:
            return 1.0
        }
    }
    
    var centerY: CGFloat{
        switch self{
        case .title:
            return 0.5
        case .dday:
            return 1.0
        case .date:
            return 1.5
        }
    }
}

enum TextTypeSection: Int, CaseIterable{
    case edit, reset
    
    var text: String{
        switch self{
        case .edit:
            return "수정"
        case .reset:
            return "초기화"
        }
    }
}
