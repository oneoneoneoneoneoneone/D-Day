//
//  EditCellList.swift
//  D-Day
//
//  Created by hana on 2023/04/28.
//

import Foundation
import UIKit

enum EditCellType: Int, CaseIterable{
    case contents = 0
    case background = 1
    case ext = 2
}

enum EditCell: Int, CaseIterable{
    case title, date, isStartCount, backgroundColor, backgroundImage, isCircle, textAttribute, memo
    //, repeatCode

    var section: EditCellType{
        switch self{
        case.title, .date, .isStartCount://, .repeatCode:
            return .contents
        case .backgroundColor, .backgroundImage, .isCircle, .textAttribute:
            return .background
        case .memo:
            return .ext
        }
    }

    var text: String{
        switch self{
        case .title:
            return NSLocalizedString("제목을 입력해주세요.", comment: "")
        case .date:
            return NSLocalizedString("날짜", comment: "")
        case .isStartCount:
            return NSLocalizedString("날짜 카운트", comment: "")
//            case .repeatCode:
//                return "반복"
        case .backgroundColor:
            return NSLocalizedString("배경 색", comment: "")
        case .backgroundImage:
            return NSLocalizedString("배경 이미지", comment: "")
        case .isCircle:
            return NSLocalizedString("배경 스타일", comment: "")
        case .textAttribute:
            return NSLocalizedString("글자 배치 설정", comment: "")
        case .memo:
            return NSLocalizedString("메모", comment: "")
        }
    }
    
    var subText: [String]{
        switch self{
        case .isStartCount:
            return [NSLocalizedString("디데이", comment: ""), NSLocalizedString("기념일", comment: "")]
        case .isCircle:
            return [NSLocalizedString("기본", comment: ""), NSLocalizedString("동그랗게", comment: "")]
        case .backgroundImage:
            return [NSLocalizedString("배경 이미지를 선택해주세요.", comment: "")]
        case .memo:
            return [NSLocalizedString("메모를 입력해주세요.", comment: "")]
        default: return []
        }
    }
    
    var reuseIdentifier: String{
        switch self{
        case .title:
            return "EditTableViewTitleCell"
        case .date:
            return "EditTableViewDateCell"
        case .isStartCount:
            return "EditTableViewToggleCell"
        case .backgroundColor:
            return "EditTableViewColorCell"
        case .backgroundImage:
            return "EditTableViewImageCell"
        case .isCircle:
            return "EditTableViewToggleCell"
        case .textAttribute:
            return "EditTableViewPresentButtonCell"
        case .memo:
            return "EditTableViewMemoCell"
        }
    }
}
