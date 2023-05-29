//
//  CollectionViewCell_1x4.swift
//  D-Day
//
//  Created by hana on 2023/01/26.
//

import UIKit

class CollectionViewCell_1x4: UICollectionViewCell{
    let imageView = UIImageView()
    let circleView = UIImageView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let d_DayLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setAttribute()
        setLayout()
    }
    private func setAttribute(){
        self.backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        circleView.contentMode = .scaleAspectFill
        circleView.clipsToBounds = true
        
        titleLabel.font = .systemFont(ofSize: 20, weight: .light)
        dateLabel.font = .systemFont(ofSize: 14, weight: .light)
        d_DayLabel.font = .systemFont(ofSize: 24, weight: .semibold)
    }
    
    private func setLayout(){
        [imageView, circleView, titleLabel, dateLabel, d_DayLabel].forEach{
            addSubview($0)
        }
        
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        circleView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.height.equalToSuperview().offset(-35)
            $0.width.equalTo(circleView.snp.height)
        }
        
        titleLabel.snp.makeConstraints{
            $0.bottom.equalTo(circleView.snp.centerY)
            $0.leading.equalTo(circleView.snp.trailing).offset(10)
        }
        
        dateLabel.snp.makeConstraints{
            $0.top.equalTo(circleView.snp.centerY).offset(5)
            $0.leading.equalTo(titleLabel)
        }
        
        d_DayLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    func setData(item: Item){
        d_DayLabel.text = Util.numberOfDaysFromDate(isStartCount: item.dday!.isStartCount, from: item.dday!.date)
        d_DayLabel.textColor = UIColor(hexCode: item.title!.color)
        titleLabel.text = item.title!.text
        titleLabel.textColor = UIColor(hexCode: item.title!.color)
        dateLabel.text = Util.stringFromDate(date: item.dday!.date)
        dateLabel.textColor = UIColor(hexCode: item.title!.color)
                
        let visibleView = item.background!.isCircle ? circleView : imageView
        let hiddenView = visibleView == circleView ? imageView : circleView
        circleView.layer.cornerRadius = visibleView == circleView ? (self.frame.height-35)/2 : 0
        
        visibleView.isHidden = false
        hiddenView.isHidden = true
        
        if item.background!.isColor{
            visibleView.backgroundColor = UIColor(hexCode: item.background!.color)
            visibleView.image = nil
        }
        if item.background!.isImage{
            visibleView.image = Repository().loadImageFromDocumentDirectory(imageName: item.id.stringValue)
            visibleView.backgroundColor = nil
        }
    }
}
