//
//  EditTableViewDateCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit

class EditTableViewDateCell: UIEditCell{
    let label: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        
        return label
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
//        datePicker.locale = Locale(identifier: "ko")
        datePicker.preferredDatePickerStyle = .wheels
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        return datePicker
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setLayout(){
        [datePicker].forEach{
            contentView.addSubview($0)
        }
        
        datePicker.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func bind(delegate: EditCellDelegate, cell: EditCell){
        self.delegate = delegate
        self.cell = cell
        label.text = cell.text
    }
    
    override func setData(date: Date?){
        guard let date = date else { return }
        
        datePicker.date = date
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        delegate?.valueChanged(self.cell, didChangeValue: sender.date)
    }
}
