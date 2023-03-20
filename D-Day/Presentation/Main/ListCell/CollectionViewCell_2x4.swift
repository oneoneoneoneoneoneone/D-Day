//
//  CollectionViewCell_2x4.swift
//  D-Day
//
//  Created by hana on 2023/01/26.
//

import UIKit

class CollectionViewCell_2x4: UICollectionViewCell{
    let imageView = UIImageView()
    let circleView = UIImageView()
    let d_DayLabel = UILabel()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setAttribute()
        setLayout()
    }
    private func setAttribute(){
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        circleView.contentMode = .scaleAspectFill
        circleView.clipsToBounds = true
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .light)
        dateLabel.font = .systemFont(ofSize: 18, weight: .light)
        d_DayLabel.font = .systemFont(ofSize: 36, weight: .semibold)
    }
    
    private func setLayout(){
        [imageView, circleView, d_DayLabel, titleLabel, dateLabel].forEach{
            addSubview($0)
        }
        
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        circleView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.height.equalToSuperview().offset(-80)
            $0.width.equalTo(circleView.snp.height)
        }
        d_DayLabel.snp.makeConstraints{
            $0.bottom.equalTo(titleLabel.snp.top)
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{
            $0.centerY.centerX.equalToSuperview()
        }
        dateLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setData(item: Item){
        d_DayLabel.text = "D\(Util.NumberOfDaysFromDate(from: item.date))"
        d_DayLabel.textColor = UIColor(hexCode: item.titleColor)
        titleLabel.text = item.title
        titleLabel.textColor = UIColor(hexCode: item.titleColor)
        dateLabel.text = Util.StringFromDate(date: item.date)
        dateLabel.textColor = UIColor(hexCode: item.titleColor)
        
        if item.isCircle{
            circleView.isHidden = false
            imageView.isHidden = true
            
            circleView.layer.cornerRadius = (self.frame.height-80)/2
            
            if item.isBackgroundColor{
                circleView.backgroundColor = UIColor(hexCode: item.backgroundColor)
                circleView.image = nil
            }
            if item.isBackgroundImage{
                circleView.image = Repository().loadImageFromDocumentDirectory(imageName: item.id.stringValue)
                circleView.backgroundColor = nil
            }
        }
        else{
            imageView.isHidden = false
            circleView.isHidden = true
            
            circleView.layer.cornerRadius = 0
            
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
}
