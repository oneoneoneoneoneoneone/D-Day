//
//  EditCellList.swift
//  D-Day
//
//  Created by hana on 2023/04/28.
//

import Foundation

enum EditCellType: Int, CaseIterable{
    case main = 0
    case view = 1
    case ext = 2
}

enum EditCellList: CaseIterable{
    case title, date, isStartCount, backgroundColor, backgroundImage, isCircle, memo
    //, repeatCode

    var section: EditCellType{
        switch self{
        case.title, .date, .isStartCount://, .repeatCode:
            return .main
        case .backgroundColor, .backgroundImage, .isCircle:
            return .view
        case .memo:
            return .ext
        }
    }

    var text: String{
        switch self{
        case .title:
            return "제목을 입력해주세요."
        case .date:
            return "날짜"
        case .isStartCount:
            return "날짜 카운트"
//            case .repeatCode:
//                return "반복"
        case .backgroundColor:
            return "배경색"
        case .backgroundImage:
            return "배경이미지"
        case .isCircle:
            return "배경 스타일"
        case .memo:
            return "메모"
        }
    }
    
    var subText: [String]{
        switch self{
        case .isStartCount:
            return ["디데이", "기념일"]
        case .isCircle:
            return ["기본", "동그랗게"]
        default: return []
        }
    }
}
