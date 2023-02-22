//
//  EditTableViewToggleCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit
import RxSwift
import RxRelay

class EditTableViewToggleCell: UITableViewCell{
//    let data: ((_ isOn: Bool) -> Void)?
    let disposeBag = DisposeBag()
    
    let label = UILabel()
    let toggle = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute(){
        label.text = "시작일"
        }
    
    private func setLayout(){
        [label, toggle].forEach{
            contentView.addSubview($0)
        }
        
        label.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        toggle.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bind(_ item: BehaviorRelay<Bool?>){
        toggle.rx.isOn
            .bind(to: item)
            .disposed(by: disposeBag)
    }
    
    func setLabelText(text: String){
        label.text = text
    }
    
    func setDate(isOn: Bool){
        toggle.isOn = isOn
        toggle.sendActions(for: .valueChanged)
    }
}
