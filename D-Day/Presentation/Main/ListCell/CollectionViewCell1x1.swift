//
//  CollectionViewCell_1x1.swift
//  D-Day
//
//  Created by hana on 2023/01/26.
//

import UIKit

class CollectionViewCell1x1: UICollectionViewCell {
    let imageView = UIImageView()
    let ddayLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setAttribute()
        setLayout()
    }
    
    private func setAttribute() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        ddayLabel.font = .systemFont(ofSize: 24, weight: .semibold)
//        titleLabel.font = .systemFont(ofSize: 36, weight: .light)
    }
    
    private func setLayout() {
        [imageView, ddayLabel].forEach {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        ddayLabel.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(10)
            $0.centerY.centerX.equalToSuperview()
        }
//        titleLabel.snp.makeConstraints{
//            $0.top.equalTo(d_DayLabel.snp.bottom).offset(10)
//            $0.centerX.equalToSuperview()
//        }
    }
    
    func setData(item: Item){
        ddayLabel.text = Util.numberOfDaysFromDate(isStartCount: item.isStartCount, from: item.date)
        
        guard let ddayAttributes = item.textAttributes[safe: TextType.dday.rawValue] else {return}
        ddayLabel.isHidden = ddayAttributes.isHidden
        ddayLabel.textColor = UIColor(hexCode: ddayAttributes.color)
        
        if item.background!.isCircle{
            imageView.layer.cornerRadius = frame.height/2
        }
        else{
            imageView.layer.cornerRadius = 0
        }
        
        if item.background!.isColor{
            imageView.backgroundColor = UIColor(hexCode: item.background!.color)
            imageView.image = nil
        }
        if item.background!.isImage{
            imageView.image = Repository().loadImageFromFileManager(imageName: item.id.stringValue)
            imageView.backgroundColor = nil
        }
    }
}
