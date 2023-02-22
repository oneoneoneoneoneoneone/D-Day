//
//  EditTableViewColorCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit
import RxSwift
import RxCocoa

class EditTableViewColorCell: UITableViewCell{
    let disposeBag = DisposeBag()
    
    let label = UILabel()
    let button = UIColorWell()
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
        label.text = "배경색"
    }
    
    private func setLayout(){
        [label, toggle, button].forEach{
            contentView.addSubview($0)
        }
        
        label.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        toggle.snp.makeConstraints{
            $0.trailing.equalTo(button.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        button.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }

    }
    
    func bind(_ item: BehaviorRelay<Bool?>, _ color: BehaviorRelay<UIColor?>){
        toggle.rx.isOn
            .bind(to: item)
            .disposed(by: disposeBag)
        
        button.rx.color
            .bind(to: color)
            .disposed(by: disposeBag)
    }
    
    func setLabelText(text: String){
        label.text = text
    }
    
    func setDate(isOn: Bool, color: String?){
        toggle.isOn = isOn
        toggle.sendActions(for: .valueChanged)
        
        guard let color = color, color != "" else { return }
  
        button.selectedColor = UIColor(hexCode: color)
        button.sendActions(for: .valueChanged)
    }
}

extension Reactive where Base: UIColorWell{
    var color: ControlProperty<UIColor?>{
        value
    }

    var value: ControlProperty<UIColor?> {
        return base.rx
            .controlProperty(
                editingEvents: UIColorWell.Event.valueChanged,
                getter: { colorWell in
                    colorWell.selectedColor
                },
                setter: { colorWell, value in
                    if colorWell.selectedColor != value {
                        colorWell.selectedColor = value
                    }
                }
            )
    }
}
