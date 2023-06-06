//
//  EditTableViewTitleCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit

class EditTableViewTitleCell: UIEditCell{
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
                
        return textField
    }()
    
//    lazy var colorWell: UIColorWell = {
//        let colorWell = UIColorWell()
//        colorWell.supportsAlpha = false
//        colorWell.addTarget(self, action: #selector(colorWellValueChanged), for: .valueChanged)
//
//        return colorWell
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setLayout(){
        [textField].forEach{
            contentView.addSubview($0)
        }
        
        textField.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func bind(delegate: EditCellDelegate, cell: EditCell){
        self.delegate = delegate
        self.cell = cell
        textField.placeholder = cell.text
    }
    
    override func setData(title: String?){
        guard let title = title else { return }
        
        textField.text = title
        delegate?.valueChanged(self.cell, didChangeValue: textField.text)
    }
}


extension EditTableViewTitleCell: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.valueChanged(self.cell, didChangeValue: textField.text)
    }
}
