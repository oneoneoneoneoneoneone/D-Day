//
//  EditTableViewSegmentCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit
import RxSwift
import RxRelay

class EditTableViewSegmentCell: UITableViewCell{
    let disposeBag = DisposeBag()
    
    let label = UILabel()
    let segment = UISegmentedControl()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setAttribute(){
        label.text = "반복"
        
        let noneAction = UIAction(title: "안함", handler: {_ in })
        let dayAction = UIAction(title: "일", handler: {_ in })
        let mountAction = UIAction(title: "월", handler: {_ in })
        let yearAction = UIAction(title: "년", handler: {_ in })
        segment.insertSegment(action: noneAction, at: 0, animated: true)
        segment.insertSegment(action: dayAction, at: 1, animated: true)
        segment.insertSegment(action: mountAction, at: 2, animated: true)
        segment.insertSegment(action: yearAction, at: 3, animated: true)
    }
    
    private func setLayout(){
        [label, segment].forEach{
            contentView.addSubview($0)
        }
        
        label.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        segment.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bind(_ item: BehaviorRelay<Int?>){
        segment.rx.value
            .bind(to: item)
            .disposed(by: disposeBag)
    }
    
    func setLabelText(text: String){
        label.text = text
    }
    
    func setDate(value: Int){
        segment.selectedSegmentIndex = value
        segment.sendActions(for: .valueChanged)
    }
}
