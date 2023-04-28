//
//  EditTableViewDateCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit

class EditTableViewDateCell: UITableViewCell{
    private var delegate: EditCellDelegate?
    private var cell: EditCellList?
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        
        return label
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko")
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
    
    
    private func setLayout(){
        [datePicker].forEach{
            contentView.addSubview($0)
        }
        
        datePicker.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview().inset(10)
//            $0.centerX.centerY.equalToSuperview()
//            $0.height.equalTo(240)
        }
    }
    
    func bind(delegate: EditCellDelegate, cell: EditCellList){
        self.delegate = delegate
        self.cell = cell
        label.text = cell.text
    }
    
    func setDate(date: Date){
        datePicker.date = date
        datePicker.sendActions(for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        delegate?.valueChanged(self.cell!, didChangeValue: sender.date)
    }
}
