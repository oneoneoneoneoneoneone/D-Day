//
//  AlertToggleCell.swift
//  D-Day
//
//  Created by hana on 2023/03/16.
//

import UIKit

class AlertToggleCell: UITableViewCell{
    let userDefaultsManager = UserDefaultsManager()
    let repository = Repository()
    let notificationCenter = NotificationCenterManager()
    
    lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
        
        return toggle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
        setDate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(){
        [toggle].forEach{
            contentView.addSubview($0)
        }
        
        toggle.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setDate(){
        let data = userDefaultsManager.getAlertTime()
        toggle.isOn = data.isOn
    }
    
    @objc func toggleValueChanged(_ sender: UISwitch){
        var alertData = userDefaultsManager.getAlertTime()
        alertData.isOn = sender.isOn
        
        userDefaultsManager.setAlertTime(data: alertData)
        
        //알림 저장
        let items = Array(repository.readItem())
        notificationCenter.editNotificationTime(by: items, alertData: alertData)
    }
}
