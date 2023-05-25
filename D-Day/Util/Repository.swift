//
//  Repository.swift
//  D-Day
//
//  Created by hana on 2023/02/06.
//

import Foundation
import RealmSwift
import UIKit

protocol RepositoryProtocol{
    func readItem() -> [Item]!
    func editItem(_ data: Item)
    func deleteItem(_ data: Item)
    
    func setDefaultWidget(id: String!)
    func getDefaultWidget() -> String!
}

class Repository: RepositoryProtocol{
    private final let appGroupId = "group.D-Day"
    private final let defaultRealmPath = "default.realm"
    private lazy var container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId)
    
    
    //MARK: Realm
    private var realm: Realm{
        let realmURL = container?.appendingPathComponent(defaultRealmPath)
        let config = Realm.Configuration(
            fileURL: realmURL,
            schemaVersion: 14,
            migrationBlock: {migration, oldSchemaVersion in
                if oldSchemaVersion < 9{    //마지막으로 실행된 스키마 버전이 새스키마 버전보다 작은 경우
                    migration.enumerateObjects(ofType: Item.className()){ oldObject, newObject in
                        let tempTitle = Title()
                        tempTitle.text = oldObject?["title"] as? String ?? Title().text
                        tempTitle.color = oldObject?["titleColor"] as? String ?? Title().color
                        let tempDday = DDay()
                        tempDday.date = oldObject?["date"] as? Date ?? DDay().date
                        tempDday.isStartCount = oldObject?["isStartCount"] as? Bool ?? DDay().isStartCount
                        let tempBg = Background()
                        tempBg.color = oldObject?["backgroundColor"] as? String ?? Background().color
                        tempBg.isColor = oldObject?["isBackgroundColor"] as? Bool ?? Background().isColor
                        tempBg.isImage = oldObject?["isBackgroundImage"] as? Bool ?? Background().isImage
                        tempBg.isCircle = oldObject?["isCircle"] as? Bool ?? Background().isCircle
                        
                        newObject?["title"] = tempTitle
                        newObject?["dday"] = tempDday
                        newObject?["background"] = tempBg
                    }
                }
            },
            objectTypes: [Item.self, Title.self, DDay.self, Background.self, TextAttributes.self])
        
        
        Realm.Configuration.defaultConfiguration = config
        
        
        
        return try! Realm(configuration: config)
    }
    
    func readItem() -> [Item]!{
        print(realm.configuration.fileURL!)
        
        return Array(realm.objects(Item.self))
    }
    
    func editItem(_ data: Item) {
        if let item = realm.objects(Item.self).filter(NSPredicate(format: "id = %@", data.id )).first{
            //수정
            try! realm.write{
                item.title!.text = data.title!.text
                item.dday = data.dday
                item.background = data.background
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
    
    func deleteItem(_ data: Item) {
        try! realm.write{
            realm.delete(data)
        }
    }
    
    
    //MARK: FileManager Document Image
    func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
        guard let imageUrl = container?.appendingPathComponent(imageName) else {return nil}
        
        print("\(imageName) - \(imageUrl.path)")
        //UIImage로 불러오기
        return UIImage(contentsOfFile: imageUrl.path)
    }
    
    func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
        //경로 설정
        guard let imageUrl = container?.appendingPathComponent(imageName) else {return}
        
        //이미지 압축(image.pngData())
        //??압축할거면 jpegData로~(0~1 사이 값)
        guard let data = image.pngData() else {
            print("압축이 실패했습니다.")
            return
        }
        
        //덮어쓰기 여부 확인
        deleteImageToDocumentDirectory(imageName: imageName)
        
        //이미지를 도큐먼트에 저장
        //파일을 저장하는 등의 행위는 조심스러워야하기 때문에 do try catch 문을 사용하는 편임
        do {
            try data.write(to: imageUrl)
            print("이미지 저장완료")
        } catch {
            print("이미지를 저장하지 못했습니다.")
        }
    }
    
    func deleteImageToDocumentDirectory(imageName: String) {
        guard let imageUrl = container?.appendingPathComponent(imageName) else {return}
        
        //이미지 경로 여부 확인
        if FileManager.default.fileExists(atPath: imageUrl.path) {
            //이미지가 존재한다면 기존 경로에 있는 이미지 삭제
            do {
                try FileManager.default.removeItem(at: imageUrl)
                print("이미지 삭제 완료")
            } catch {
                print("이미지를 삭제하지 못했습니다.")
            }
        }
    }
    
    func setDefaultWidget(id: String!){
        UserDefaults(suiteName: appGroupId)?.setValue(id, forKey: "defaultWidget")
    }

    func getDefaultWidget() -> String!{
        return UserDefaults(suiteName: appGroupId)?.string(forKey: "defaultWidget")
    }
}
