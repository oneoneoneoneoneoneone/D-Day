//
//  AlertTimeCell.swift
//  D-Day
//
//  Created by hana on 2023/03/16.
//

import UIKit

class AlertTimeCell: UITableViewCell{
    let userNotificationCenter = NotificationCenterManager()
    let userDefaultsManager = UserDefaultsManager()
    let repository = Repository()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
//        datePicker.locale = Locale(identifier: "ko")
        datePicker.preferredDatePickerStyle = .automatic
        datePicker.minuteInterval = 30
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        return datePicker
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
        [datePicker].forEach{
            contentView.addSubview($0)
        }
        
        datePicker.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setDate(){
        let data = userDefaultsManager.getAlertTime()
        datePicker.date = data.time
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        var alertData = userDefaultsManager.getAlertTime()
        alertData.time = sender.date
        
        userDefaultsManager.setAlertTime(data: alertData)
        
        //알림 저장
        let items = Array(repository.readItem())
        userNotificationCenter.editNotificationTime(by: items, alertData: alertData)
    }
}
