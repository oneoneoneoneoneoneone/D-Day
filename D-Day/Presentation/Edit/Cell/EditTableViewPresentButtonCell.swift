//
//  EditTableViewPresentButtonCell.swift
//  D-Day
//
//  Created by hana on 2023/05/23.
//

import UIKit
import RealmSwift

class EditTableViewPresentButtonCell: UITableViewCell{
    private var delegate: EditCellDelegate?
    private var cell: EditCellList?
        
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
        
    private func setLayout(){
        [button].forEach{
            contentView.addSubview($0)
        }
        button.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
            $0.height.width.equalToSuperview().inset(10)
        }
    }
    
    func bind(delegate: EditCellDelegate, cell: EditCellList){
        self.delegate = delegate
        self.cell = cell
        button.setTitle(cell.text, for: [])
    }
    
    func setData(textAttributes: List<TextAttributes>, id: String){
        //title x, y, isHidden
        //dday x, y, isHidden
        //date x, y, isHidden
        //image
    }
    
    @objc func buttonTap(){
        let textAttributesViewController = EditTextAttributesViewController()
        window?.rootViewController?.presentedViewController?.present(textAttributesViewController, animated: true)
    }
}
