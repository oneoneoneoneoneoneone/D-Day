//
//  EditTableViewTitleCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class EditTableViewTitleCell: UITableViewCell{
    let disposeBag = DisposeBag()
    
    let textField = UITextField()
    let button = UIColorWell()//UIButton()
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute(){ 
        textField.placeholder = "제목을 입력하세요."
        
//        button.backgroundColor = .black
        //            let colorPicker = UIColorPickerViewController()
    }
    
    private func setLayout(){
        [textField, button].forEach{
            contentView.addSubview($0)
        }
        
        textField.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        button.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bind(_ item: PublishRelay<String?>, _ color: BehaviorRelay<UIColor?>){
        textField.rx.text
            .bind(to: item)
            .disposed(by: disposeBag)
        
        button.rx.color
            .bind(to: color)
            .disposed(by: disposeBag)
    }
    
    func setPlaceholderText(text: String){
        textField.placeholder = text
    }
    
    func setDate(text: String, color: String){
        textField.insertText(text)
        button.selectedColor = UIColor(hexCode: color)
        button.sendActions(for: .valueChanged)
    }
}

//extension Reactive where Base: UIColorWell{
//    var color: ControlProperty<UIColor?>{
//        value
//    }
//
//    var value: ControlProperty<UIColor?> {
//        return base.rx
//            .controlProperty(
//                editingEvents: UIColorWell.Event.editingDidEnd,
//                getter: { colorWell in
//                    colorWell.selectedColor
//                },
//                setter: { colorWell, value in
//                    // This check is important because setting text value always clears control state
//                    // including marked text selection which is important for proper input
//                    // when IME input method is used.
//                    if colorWell.selectedColor != value {
//                        colorWell.selectedColor = value
//                    }
//                }
//            )
//    }
//}
