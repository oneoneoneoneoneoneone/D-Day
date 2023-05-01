//
//  EditTableViewTitleCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit

class EditTableViewTitleCell: UITableViewCell{
    private var delegate: EditCellDelegate?
    private var cell: EditCellList?
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
                
        return textField
    }()
    
    lazy var colorWell: UIColorWell = {
        let colorWell = UIColorWell()
        colorWell.supportsAlpha = false
        colorWell.addTarget(self, action: #selector(colorWellValueChanged), for: .valueChanged)
        
        return colorWell
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout(){
        [textField, colorWell].forEach{
            contentView.addSubview($0)
        }
        
        textField.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        colorWell.snp.makeConstraints{
            $0.leading.equalTo(textField.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bind(delegate: EditCellDelegate, cell: EditCellList){
        self.delegate = delegate
        self.cell = cell
        textField.placeholder = cell.text
    }
    
    func setDate(text: String, color: String?){
        textField.text = text
        delegate?.valueChanged(self.cell!, didChangeValue: textField.text)
        
        guard let color = color, color != "" else { return }
        
        colorWell.selectedColor = UIColor(hexCode: color)
        colorWell.sendActions(for: .valueChanged)
    }
    
//    @objc func textFieldValueChanged(_ sender: UITextField){
//        delegate?.valueChanged(self.cell!, didChangeValue: sender.text)
//    }
    
    @objc func colorWellValueChanged(_ sender: UIColorWell){
        delegate?.valueChanged(self.cell!, didChangeValue: sender.selectedColor)
    }
}


extension EditTableViewTitleCell: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.valueChanged(self.cell!, didChangeValue: textField.text)
    }
}
