//
//  EditTableViewToggleCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit

class EditTableViewToggleCell: UITableViewCell{
    private var delegate: EditCellDelegate?
    private var cell: EditCellList?
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "시작일"
        
        return label
    }()
   
    lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl()
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
    
    func setLayout(){
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
            $0.width.equalTo(130)
        }
    }
    
    func bind(delegate: EditCellDelegate, cell: EditCellList){
        self.delegate = delegate
        self.cell = cell
        label.text = cell.text
        
        for i in 0..<cell.subText.count{
            segment.insertSegment(withTitle: cell.subText[i], at: i, animated: true)
        }
    }
    
    func setDate(value: Bool){
        segment.selectedSegmentIndex = value ? 1 : 0
        segment.sendActions(for: .valueChanged)
    }
    
    @objc func segmentValueChanged(_ sender: UISegmentedControl){
        delegate?.valueChanged(self.cell!, didChangeValue: sender.selectedSegmentIndex == 1 ? true : false)
    }
}
