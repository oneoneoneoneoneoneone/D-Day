//
//  SettingPresenter.swift
//  D-Day
//
//  Created by hana on 2023/04/27.
//

import UIKit

protocol SettingProtocol{
    func setLayout()
    
    func openSttingApp()
    func presentToWidgetItemSelectView(_ actionElement: [String:String])
    func presentToSendEmail(_ email: String, deviceModel: String, appVersion: String)
    func presentToAppStoreReview(_ appUrl: String)
}

class SettingPresenter{
    private let viewController: SettingProtocol?
    private let repository: RepositoryProtocol?
    
    init(viewController: SettingProtocol?, repository: RepositoryProtocol? = Repository()) {
        self.viewController = viewController
        self.repository = repository
    }
    
    func viewDidLoad(){
        viewController?.setLayout()
    }
    
    func turnOnAlarmCellDidSelect(){
        viewController?.openSttingApp()
    }
    
    ///알림 허용이 꺼진 상태 cell 선택
    func selectLockScreenItemCellDidSelect(){
        var actionElement: [String:String] = [:]
        repository?.readItem().forEach{item in
            let isChecked = repository?.getDefaultWidget() == item.id.stringValue
            
            actionElement.updateValue("\(item.title) \(isChecked ? "✔️" : "")", forKey: item.id.stringValue)
        }
        viewController?.presentToWidgetItemSelectView(actionElement)
    }
    
    ///잠금화면 디데이 선택 cell 선택
    func emailInquiryCellDidSelect(){
        viewController?.presentToSendEmail(AppInfo.devMail.rawValue, deviceModel: getDeviceIdentifier(), appVersion: getCurrentVersion())
    }
    
    ///email 문의 cell 선택
    func writeReviewCellDidSelect(){
        viewController?.presentToAppStoreReview(AppInfo.appUrl.rawValue)
    }
    
    ///리뷰 쓰기 cell 선택
    func changeLockScreenItem(id: String){
        repository?.setDefaultWidget(id: id)
        Util.widgetReload()
    }
    
    ///알람 권한 확인
    func checkAlarmPermission(completionHandler: @escaping((Bool)->Void)){
        UNUserNotificationCenter.current().getNotificationSettings{settings in
            switch settings.authorizationStatus {
            case .authorized:
                completionHandler(true)
            default:
                completionHandler(false)
            }
        }
    }
    
    /// Device Identifier 찾기
    private func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    /// 현재 버전 가져오기
    private func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
}

enum AppInfo: String{
    case appUrl = "https://apps.apple.com/app/id6445882140"
    case devMail = "apps.dev82@gmail.com"
}
