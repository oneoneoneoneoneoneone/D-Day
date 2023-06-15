//
//  EditTableViewColorCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit

class EditTableViewColorCell: UIEditCell{
    let label: UILabel = {
        let label = UILabel()
        label.text = "배경색"
        
        return label
    }()
    
    lazy var colorWell: UIColorWell = {
        let colorWell = UIColorWell()
        colorWell.supportsAlpha = false
        colorWell.contentVerticalAlignment = .center
        colorWell.contentHorizontalAlignment = .trailing
        colorWell.addTarget(self, action: #selector(colorWellValueChanged), for: .valueChanged)
        
        return colorWell
    }()
    
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
    
    override func setLayout(){
        [label, toggle, colorWell].forEach{
            contentView.addSubview($0)
        }
        
        label.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        toggle.snp.makeConstraints{
            $0.trailing.equalTo(colorWell.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        colorWell.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(120)
        }
    }
    
    override func bind(delegate: EditCellDelegate, cell: EditCell){
        self.delegate = delegate
        self.cell = cell
        label.text = cell.text
    }
    
    override func setData(backgroundIsColor: Bool?) {
        guard let backgroundIsColor = backgroundIsColor else{ return }
        
        toggle.isOn = backgroundIsColor
    }
    
    override func setData(backgroundColor: String?) {
        guard let backgroundColor = backgroundColor, backgroundColor != "" else { return }
        
        colorWell.selectedColor = UIColor(hexCode: backgroundColor)
    }
    
    func setToggle(){
        toggle.isOn.toggle()
    }
    
    @objc func colorWellValueChanged(_ sender: UIColorWell){
        delegate?.valueChanged(self.cell, didChangeValue: sender.selectedColor?.rgbString)
    }
    
    @objc func toggleValueChanged(_ sender: UISwitch){
        delegate?.valueChanged(self.cell, didChangeValue: sender.isOn)
    }
}
