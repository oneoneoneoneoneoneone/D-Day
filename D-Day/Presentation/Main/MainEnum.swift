//
//  MainEnum.swift
//  D-Day
//
//  Created by hana on 2023/04/30.
//

import Foundation

enum DisplayStyle{
    case x11, x22, x14, x24
    
    var id: String{
        switch self{
        case .x11:
            return "CollectionViewCell_1x1"
        case .x22:
            return "CollectionViewCell_2x2"
        case .x14:
            return "CollectionViewCell_1x4"
        case .x24:
            return "CollectionViewCell_2x4"
        }
    }
    
    var message: String{
        switch self{
        case .x11:
            return NSLocalizedString("1X1 크기로 보여집니다.", comment: "")
        case .x22:
            return NSLocalizedString("2X2 크기로 보여집니다.", comment: "")
        case .x14:
            return NSLocalizedString("1X4 크기로 보여집니다.", comment: "")
        case .x24:
            return NSLocalizedString("2X4 크기로 보여집니다.", comment: "")
        }
    }
}

enum SortStyle{
    case title, dateDesc, dateAsc
    
    var message: String{
        switch self{
        case .title:
            return NSLocalizedString("제목 순으로 보여집니다.", comment: "")
        case .dateDesc:
            return NSLocalizedString("완료 날짜가 가까운 순으로 보여집니다.", comment: "")
        case .dateAsc:
            return NSLocalizedString("완료 날짜가 먼 순으로 보여집니다.", comment: "")
        }
    }
}
