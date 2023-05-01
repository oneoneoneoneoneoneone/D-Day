//
//  SettingViewController.swift
//  D-Day
//
//  Created by hana on 2023/02/15.
//

import UIKit
import SideMenu
import MessageUI

class SettingViewController: UIViewController{
    private lazy var presenter = SettingPresenter(viewController: self)
        
    final let menuHeader = ["알림", "화면", "위젯", "지원"/*, "백업"*/]
    final let menu = [["❗️알림 허용이 꺼진 상태", "디데이 알림", "알림 시간"], ["다크 모드"], ["잠금화면 디데이 선택"], ["Email 문의", "리뷰 쓰기"]/*, ["캘린더 가져오기", "백업", "로그인"]*/]
    var isAlarmPermission = true
    
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
        
        presenter.viewDidLoad()
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        menu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menu[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") ?? UITableViewHeaderFooterView()
        header.textLabel?.text = NSLocalizedString(menuHeader[section], comment: "")
        
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
            cell.textLabel?.text = NSLocalizedString(menu[indexPath.section][indexPath.row], comment: "")
            cell.detailTextLabel?.text = NSLocalizedString("  설정에서 켜기", comment: "")
            cell.detailTextLabel?.textColor = .blue
            cell.isHidden = isAlarmPermission
            
            cell.selectionStyle = .none

            return cell
        case "디데이 알림":
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlertToggleCell") ?? AlertToggleCell()
            cell.textLabel?.text = NSLocalizedString(menu[indexPath.section][indexPath.row], comment: "")
            cell.selectionStyle = .none
            
            return cell
        case "알림 시간":
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlertTimeCell") ?? AlertTimeCell()
            cell.textLabel?.text = NSLocalizedString(menu[indexPath.section][indexPath.row], comment: "")
            cell.selectionStyle = .none
            
            return cell
        case "다크 모드":
            let cell = tableView.dequeueReusableCell(withIdentifier: "DarkModeToggleCell") ?? DarkModeToggleCell()
            cell.textLabel?.text = NSLocalizedString(menu[indexPath.section][indexPath.row], comment: "")
            cell.selectionStyle = .none
            
            return cell
        case "잠금화면 디데이 선택":
            let cell = tableView.dequeueReusableCell(withIdentifier: "default") ?? UITableViewCell(style: .default, reuseIdentifier: "default")
            cell.textLabel?.text = NSLocalizedString(menu[indexPath.section][indexPath.row], comment: "")
            cell.selectionStyle = .none
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "default") ?? UITableViewCell(style: .default, reuseIdentifier: "default")
            cell.textLabel?.text = NSLocalizedString(menu[indexPath.section][indexPath.row], comment: "")
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch menu[indexPath.section][indexPath.row]{
        case "❗️알림 허용이 꺼진 상태":
            presenter.turnOnAlarmCellDidSelect()
        case "잠금화면 디데이 선택":
            presenter.selectLockScreenItemCellDidSelect()
        case "Email 문의":
            presenter.emailInquiryCellDidSelect()
        case "리뷰 쓰기":
            presenter.writeReviewCellDidSelect()
        default:
            break
        }
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension SettingViewController: SettingProtocol{
    func setLayout(){
        view.layer.borderColor = UIColor.label.cgColor
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        presenter.checkAlarmPermission{isHidden in
            self.isAlarmPermission = isHidden
        }
    }
    
    func presentToSendEmail(_ email: String, deviceModel: String, appVersion: String){
        if MFMailComposeViewController.canSendMail(){
            let controller = MFMailComposeViewController()
            controller.mailComposeDelegate = self
            
            let bodyString = """
                             -------------------
                             
                             Device Model : \(deviceModel)
                             Device OS : \(UIDevice.current.systemVersion)
                             App Version : \(appVersion)
                             
                             -------------------
                             
                             \(NSLocalizedString("문의 내용", comment: "")) :
                             
                             """
                    
            controller.setToRecipients([email])
            controller.setSubject("<D-Day>\(NSLocalizedString("앱 문의", comment: ""))")
            controller.setMessageBody(bodyString, isHTML: false)
            
            self.present(controller, animated: true, completion: nil)
        }
        else {
            print("메일 보내기 실패")
            let sendMailErrorAlert = UIAlertController(
                title: NSLocalizedString("메일 전송 실패", comment: ""),
                message: NSLocalizedString("메일을 보내려면 'Mail' 앱이 필요합니다. 앱스토어에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", comment: ""),
                preferredStyle: .alert)
            
            let goAppStoreAction = UIAlertAction(title: NSLocalizedString("앱스토어로 이동하기", comment: ""), style: .default) { _ in
                // 앱스토어로 이동하기(Mail)
                if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            let cancleAction = UIAlertAction(title: NSLocalizedString("취소", comment: ""), style: .destructive, handler: nil)
            sendMailErrorAlert.addAction(goAppStoreAction)
            sendMailErrorAlert.addAction(cancleAction)
            
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    func presentToAppStoreReview(_ appUrl: String){
        if let appstoreURL = URL(string: appUrl) {
            var components = URLComponents(url: appstoreURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
            guard let writeReviewURL = components?.url else {
                return
            }
            
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        }
    }
    
    func presentToWidgetItemSelectView(_ actionElement: [String:String]){
        let alertController = UIAlertController(title: NSLocalizedString("잠금화면 위젯에 보여질 항목을 선택하세요.", comment: ""), message: nil, preferredStyle: .alert)
        
        actionElement.forEach{ action in
            let action = UIAlertAction(title: action.value, style: .default){ [weak self] _ in
                self?.presenter.changeLockScreenItem(id: action.key)
            }
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: NSLocalizedString("취소", comment: ""), style: .cancel))
        
        self.present(alertController, animated: true)
    }

    func openSttingApp(){
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
}
