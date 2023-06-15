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
            return NSLocalizedString("제목", comment: "")
        case .dday:
            return NSLocalizedString("디데이", comment: "")
        case .date:
            return NSLocalizedString("날짜", comment: "")
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
    
    var defualtValue: TextAttributes{
        return TextAttributes(centerY: Float(self.centerY))
    }
}

enum TextTypeSection: Int, CaseIterable{
    case edit, reset
    
    var text: String{
        switch self{
        case .edit:
            return NSLocalizedString("수정", comment: "")
        case .reset:
            return NSLocalizedString("초기화", comment: "")
        }
    }
}
