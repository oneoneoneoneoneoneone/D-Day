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
    private let baseView: UIView = {
        let view = UIView()
        
        return view
    }()
    private let titleLabel: DraggableLabel = {
        let label = DraggableLabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 0
        
        return label
    }()
    private let dDayLabel: DraggableLabel = {
        let label = DraggableLabel()
        label.font = .systemFont(ofSize: 42, weight: .semibold)
        
        return label
    }()
    private let dateLabel: DraggableLabel = {
        let label = DraggableLabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        
        return label
    }()
    
    private var titleLabelCenterXMultiplier: CGFloat = 1.0
    private var titleLabelCenterYMultiplier: CGFloat = 0.3
    private var dDayLabelCenterXMultiplier: CGFloat = 1.0
    private var dDayLabelCenterYMultiplier: CGFloat = 1.0
    private var dateLabelCenterXMultiplier: CGFloat = 1.0
    private var dateLabelCenterYMultiplier: CGFloat = 1.7
    
    var titleTextAttributes: TextAttributes {
        get{
            let textAttributes = TextAttributes()
            let x = titleLabel.frame.origin.x + titleLabel.frame.size.width/2
            let y = titleLabel.frame.origin.y + titleLabel.frame.size.height/2
            textAttributes.centerX = Float(x / ((window?.bounds.width)!/2))
            textAttributes.centerY = Float(y / ((window?.bounds.width)!/2))
            textAttributes.isHidden = titleLabel.isHidden
            
            return textAttributes
        }
    }
    
    var dDayTextAttributes: TextAttributes {
        get{
            let textAttributes = TextAttributes()
            let x = dDayLabel.frame.origin.x + dDayLabel.frame.size.width/2
            let y = dDayLabel.frame.origin.y + dDayLabel.frame.size.height/2
            textAttributes.centerX = Float(x / ((window?.bounds.width)!/2))
            textAttributes.centerY = Float(y / ((window?.bounds.width)!/2))
            textAttributes.isHidden = dDayLabel.isHidden
            
            return textAttributes
        }
    }
    
    var dateTextAttributes: TextAttributes {
        get{
            let textAttributes = TextAttributes()
            let x = dateLabel.frame.origin.x + dateLabel.frame.size.width/2
            let y = dateLabel.frame.origin.y + dateLabel.frame.size.height/2
            textAttributes.centerX = Float(x / ((window?.bounds.width)!/2))
            textAttributes.centerY = Float(y / ((window?.bounds.width)!/2))
            textAttributes.isHidden = dateLabel.isHidden
            
            return textAttributes
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        
        setLayout()
    }
    
    private func setLayout(){
        [baseView].forEach{
            addSubview($0)
        }
        
        [imageView, titleLabel, dDayLabel, dateLabel].forEach{
            baseView.addSubview($0)
        }
        
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview().multipliedBy(titleLabelCenterXMultiplier)
            $0.centerY.equalToSuperview().multipliedBy(titleLabelCenterYMultiplier)
        }
        
        dDayLabel.translatesAutoresizingMaskIntoConstraints = false
        dDayLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview().multipliedBy(dDayLabelCenterXMultiplier)
            $0.centerY.equalToSuperview().multipliedBy(dDayLabelCenterYMultiplier)
        }
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview().multipliedBy(dateLabelCenterXMultiplier)
            $0.centerY.equalToSuperview().multipliedBy(dateLabelCenterYMultiplier)
        }
        
    }
    
    func setTitle(_ data: Title?){
        guard let title = data else {return}
        
        titleLabel.text = title.text
        titleLabel.textColor = UIColor(hexCode: title.color)
        
        guard let textAttributes = title.textAttributes else {return}
        
        titleLabelCenterXMultiplier = CGFloat(textAttributes.centerX)
        titleLabelCenterYMultiplier = CGFloat(textAttributes.centerY)
        titleLabel.isHidden = titleLabel.isHidden
    }
    
    func setDday(_ data: DDay?){
        guard let dday = data else {return}
        
        dDayLabel.text = Util.numberOfDaysFromDate(isStartCount: dday.isStartCount, from: dday.date)
        dDayLabel.textColor = titleLabel.textColor
        dateLabel.text = Util.stringFromDate(date: dday.date)
        
        guard let ddayTextAttributes = dday.textAttributes[safe: DDayText.dday.rawValue] else {return}
        
        dDayLabelCenterXMultiplier = CGFloat(ddayTextAttributes.centerX)
        dDayLabelCenterYMultiplier = CGFloat(ddayTextAttributes.centerY)
        dDayLabel.isHidden = ddayTextAttributes.isHidden
        
        guard let dateTextAttributes = dday.textAttributes[safe: DDayText.date.rawValue] else {return}
        
        dateLabelCenterXMultiplier = CGFloat(dateTextAttributes.centerX)
        dateLabelCenterYMultiplier = CGFloat(dateTextAttributes.centerY)
        dateLabel.isHidden = dateTextAttributes.isHidden
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
    
    func setLabelDrag(){
        titleLabel.setDrag()
        dDayLabel.setDrag()
        dateLabel.setDrag()
    }
}


class DraggableLabel: UILabel{
    func setDrag(){
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        isUserInteractionEnabled = true
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: superview) else {return}
        
        //터치포인트를 가운데로
        let x = location.x - frame.size.width/2
        let y = location.y - frame.size.height/2
        guard x > 0, x < (window?.bounds.width)! - frame.size.width,
              y > 0, y < (window?.bounds.width)! - frame.size.height else {
            return
            
        }
          
        frame.origin = CGPoint(x: x, y: y)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("x - ", ((touches.first?.location(in: superview).x)! + frame.size.width/2) / ((window?.bounds.width)!/2))
//        print("y - ", ((touches.first?.location(in: superview).y)! + frame.size.height/2) / ((window?.bounds.width)!/2))
    }
}
