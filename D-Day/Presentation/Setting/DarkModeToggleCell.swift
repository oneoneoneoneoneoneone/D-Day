//
//  DarkModeToggleCell.swift
//  D-Day
//
//  Created by hana on 2023/03/20.
//

import UIKit

class DarkModeToggleCell: UITableViewCell{
    let userDefaultsManager = UserDefaultsManager()
    
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
        toggle.isOn = userDefaultsManager.getIsDarkMode()
    }
    
    @objc func toggleValueChanged(_ sender: UISwitch){
        userDefaultsManager.setIsDarkMode(isDarkMode: sender.isOn)
        
        self.window?.overrideUserInterfaceStyle = UserDefaultsManager().getIsDarkMode() ? .dark : .unspecified
    }
}
