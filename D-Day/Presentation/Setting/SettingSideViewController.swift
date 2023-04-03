//
//  SettingSideViewController.swift
//  D-Day
//
//  Created by hana on 2023/02/15.
//

import UIKit
import SideMenu
import MessageUI
import WidgetKit

class SettingSideViewController: UIViewController{
    final let menuHeader = ["알림", "화면", "위젯", "지원"/*, "백업"*/]
    final let menu = [["❗️알림 허용이 꺼진 상태", "디데이 알림", "알림 시간"], ["다크 모드"], ["잠금화면 디데이 선택"], ["email 문의", "리뷰 쓰기"]/*, ["캘린더 가져오기", "백업", "로그인"]*/]
    var isAlarmPermission = true
    
    let repository = Repository()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
//        tableView.rowHeight = 40
        tableView.register(AlertToggleCell.self, forCellReuseIdentifier: "AlertToggleCell")
        tableView.register(AlertTimeCell.self, forCellReuseIdentifier: "AlertTimeCell")
        tableView.register(DarkModeToggleCell.self, forCellReuseIdentifier: "DarkModeToggleCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.borderColor = UIColor.label.cgColor
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        checkAlarmPermission{isHidden in
            self.isAlarmPermission = isHidden
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
    
    private func presentToSendEmail(){
        if MFMailComposeViewController.canSendMail(){
            let controller = MFMailComposeViewController()
            controller.mailComposeDelegate = self
            
            let bodyString = """
                             -------------------
                             
                             Device Model : \(self.getDeviceIdentifier())
                             Device OS : \(UIDevice.current.systemVersion)
                             App Version : \(self.getCurrentVersion())
                             
                             -------------------
                             
                             문의 내용 :
                             
                             """
                    
            controller.setToRecipients(["0ne1_1@naver.com"])
            controller.setSubject("<D-Day>앱 문의")
            controller.setMessageBody(bodyString, isHTML: false)
            
            self.present(controller, animated: true, completion: nil)
        }
        else {
            print("메일 보내기 실패")
            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            
            let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                // 앱스토어로 이동하기(Mail)
                if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            sendMailErrorAlert.addAction(goAppStoreAction)
            sendMailErrorAlert.addAction(cancleAction)
            
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    private func presentToAppStoreReview(){
        if let appstoreURL = URL(string: "https://apps.apple.com/app/id6445882140") {
            var components = URLComponents(url: appstoreURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
            guard let writeReviewURL = components?.url else {
                return
            }
            
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        }
    }
    
    private func presentToWidgetItemSelectView(){
        let alertController = UIAlertController(title: "잠금화면 위젯에 사용할 항목을 선택하세요.", message: nil, preferredStyle: .alert)
        
        repository.readItem().forEach{item in
            let checked = self.repository.getDefaultWidget() == item.id.stringValue
            let action = UIAlertAction(title: "\(item.title) \(checked ? "✔️" : "")", style: .default){ _ in
                self.repository.setDefaultWidget(id: item.id.stringValue)
                Util.widgetReload()
            }
            
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alertController, animated: true)
    }
    
    private func checkAlarmPermission(completionHandler: @escaping((Bool)->Void)){
        UNUserNotificationCenter.current().getNotificationSettings{settings in
            switch settings.authorizationStatus {
            case .authorized:
                completionHandler(true)
            default:
                completionHandler(false)
            }
        }
    }
    
    @objc private func openSttingApp(){
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
}

extension SettingSideViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        menu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menu[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") ?? UITableViewHeaderFooterView()
        header.textLabel?.text = menuHeader[section]
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch menu[indexPath.section][indexPath.row]{
        case "❗️알림 허용이 꺼진 상태":
        if isAlarmPermission {
            return 0
        }
        else {
            return 60
        }
        default: return 40
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch menu[indexPath.section][indexPath.row]{
        case "❗️알림 허용이 꺼진 상태":
            let cell = tableView.dequeueReusableCell(withIdentifier: "default") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "default")
            cell.textLabel?.text = menu[indexPath.section][indexPath.row]
            cell.detailTextLabel?.text = "  설정에서 켜기"
            cell.detailTextLabel?.textColor = .blue
            cell.isHidden = isAlarmPermission
            
            cell.selectionStyle = .none

            return cell
        case "디데이 알림":
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlertToggleCell") ?? AlertToggleCell()
            cell.textLabel?.text = menu[indexPath.section][indexPath.row]
            cell.selectionStyle = .none
            
            return cell
        case "알림 시간":
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlertTimeCell") ?? AlertTimeCell()
            cell.textLabel?.text = menu[indexPath.section][indexPath.row]
            cell.selectionStyle = .none
            
            return cell
        case "다크 모드":
            let cell = tableView.dequeueReusableCell(withIdentifier: "DarkModeToggleCell") ?? DarkModeToggleCell()
            cell.textLabel?.text = menu[indexPath.section][indexPath.row]
            cell.selectionStyle = .none
            
            return cell
        case "잠금화면 디데이 선택":
            let cell = tableView.dequeueReusableCell(withIdentifier: "default") ?? UITableViewCell(style: .default, reuseIdentifier: "default")
            cell.textLabel?.text = menu[indexPath.section][indexPath.row]
            cell.selectionStyle = .none
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "default") ?? UITableViewCell(style: .default, reuseIdentifier: "default")
            cell.textLabel?.text = menu[indexPath.section][indexPath.row]
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch menu[indexPath.section][indexPath.row]{
        case "❗️알림 허용이 꺼진 상태":
            openSttingApp()
        case "잠금화면 디데이 선택":
            presentToWidgetItemSelectView()
        case "email 문의":
            presentToSendEmail()
        case "리뷰 쓰기":
            presentToAppStoreReview()
        default:
            break
        }
    }
}

extension SettingSideViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
