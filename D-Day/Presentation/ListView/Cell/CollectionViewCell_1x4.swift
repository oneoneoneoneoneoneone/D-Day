//
//  CollectionViewCell_1x4.swift
//  D-Day
//
//  Created by hana on 2023/01/26.
//

import UIKit

class CollectionViewCell_1x4: UICollectionViewCell{
    let bgView = UIView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let d_DayLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setAttribute()
        setLayout()
    }
    private func setAttribute(){
        titleLabel.font = .systemFont(ofSize: 20, weight: .light)
        dateLabel.font = .systemFont(ofSize: 14, weight: .light)
        d_DayLabel.font = .systemFont(ofSize: 24, weight: .semibold)
    }
    
    private func setLayout(){
        [bgView, titleLabel, dateLabel, d_DayLabel].forEach{
            addSubview($0)
        }
        
        bgView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.height.equalToSuperview().offset(-35)
            $0.width.equalTo(bgView.snp.height)
        }
        titleLabel.snp.makeConstraints{
            $0.bottom.equalTo(bgView.snp.centerY)
            $0.leading.equalTo(bgView.snp.trailing).offset(10)
        }
        dateLabel.snp.makeConstraints{
            $0.top.equalTo(bgView.snp.centerY).offset(5)
            $0.leading.equalTo(titleLabel)
        }
        d_DayLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    func setData(item: Item){
        d_DayLabel.text = "D\(Util.NumberOfDaysFromDate(from: item.date))"
        titleLabel.text = item.title
        dateLabel.text = Util.StringFromDate(date: item.date)
        
        if item.isCircle{
            bgView.layer.cornerRadius = (self.frame.height-35)/2
            
            if item.isBackgroundColor{
                bgView.backgroundColor = UIColor(hexCode: item.backgroundColor)
                self.backgroundColor = nil
            }
            if item.isBackgroundImage{
                bgView.largeContentImage = UIImage()// item.backgroundImage
                self.largeContentImage = nil
            }
        }
        else{
            bgView.layer.cornerRadius = 0
            
            if item.isBackgroundColor{
                self.backgroundColor = UIColor(hexCode: item.backgroundColor)//Util.UIColorFromRGB(item.backgroundColor)
                bgView.backgroundColor = nil
            }
            if item.isBackgroundImage{
                self.largeContentImage = UIImage()// item.backgroundImage
                bgView.largeContentImage = nil
            }
        }
    }
}
