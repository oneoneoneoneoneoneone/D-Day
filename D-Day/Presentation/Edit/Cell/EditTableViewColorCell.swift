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
    let picker = UIColorPickerViewController()
    
    let label = UILabel()
    let button = UIColorWell()// UIButton()
    
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
        
//        button.backgroundColor = .yellow
//        button.rx.tap
//            .subscribe{_ in
//                self.presentColorPicker()
//            }
//            .disposed(by: disposeBag)
    }
    
    private func setLayout(){
        [label, button].forEach{
            contentView.addSubview($0)
        }
        
        label.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        button.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
//    private func presentColorPicker(){
//        picker.delegate = self
//
//        window?.rootViewController!.present(picker, animated: true, completion: nil)
//    }
    
    func bind(_ item: BehaviorRelay<UIColor?>){
 
//        viewModel.bgColor.bind(to: picker.selectedColor)
//        picker.rx.selectedColor
//            .bind(to: )
//            .disposed(by: disposeBag)
//
        button.rx.color
            .bind(to: item)
            .disposed(by: disposeBag)
//        button.rx.color
//            .bind(to: item)
//            .disposed(by: disposeBag)
        
    }
    
    func setLabelText(text: String){
        label.text = text
    }
    
    func setDate(color: String){
        if color == ""{
            return
        }
        
        button.selectedColor = UIColor(hexCode: color)
        button.sendActions(for: .valueChanged)
    }
}

//extension EditTableViewColorCell: UIColorPickerViewControllerDelegate{
//    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
//        button.backgroundColor = viewController.selectedColor
//    }
//}

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
                    // This check is important because setting text value always clears control state
                    // including marked text selection which is important for proper input
                    // when IME input method is used.
                    if colorWell.selectedColor != value {
                        colorWell.selectedColor = value
                    }
                }
            )
    }
}
