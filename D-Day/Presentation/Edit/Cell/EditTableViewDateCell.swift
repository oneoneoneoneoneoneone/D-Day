//
//  EditTableViewDateCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit
import RxSwift
import RxRelay

class EditTableViewDateCell: UITableViewCell{
    let disposeBag = DisposeBag()
    
    let label = UILabel()
    let datePicker = UIDatePicker()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute(){
        label.text = "날짜"
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
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
    
    func bind(_ item: PublishRelay<Date?>){
        datePicker.rx.date
            .bind(to: item)
            .disposed(by: disposeBag)
    }
    
    func setLabelText(text: String){
        label.text = text
    }
    
    func setDate(date: Date){
        datePicker.date = date
        datePicker.sendActions(for: .valueChanged)
    }
}
