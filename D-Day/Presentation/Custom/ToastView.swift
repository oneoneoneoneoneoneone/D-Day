//
//  ToastView.swift
//  D-Day
//
//  Created by hana on 2023/03/06.
//

import UIKit
import SnapKit

class ToastView: UIView{
    private let messageLabal: UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.textAlignment = .center
        
        return label
    }()
    
    init(){//message: String){
        super.init(frame: .zero)
        
        self.backgroundColor = .label.withAlphaComponent(0.5)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.tag = 99
        
        setLayout()
//
//        messageLabal.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout(){
        self.addSubview(self.messageLabal)
        
        self.messageLabal.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func showToast(view: UIView, message: String){
        messageLabal.text = message
        
        view.addSubview(self)
        
        self.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.8, options: .curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: {_ in
            self.removeFromSuperview()
        })
    }
    
    func removeToast(view: UIView){
        if let beforeToastView = view.viewWithTag(99){
            beforeToastView.removeFromSuperview()
        }
    }
}
