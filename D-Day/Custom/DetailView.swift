//
//  DetailView.swift
//  D-Day
//
//  Created by hana on 2023/05/25.
//

import UIKit

class DetailView: UIView {
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
    
    private var textLabels: [UILabel] = []
    
    private var titleLabelCenterXMultiplier: CGFloat = TextType.title.centerX
    private var titleLabelCenterYMultiplier: CGFloat = TextType.title.centerY
    private var dDayLabelCenterXMultiplier: CGFloat = TextType.dday.centerX
    private var dDayLabelCenterYMultiplier: CGFloat = TextType.dday.centerY
    private var dateLabelCenterXMultiplier: CGFloat = TextType.date.centerX
    private var dateLabelCenterYMultiplier: CGFloat = TextType.date.centerY
    
    var titleTextAttributes: TextAttributes {
        let textAttributes = TextAttributes()
        textAttributes.isHidden = titleLabel.isHidden
        textAttributes.color = titleLabel.textColor.rgbString
        
        guard let window = window else {
            textAttributes.centerX = Float(titleLabelCenterXMultiplier)
            textAttributes.centerY = Float(titleLabelCenterYMultiplier)
            return textAttributes
        }
        let originX = titleLabel.frame.origin.x + titleLabel.frame.size.width/2
        let originY = titleLabel.frame.origin.y + titleLabel.frame.size.height/2
        textAttributes.centerX = Float(originX / (window.bounds.width/2))
        textAttributes.centerY = Float(originY / (window.bounds.width/2))
        
        return textAttributes
    }
    
    var dDayTextAttributes: TextAttributes {
        let textAttributes = TextAttributes()
        textAttributes.isHidden = dDayLabel.isHidden
        textAttributes.color = dDayLabel.textColor.rgbString
        
        guard let window = window else {
            textAttributes.centerX = Float(dDayLabelCenterXMultiplier)
            textAttributes.centerY = Float(dDayLabelCenterYMultiplier)
            return textAttributes
        }
        let originX = dDayLabel.frame.origin.x + dDayLabel.frame.size.width/2
        let originY = dDayLabel.frame.origin.y + dDayLabel.frame.size.height/2
        textAttributes.centerX = Float(originX / (window.bounds.width/2))
        textAttributes.centerY = Float(originY / (window.bounds.width/2))
        
        return textAttributes
    }
    
    var dateTextAttributes: TextAttributes {
        let textAttributes = TextAttributes()
        textAttributes.isHidden = dateLabel.isHidden
        textAttributes.color = dateLabel.textColor.rgbString
        
        guard let window = window else {
            textAttributes.centerX = Float(dateLabelCenterXMultiplier)
            textAttributes.centerY = Float(dateLabelCenterYMultiplier)
            return textAttributes
        }
        let originX = dateLabel.frame.origin.x + dateLabel.frame.size.width/2
        let originY = dateLabel.frame.origin.y + dateLabel.frame.size.height/2
        textAttributes.centerX = Float(originX / (window.bounds.width/2))
        textAttributes.centerY = Float(originY / (window.bounds.width/2))
        
        return textAttributes
    }
    
    init(){
        super.init(frame: .zero)
        self.clipsToBounds = true
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func setData(title: String, date: Date, isStartCount: Bool, background: Background?, image: UIImage?){
        titleLabel.text = title
        dDayLabel.text = Util.numberOfDaysFromDate(isStartCount: isStartCount, from: date)
        dateLabel.text = date.toString
    
        guard let background = background else {return}
        
        if background.isColor{
            imageView.image = nil
            imageView.backgroundColor = UIColor(hexCode: background.color)
        }
        if background.isImage{
            imageView.image = image
        }
    }
    
    func setData(textAttributes: [TextAttributes]){
        guard let titleTextAttributes = textAttributes[safe: TextType.title.rawValue] else {return}
        
        titleLabelCenterXMultiplier = CGFloat(titleTextAttributes.centerX)
        titleLabelCenterYMultiplier = CGFloat(titleTextAttributes.centerY)
        titleLabel.isHidden = titleTextAttributes.isHidden
        titleLabel.textColor = UIColor(hexCode: titleTextAttributes.color)
        
        guard let ddayTextAttributes = textAttributes[safe: TextType.dday.rawValue] else {return}
        
        dDayLabelCenterXMultiplier = CGFloat(ddayTextAttributes.centerX)
        dDayLabelCenterYMultiplier = CGFloat(ddayTextAttributes.centerY)
        dDayLabel.isHidden = ddayTextAttributes.isHidden
        dDayLabel.textColor = UIColor(hexCode: ddayTextAttributes.color)
        
        guard let dateTextAttributes = textAttributes[safe: TextType.date.rawValue] else {return}
        
        dateLabelCenterXMultiplier = CGFloat(dateTextAttributes.centerX)
        dateLabelCenterYMultiplier = CGFloat(dateTextAttributes.centerY)
        dateLabel.isHidden = dateTextAttributes.isHidden
        dateLabel.textColor = UIColor(hexCode: dateTextAttributes.color)
    }
    
    func setIsHidden(_ cell: TextType?, _ isHidden: Bool){
        guard let cell = cell else {return}
        
        textLabels[safe: cell.rawValue]?.isHidden = isHidden
    }
    func setTextColor(_ cell: TextType?, _ color: String){
        guard let cell = cell else {return}
        
        textLabels[safe: cell.rawValue]?.textColor = UIColor(hexCode: color)
    }
    
    func setCornerRadius(_ value: CGFloat){
        layer.cornerRadius = value
    }
    
    func setLabelDrag(){
        titleLabel.setDrag()
        dDayLabel.setDrag()
        dateLabel.setDrag()
        
        textLabels = [titleLabel, dDayLabel, dateLabel]
    }
    
    func resetPosition(){
        titleLabelCenterXMultiplier = TextType.title.centerX
        titleLabelCenterYMultiplier = TextType.title.centerY
        
        dDayLabelCenterXMultiplier = TextType.dday.centerX
        dDayLabelCenterYMultiplier = TextType.dday.centerY
        
        dateLabelCenterXMultiplier = TextType.date.centerX
        dateLabelCenterYMultiplier = TextType.date.centerY
    }
    
    func reloadView(){
        titleLabel.snp.removeConstraints()
        titleLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview().multipliedBy(titleLabelCenterXMultiplier)
            $0.centerY.equalToSuperview().multipliedBy(titleLabelCenterYMultiplier)
        }
        
        dDayLabel.snp.removeConstraints()
        dDayLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview().multipliedBy(dDayLabelCenterXMultiplier)
            $0.centerY.equalToSuperview().multipliedBy(dDayLabelCenterYMultiplier)
        }
        
        dateLabel.snp.removeConstraints()
        dateLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview().multipliedBy(dateLabelCenterXMultiplier)
            $0.centerY.equalToSuperview().multipliedBy(dateLabelCenterYMultiplier)
        }
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
        let touchPointX = location.x - frame.size.width/2
        let touchPointY = location.y - frame.size.height/2
        guard touchPointX > 0, touchPointX < (window?.bounds.width)! - frame.size.width,
              touchPointY > 0, touchPointY < (window?.bounds.width)! - frame.size.height else {
            return
            
        }
        
        self.snp.remakeConstraints{
            $0.leading.equalToSuperview().inset(touchPointX)
            $0.top.equalToSuperview().inset(touchPointY)
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}
