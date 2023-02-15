//
//  CollectionViewCell_2x2.swift
//  D-Day
//
//  Created by hana on 2023/01/26.
//

import UIKit

class CollectionViewCell_2x2: UICollectionViewCell{
    let d_DayLabel = UILabel()
    let titleLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setAttribute()
        setLayout()
    }
    
    private func setAttribute(){
        d_DayLabel.font = .systemFont(ofSize: 36, weight: .semibold)
        titleLabel.font = .systemFont(ofSize: 24, weight: .light)
    }
    
    private func setLayout(){
        [d_DayLabel, titleLabel].forEach{
            addSubview($0)
        }
        
        d_DayLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()//.offset(-10)
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(d_DayLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setData(item: Item){
        d_DayLabel.text = "D\(Util.NumberOfDaysFromDate(from: item.date))"
        titleLabel.text = item.title
        
        if item.isCircle{
            self.layer.cornerRadius = frame.height/2
        }
        else{
            self.layer.cornerRadius = 0
        }
        
        if item.isBackgroundColor{
            self.backgroundColor = UIColor(hexCode: item.backgroundColor)
        }
        if item.isBackgroundImage{
            self.largeContentImage = UIImage()// item.backgroundImage
        }
    }
}
