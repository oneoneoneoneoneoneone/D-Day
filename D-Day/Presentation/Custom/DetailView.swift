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
        self.clipsToBounds = true
        
        setLayout()
    }
    
    func setTitle(_ data: Title?){
        guard let title = data else {return}
        
        titleLabel.text = title.text
        titleLabel.textColor = UIColor(hexCode: title.color)
    }
    
    func setDday(_ data: DDay?){
        guard let dday = data else {return}
        
        dDayLabel.text = Util.numberOfDaysFromDate(isStartCount: dday.isStartCount, from: dday.date)
        dDayLabel.textColor = titleLabel.textColor
        dateLabel.text = Util.stringFromDate(date: dday.date)
    }
    
    func setBackground(_ data: Background?, image: UIImage?){
        guard let background = data else {return}
        
        if background.isColor{
            imageView.backgroundColor = UIColor(hexCode: background.color)
        }
        if background.isImage{
            imageView.image = image
        }
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
