//
//  TextAttributesSwitchCell.swift
//  D-Day
//
//  Created by hana on 2023/05/26.
//

import UIKit

class TextAttributesSwitchCell: UITableViewCell{
    lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
        
        return toggle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
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
    
//    func bind(delegate: EditCellDelegate, cell: EditCellList){
//        self.delegate = delegate
//        self.cell = cell
//    }
    
    func setData(isOn: Bool){
        toggle.isOn = isOn
    }
    
    @objc func toggleValueChanged(_ sender: UISwitch){
        
    }
}
