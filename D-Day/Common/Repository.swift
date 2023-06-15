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
    func readItem() -> [Item]
    func editItem(_ data: Item)
    func deleteItem(_ data: Item)
    
    func setDefaultWidget(id: String?)
    func getDefaultWidget() -> String?
}

class Repository: RepositoryProtocol{
    private final let appGroupId = "group.D-Day"
    private final let defaultRealmPath = "default.realm"
    private lazy var container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId)
    
    
    //MARK: Realm
    private var realm: Realm?{
        do{
            let realmURL = container?.appendingPathComponent(defaultRealmPath)
            let config = Realm.Configuration(
                fileURL: realmURL,
                schemaVersion: 18,
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
                    if oldSchemaVersion < 16{    //마지막으로 실행된 스키마 버전이 새스키마 버전보다 작은 경우
                        migration.enumerateObjects(ofType: Item.className()){ oldObject, newObject in
                            let oldTitle = oldObject?["title"] as? DynamicObject
                            let oldDDay = oldObject?["dday"] as? DynamicObject
                            
                            let oldTitleAttributes = oldTitle?["textAttributes"] as? DynamicObject
                            let tempAttributes = List<TextAttributes>()
                            let titleAttribute = TextAttributes()
                            titleAttribute.centerX = oldTitleAttributes?["centerX"] as? Float ?? TextAttributes().centerX
                            titleAttribute.centerY = oldTitleAttributes?["centerY"] as? Float ?? TextAttributes().centerY
                            titleAttribute.isHidden = oldTitleAttributes?["isHidden"] as? Bool ?? TextAttributes().isHidden
                            titleAttribute.color = oldTitle?["color"] as? String ?? TextAttributes().color
                            
                            let ddayAttribute = TextAttributes()
                            let oldDdayAttributes = oldDDay?.dynamicList("textAttributes").first as? DynamicObject
                            ddayAttribute.centerX = oldDdayAttributes?["centerX"] as? Float ?? TextAttributes().centerX
                            ddayAttribute.centerY = oldDdayAttributes?["centerY"] as? Float ?? TextAttributes().centerY
                            ddayAttribute.isHidden = oldDdayAttributes?["isHidden"] as? Bool ?? TextAttributes().isHidden
                            let dateAttribute = TextAttributes()
                            let oldDateAttributes = oldDDay?.dynamicList("textAttributes").last as? DynamicObject
                            dateAttribute.centerX = oldDateAttributes?["centerX"] as? Float ?? TextAttributes().centerX
                            dateAttribute.centerY = oldDateAttributes?["centerY"] as? Float ?? TextAttributes().centerY
                            dateAttribute.isHidden = oldDateAttributes?["isHidden"] as? Bool ?? TextAttributes().isHidden
                            
                            tempAttributes.append(titleAttribute)
                            tempAttributes.append(ddayAttribute)
                            tempAttributes.append(dateAttribute)
                            
                            newObject?["title"] = oldTitle?["text"] as? String
                            newObject?["date"] = oldDDay?["date"] as? Date
                            newObject?["isStartCount"] = oldDDay?["isStartCount"] as? Bool


                            newObject?["textAttributes"] = tempAttributes
                        }
                    }
                    if oldSchemaVersion < 18{    //마지막으로 실행된 스키마 버전이 새스키마 버전보다 작은 경우
                        migration.enumerateObjects(ofType: Item.className()){ oldObject, newObject in
                            let date = oldObject?["date"] as? Date
                            newObject?["date"] = date?.getMidnightDate ?? date
                        }
                    }
                },
                objectTypes: [Item.self, Title.self, DDay.self, Background.self, TextAttributes.self])
            
            Realm.Configuration.defaultConfiguration = config
            
            return try Realm(configuration: config)
        }catch{
            NSLog(error.localizedDescription)
            return nil
        }
    }
    
    func readItem() -> [Item]{
        guard let realm = realm else { return [] }
        
        return Array(realm.objects(Item.self))
    }
    
    func editItem(_ data: Item) {
        do{
            if let item = realm?.objects(Item.self).filter(NSPredicate(format: "id = %@", data.id )).first{
                //수정
                try realm?.write{
                    item.title = data.title
                    item.date = data.date
                    item.isStartCount = data.isStartCount
                    item.textAttributes = data.textAttributes
                    item.background = data.background
                    item.memo = data.memo
                }
            }
            else{
                //생성
                try realm?.write{
                    realm?.add(data)
                }
            }
        }catch{
            NSLog(error.localizedDescription)
        }
    }
    
    func deleteItem(_ data: Item) {
        do{
            try realm?.write{
                realm?.delete(data)
            }
        }catch{
            NSLog(error.localizedDescription)
        }
    }
    
    
    //MARK: FileManager Document Image
    func loadImageFromFileManager(imageName: String) -> UIImage? {
        guard let imageUrl = container?.appendingPathComponent(imageName) else {return nil}
        
        return UIImage(contentsOfFile: imageUrl.path)
    }
    
    func saveImageToFileManager(imageName: String, image: UIImage) {
        //경로 설정
        guard let imageUrl = container?.appendingPathComponent(imageName) else {return}
        
        //이미지 압축(image.pngData())
        //??압축할거면 jpegData로~(0~1 사이 값)
        guard let data = image.pngData() else {
            NSLog("압축이 실패했습니다.")
            return
        }
        
        //덮어쓰기 여부 확인
        deleteImageToFileManager(imageName: imageName)
        
        //이미지를 도큐먼트에 저장
        //파일을 저장하는 등의 행위는 조심스러워야하기 때문에 do try catch 문을 사용하는 편임
        do {
            try data.write(to: imageUrl)
            NSLog("이미지 저장완료")
        } catch {
            NSLog("이미지를 저장하지 못했습니다.")
        }
    }
    
    func deleteImageToFileManager(imageName: String) {
        guard let imageUrl = container?.appendingPathComponent(imageName) else {return}
        
        //이미지 경로 여부 확인
        if FileManager.default.fileExists(atPath: imageUrl.path) {
            //이미지가 존재한다면 기존 경로에 있는 이미지 삭제
            do {
                try FileManager.default.removeItem(at: imageUrl)
                NSLog("이미지 삭제 완료")
            } catch {
                NSLog("이미지를 삭제하지 못했습니다.")
            }
        }
    }
    
    //MARK: UserDefaults defaultWidget
    func setDefaultWidget(id: String?){
        UserDefaults(suiteName: appGroupId)?.setValue(id, forKey: "defaultWidget")
    }

    func getDefaultWidget() -> String?{
        return UserDefaults(suiteName: appGroupId)?.string(forKey: "defaultWidget")
    }
}
