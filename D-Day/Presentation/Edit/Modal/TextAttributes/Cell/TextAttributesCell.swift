//
//  TextAttributesCell.swift
//  D-Day
//
//  Created by hana on 2023/06/06.
//
import UIKit

class TextAttributesCell: UITableViewCell{
    let label: UILabel = {
        let label = UILabel()
        label.text = "제목"
        
        return label
    }()
   
    lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
        
        return toggle
    }()
    
    lazy var colorWell: UIColorWell = {
        let colorWell = UIColorWell()
        colorWell.supportsAlpha = false
        colorWell.addTarget(self, action: #selector(colorWellValueChanged), for: .valueChanged)
        
        return colorWell
    }()
    
    internal var delegate: DetailViewDelegate?
    internal var cell: TextType?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(){
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
        }
    }
    
    func bind(delegate: DetailViewDelegate?, cell: TextType?){
        self.delegate = delegate
        self.cell = cell
        label.text = cell?.text
    }
    
    func setData(color: String?) {
        guard let color = color, color != "" else { return }
        
        colorWell.selectedColor = UIColor(hexCode: color)
        colorWell.sendActions(for: .valueChanged)
    }
    
    func setData(isHidden: Bool?){
        guard let isHidden = isHidden else { return }
        
        toggle.isOn = isHidden == false
        toggle.sendActions(for: .valueChanged)
    }
    
    @objc func toggleValueChanged(_ sender: UISwitch){
        delegate?.valueChanged(cell, didChangeValue: sender.isOn == false)
    }
    @objc func colorWellValueChanged(_ sender: UIColorWell){
        delegate?.valueChanged(cell, didChangeValue: sender.selectedColor?.rgbString)
    }
}
