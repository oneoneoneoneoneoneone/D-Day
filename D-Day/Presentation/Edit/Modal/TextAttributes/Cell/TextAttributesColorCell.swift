//
//  TextAttributesColorCell.swift
//  D-Day
//
//  Created by hana on 2023/05/26.
//

import UIKit

class TextAttributesColorCell: UITableViewCell{
    lazy var colorWell: UIColorWell = {
        let colorWell = UIColorWell()
        colorWell.supportsAlpha = false
        colorWell.contentVerticalAlignment = .center
        colorWell.contentHorizontalAlignment = .trailing
//        colorWell.addTarget(self, action: #selector(colorWellValueChanged), for: .valueChanged)
        
        return colorWell
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(){
        [colorWell].forEach{
            contentView.addSubview($0)
        }
        
        colorWell.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
}
