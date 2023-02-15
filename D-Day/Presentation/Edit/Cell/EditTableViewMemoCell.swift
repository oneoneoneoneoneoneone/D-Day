//
//  EditTableViewMemoCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit
import RxSwift
import RxRelay

class EditTableViewMemoCell: UITableViewCell{
    let disposeBag = DisposeBag()
    
    let label = UILabel()
    let textView = UITextView()
    var textViewPlaceHolder = "메모를 입력해주세요."
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute(){
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.systemBackground.withAlphaComponent(0.7).cgColor
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.font = .systemFont(ofSize: 17)
        textView.text = textViewPlaceHolder
        textView.textColor = .lightGray
        
        textView.delegate = self
    }
    
    private func setLayout(){
        [textView].forEach{
            contentView.addSubview($0)
        }
        
        textView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    func bind(_ item: BehaviorRelay<String?>){
        textView.rx.text
            .bind(to: item)
            .disposed(by: disposeBag)
    }
    
//    func setPlaceholderText(text: String){
//        textViewPlaceHolder = text
//    }
    
    func setDate(text: String){
        if text == "" {
            return
        }
        textView.text = text
        textView.refreshControl?.sendActions(for: .valueChanged)
    }
}

extension EditTableViewMemoCell: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
}
