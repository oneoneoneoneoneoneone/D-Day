//
//  CollectionViewCell_2x2_Circle.swift
//  D-Day
//
//  Created by hana on 2023/01/26.
//

import UIKit

class CollectionViewCell_2x2_Circle: UICollectionViewCell{
    let bgView = UIView()
    let d_DayLabel = UILabel()
    let titleLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setAttribute()
        setLayout()
    }
    
    private func setAttribute(){
        bgView.layer.cornerRadius = 55
        
        d_DayLabel.font = .systemFont(ofSize: 36, weight: .light)
//        titleLabel.font = .systemFont(ofSize: 24, weight: .light)
    }
    
    private func setLayout(){
        [bgView, d_DayLabel].forEach{
            addSubview($0)
        }
        
        bgView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview().offset(-80)
            $0.width.equalTo(bgView.snp.height)
        }
        d_DayLabel.snp.makeConstraints{
//            $0.top.equalToSuperview().inset(10)
            $0.top.equalTo(bgView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
//        titleLabel.snp.makeConstraints{
//            $0.top.equalTo(d_DayLabel.snp.bottom)//.offset(10)
//            $0.centerX.equalToSuperview()
//        }
    }
    
    func setData(item: Item){
        d_DayLabel.text = "D\(Util.NumberOfDaysFromDate(from: item.date))"
//        titleLabel.text = item.title
        
        if item.isBackgroundColor{
            bgView.backgroundColor = UIColor(hexCode: item.backgroundColor)
        }
        if item.isBackgroundImage{
            bgView.largeContentImage = UIImage()//item.backgroundImage
        }
    }
}
