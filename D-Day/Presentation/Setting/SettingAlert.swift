//
//  SettingAlert.swift
//  D-Day
//
//  Created by hana on 2023/02/16.
//

import UIKit
import Foundation

struct AlertTime: Codable{
    let isOn: Bool
    let day: Int
    let time: Date
}

class SettingAlert: UIViewController{
    let userNotificationCenter = UNUserNotificationCenter.current()
//    var data: ((_ alertDay: Int, _ alertDate: Date) -> Void)?
    
    let label = UILabel()
    let isSwitch = UISwitch()
    
    let dayPicker = UIPickerView()
    let timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        label.text = "알림 여부"

        dayPicker.delegate = self
        dayPicker.dataSource = self
                
        timePicker.datePickerMode = .time
        timePicker.locale = Locale(identifier: "ko")
        timePicker.preferredDatePickerStyle = .wheels
        
        [label, isSwitch, dayPicker, timePicker].forEach{
            view.addSubview($0)
        }
        
        label.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.leading.equalToSuperview().inset(10)
        }
        
        isSwitch.snp.makeConstraints{
            $0.top.equalTo(label)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        dayPicker.snp.makeConstraints{
            $0.top.equalTo(label.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(10)
            $0.width.equalTo(100)
        }
        
        timePicker.snp.makeConstraints{
            $0.top.equalTo(dayPicker)
            $0.trailing.equalToSuperview().inset(10)
            $0.width.equalTo(200)
        }
        
        setData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        data!(dayPicker.selectedRow(inComponent: 1), timePicker.date)
        let alertTime = AlertTime(isOn: isSwitch.isOn, day: dayPicker.selectedRow(inComponent: 0), time: timePicker.date)
        
        //알림시간 저장
        Util.setAlertTime(data: alertTime)
        
        //알림 저장
        let items = Array(Repository().read())
        userNotificationCenter.editNotificationTime(by: items, alertTime: alertTime)
    }
    
    func setData(){
        let alertTime = Util.getAlertTime()
        
        isSwitch.isOn = alertTime?.isOn ?? true
        dayPicker.selectRow(alertTime?.day ?? 0, inComponent: 0, animated: false)
        timePicker.date = alertTime?.time ?? Date.now
    }
}

extension SettingAlert: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0{
            return "당일"
        }
        else{
            return "\(row)일 전"
        }
    }
}
