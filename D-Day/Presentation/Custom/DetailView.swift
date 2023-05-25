//
//  DetailView.swift
//  D-Day
//
//  Created by hana on 2023/05/25.
//

import UIKit

class DetailView: UIView{
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 0
        
        return label
    }()
    private let dDayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 42, weight: .semibold)
        
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setLayout()
    }
    
    func setData(title: Title, dday: DDay, background: Background, image: UIImage){
        titleLabel.text = title.text
        titleLabel.textColor = UIColor(hexCode: title.color)
        dDayLabel.text = Util.numberOfDaysFromDate(isStartCount: dday.isStartCount, from: dday.date)
        dDayLabel.textColor = UIColor(hexCode: title.color)
        dateLabel.text = Util.stringFromDate(date: dday.date)
        
        if background.isColor{
            imageView.backgroundColor = UIColor(hexCode: background.color)
        }
        if background.isImage{
            imageView.image = image
        }
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@ imageView.frame.height = 0.....
//        imageView.layer.cornerRadius = item.isCircle ? (imageView.frame.height)/2 : 0
    }
    
    func setLayout(){
        [topStackView].forEach{
            addSubview($0)
        }
        
        [imageView, titleLabel, dDayLabel, dateLabel].forEach{
            topStackView.addArrangedSubview($0)
        }
        
        topStackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(topStackView).inset(10)
            $0.centerX.equalToSuperview()
        }
        dDayLabel.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
        dateLabel.snp.makeConstraints{
            $0.top.equalTo(dDayLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
    }
}
