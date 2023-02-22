//
//  Repository.swift
//  D-Day
//
//  Created by hana on 2023/02/06.
//

import Foundation
import RealmSwift
import UIKit


protocol RepositoryType{
    func read() -> Results<Item>!
    func edit(data: Item)
    func delete(data: Item)
}

class Repository: RepositoryType{
    private let appGroupId = "group.D-Day"
    
    private var realm: Realm{
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId)
        let realmURL = container?.appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 4)
        
        return try! Realm(configuration: config)
    }
    
    func read() -> Results<Item>!{
//        print(realm.configuration.fileURL!)
        
        return realm.objects(Item.self)
    }
    
    func edit(data: Item) {
        if let item = realm.objects(Item.self).filter(NSPredicate(format: "id = %@", data.id )).first{
            //수정
            try! realm.write{
                item.title = data.title
                item.titleColor = data.titleColor
                item.date = data.date
                item.isStartCount = data.isStartCount
                item.backgroundColor = data.backgroundColor
                item.isBackgroundColor = data.isBackgroundColor
                item.isBackgroundImage = data.isBackgroundImage
                item.isCircle = data.isCircle
                item.memo = data.memo
            }
        }
        else{
            //생성
            try! realm.write{
                realm.add(data)
            }
        }
    }
    
    func delete(data: Item) {
        try! realm.write{
            realm.delete(data)
        }
    }
    
    func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
//        // 1. 이미지를 저장할 경로를 설정해줘야함 - 도큐먼트 폴더,File 관련된건 Filemanager가 관리함(싱글톤 패턴)
//        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
//
//        // 2. 이미지 파일 이름 & 최종 경로 설정
//        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId)
        guard let imageUrl = container?.appendingPathComponent(imageName) else {return}

        // 3. 이미지 압축(image.pngData())
        // 압축할거면 jpegData로~(0~1 사이 값)
        guard let data = image.pngData() else {
           print("압축이 실패했습니다.")
           return
        }

        deleteImageToDocumentDirectory(imageName: imageName)

        // 5. 이미지를 도큐먼트에 저장
        // 파일을 저장하는 등의 행위는 조심스러워야하기 때문에 do try catch 문을 사용하는 편임
        do {
           try data.write(to: imageUrl)
           print("이미지 저장완료")
        } catch {
           print("이미지를 저장하지 못했습니다.")
        }
    }
    
    func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
//        // 1. 도큐먼트 폴더 경로가져오기
//        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
//        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
//        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
//
//        if let directoryPath = path.first {
//            // 2. 이미지 URL 찾기
//            let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
//            // 3. UIImage로 불러오기
//            return UIImage(contentsOfFile: imageURL.path)
//        }
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId)
        guard let imageUrl = container?.appendingPathComponent(imageName) else {return nil}
        
        print("\(imageName) - \(imageUrl.path)")
        return UIImage(contentsOfFile: imageUrl.path)
    }
    
    
    func deleteImageToDocumentDirectory(imageName: String) {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId)
        guard let imageUrl = container?.appendingPathComponent(imageName) else {return}
        
        // 4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기하는 경우
        // 4-1. 이미지 경로 여부 확인
        if FileManager.default.fileExists(atPath: imageUrl.path) {
           // 4-2. 이미지가 존재한다면 기존 경로에 있는 이미지 삭제
           do {
               try FileManager.default.removeItem(at: imageUrl)
               print("이미지 삭제 완료")
           } catch {
               print("이미지를 삭제하지 못했습니다.")
           }
        }
    }
    
}
