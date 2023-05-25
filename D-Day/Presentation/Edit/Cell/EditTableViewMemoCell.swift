//
//  EditTableViewMemoCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit

class EditTableViewMemoCell: UITableViewCell{
    private var delegate: EditCellDelegate?
    private var cell: EditCellList?
    
    final let textViewPlaceHolder = EditCellList.memo.subText.first
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.systemBackground.withAlphaComponent(0.7).cgColor
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.font = .systemFont(ofSize: 17)
        textView.text = textViewPlaceHolder
        textView.textColor = .lightGray
        
        textView.delegate = self
        
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout(){
        [textView].forEach{
            contentView.addSubview($0)
        }
        
        textView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    func bind(delegate: EditCellDelegate, cell: EditCellList){
        self.delegate = delegate
        self.cell = cell
    }
    
    func setData(text: String?){
        guard let text = text, text != "" else{
            return
        }
        textView.text = text
        delegate?.valueChanged(self.cell, didChangeValue: textView.text)
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
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.valueChanged(self.cell, didChangeValue: textView.text)
    }
}
