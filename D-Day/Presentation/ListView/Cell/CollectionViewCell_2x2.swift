//
//  CollectionViewCell_2x2.swift
//  D-Day
//
//  Created by hana on 2023/01/26.
//

import UIKit

class CollectionViewCell_2x2: UICollectionViewCell{
    let imageView = UIImageView()
    let d_DayLabel = UILabel()
    let titleLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setAttribute()
        setLayout()
    }
    
    private func setAttribute(){
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        d_DayLabel.font = .systemFont(ofSize: 36, weight: .semibold)
        titleLabel.font = .systemFont(ofSize: 24, weight: .light)
    }
    
    private func setLayout(){
        [imageView, d_DayLabel, titleLabel].forEach{
            addSubview($0)
        }
        
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
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
            imageView.layer.cornerRadius = frame.height/2
        }
        else{
            imageView.layer.cornerRadius = 0
        }
        
        if item.isBackgroundColor{
            imageView.backgroundColor = UIColor(hexCode: item.backgroundColor)
            imageView.image = nil
        }
        if item.isBackgroundImage{
            imageView.image = Repository().loadImageFromDocumentDirectory(imageName: item.id.stringValue)
            imageView.backgroundColor = nil
        }
    }
}
