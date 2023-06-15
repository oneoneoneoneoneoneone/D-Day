//
//  EditTableViewPresentButtonCell.swift
//  D-Day
//
//  Created by hana on 2023/05/23.
//

import UIKit
import RealmSwift

class EditTableViewPresentButtonCell: UIEditCell{
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: [])
        button.clipsToBounds = false
        button.configuration = .filled()    //style
        button.configuration?.baseBackgroundColor = .systemGray6
        
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
            
    override func setLayout(){
        [button].forEach{
            contentView.addSubview($0)
        }
        button.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
            $0.height.width.equalToSuperview().inset(10)
        }
    }

    override func bind(delegate: EditCellDelegate, cell: EditCell){
        self.delegate = delegate
        self.cell = cell
        button.setTitle(cell.text, for: [])
    }
    
    override func setData(textAttributes: List<TextAttributes>?) {
        super.setData(textAttributes: textAttributes)
    }
    
    @objc func buttonTap(){
        let viewController = TextAttributesViewController(delegate: self, textAttributes: textAttributes)
        viewController.setViewData(title: title, date: date, isStartCount: isStartCount, background: background, image: image)
        let navigationViewController = UINavigationController(rootViewController: viewController)
        navigationViewController.modalPresentationStyle = .overFullScreen
        
        window?.rootViewController?.presentedViewController?.present(navigationViewController, animated: true)
    }
}

extension EditTableViewPresentButtonCell: TextAttributesDelegate{
    func textAttributesValueChanged(textAttributes: [TextAttributes]) {
        self.textAttributes = textAttributes
                
        delegate?.valueChanged(self.cell, didChangeValue: textAttributes)
    }
}
