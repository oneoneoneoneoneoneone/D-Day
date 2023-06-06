//
//  TextAttributesButtonCell.swift
//  D-Day
//
//  Created by hana on 2023/06/06.
//
import UIKit

class TextAttributesButtonCell: UITableViewCell{
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: [])
        button.clipsToBounds = false
        button.configuration = .filled()    //style
        button.configuration?.baseBackgroundColor = .systemGray6
        
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        return button
    }()
    
    internal var delegate: DetailViewDelegate?
    internal var cell: TextTypeSection?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(){
        [button].forEach{
            contentView.addSubview($0)
        }
        button.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
            $0.height.width.equalToSuperview().inset(10)
        }
    }
    
    func bind(delegate: DetailViewDelegate?, cell: TextTypeSection?){
        self.delegate = delegate
        self.cell = cell
        button.setTitle(cell?.text, for: .normal)
    }
    
    @objc func buttonTap(){
        delegate?.reset()
    }
}
