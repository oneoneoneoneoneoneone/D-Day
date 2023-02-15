//
//  CollectionViewCell_2x4.swift
//  D-Day
//
//  Created by hana on 2023/01/26.
//

import UIKit

class CollectionViewCell_2x4: UICollectionViewCell{
    let bgView = UIView()
    let d_DayLabel = UILabel()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setAttribute()
        setLayout()
    }
    private func setAttribute(){
        titleLabel.font = .systemFont(ofSize: 24, weight: .light)
        dateLabel.font = .systemFont(ofSize: 18, weight: .light)
        d_DayLabel.font = .systemFont(ofSize: 36, weight: .semibold)
    }
    
    private func setLayout(){
        [bgView, d_DayLabel, titleLabel, dateLabel].forEach{
            addSubview($0)
        }
        
        bgView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.height.equalToSuperview().offset(-80)
            $0.width.equalTo(bgView.snp.height)
        }
        d_DayLabel.snp.makeConstraints{
            $0.bottom.equalTo(titleLabel.snp.top)
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{
            //$0.top.equalTo(d_DayLabel.snp.bottom).offset(10)
            $0.centerY.centerX.equalToSuperview()
        }
        dateLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setData(item: Item){
        d_DayLabel.text = "D\(Util.NumberOfDaysFromDate(from: item.date))"
        titleLabel.text = item.title
        dateLabel.text = Util.StringFromDate(date: item.date)
        
        if item.isCircle{
            bgView.layer.cornerRadius = (self.frame.height-80)/2
            
            if item.isBackgroundColor{
                bgView.backgroundColor = UIColor(hexCode: item.backgroundColor)
                self.backgroundColor = nil
            }
            if item.isBackgroundImage{
                bgView.largeContentImage = UIImage()//item.backgroundImage
                self.largeContentImage = nil
            }
        }
        else{
            bgView.layer.cornerRadius = 0
            
            if item.isBackgroundColor{
                self.backgroundColor = UIColor(hexCode: item.backgroundColor)
                bgView.backgroundColor = nil
            }
            if item.isBackgroundImage{
                self.largeContentImage = UIImage()//item.backgroundImage
                bgView.largeContentImage = nil
            }
        }
    }
}
