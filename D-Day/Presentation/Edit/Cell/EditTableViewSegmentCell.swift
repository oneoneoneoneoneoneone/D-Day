//
//  EditTableViewSegmentCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit

class EditTableViewSegmentCell: UITableViewCell{
    private var delegate: EditCellDelegate?
    private var cell: EditCellList?
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "반복"
        
        return label
    }()
    
    lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl()
        let noneAction = UIAction(title: "안함", handler: {_ in })
        let dayAction = UIAction(title: "일", handler: {_ in })
        let mountAction = UIAction(title: "월", handler: {_ in })
        let yearAction = UIAction(title: "년", handler: {_ in })
        segment.insertSegment(action: noneAction, at: 0, animated: true)
        segment.insertSegment(action: dayAction, at: 1, animated: true)
        segment.insertSegment(action: mountAction, at: 2, animated: true)
        segment.insertSegment(action: yearAction, at: 3, animated: true)
        
        segment.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        
        return segment
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout(){
        [label, segment].forEach{
            contentView.addSubview($0)
        }
        
        label.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        segment.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bind(delegate: EditCellDelegate, cell: EditCellList){
        self.delegate = delegate
        self.cell = cell
        label.text = cell.text
    }
    
    func setDate(value: Int){
        segment.selectedSegmentIndex = value
        segment.sendActions(for: .valueChanged)
    }
    
    @objc func segmentValueChanged(_ sender: UISegmentedControl){
        delegate?.valueChanged(self.cell!, didChangeValue: sender.selectedSegmentIndex)
    }
}
