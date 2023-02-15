//
//  DetailViewController.swift
//  D-Day
//
//  Created by hana on 2023/01/30.
//

import UIKit
import RxSwift
import NotificationCenter


class DetailViewController: UIViewController{
    let userNotificationCenter = UNUserNotificationCenter.current()
    let disposeBag = DisposeBag()
    var item = Item()
    
    let vStackView = UIStackView()
    let titleLabel = UILabel()
    let dDayLabel = UILabel()
    let dateLabel = UILabel()
    let memoLabel = UILabel()
    
    let hStackView = UIStackView()
    let shareButton = UIButton()
    let deleteButton = UIButton()
    
    let rightEditButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setAttribute()
        setNavigation()
        setLayout()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        item
//    }
    
    private func setNavigation(){
//        navigationItem.backBarButtonItem?.tintColor = .label
        navigationItem.backAction = UIAction(handler: {_ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        navigationItem.rightBarButtonItem = rightEditButton
    }
    
    private func setAttribute(){
        vStackView.axis = .vertical
        vStackView.alignment = .center
        vStackView.distribution = .fillEqually
        vStackView.spacing = 20
        
        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.distribution = .fillEqually
//        vStackView.spacing = 40
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .medium)
        dDayLabel.font = .systemFont(ofSize: 42, weight: .semibold)
        dateLabel.font = .systemFont(ofSize: 14, weight: .light)
        memoLabel.font = .systemFont(ofSize: 14, weight: .light)

        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = .label
        shareButton.rx.tap
            .subscribe{_ in
                self.shareButtonTap()
            }
            .disposed(by: disposeBag)
        
        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.rx.tap
            .subscribe{_ in
                self.deleteButtonTap()
            }
            .disposed(by: disposeBag)
        
        rightEditButton.title = "수정"
        rightEditButton.rx.tap
            .subscribe{_ in
                self.rightEditButtonTap()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setLayout(){
        view.addSubview(vStackView)
        
        [titleLabel, dDayLabel, dateLabel, memoLabel, hStackView].forEach{
            vStackView.addArrangedSubview($0)
        }
        
        [shareButton, deleteButton].forEach{
            hStackView.addArrangedSubview($0)
        }
        
        vStackView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
//        titleLabel.snp.makeConstraints{
//            $0.
//        }
    }
    
    private func setDisplay(){
        titleLabel.text = item.title
        titleLabel.textColor = UIColor(hexCode: item.titleColor)
        dDayLabel.text = "D\(Util.NumberOfDaysFromDate(from: item.date))"
        dateLabel.text = Util.StringFromDate(date: item.date)
        memoLabel.text = item.memo
        vStackView.backgroundColor = UIColor(hexCode: item.backgroundColor)
    }
    
    private func shareButtonTap(){
        var activityItems: [Any] = []
        
        //이미지 + text. ..
        activityItems.append(item.title)
        activityItems.append(Util.StringFromDate(date: item.date))
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        //제거할 공유타입
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact, .openInIBooks]
        present(activityViewController, animated: true)
    }
    
    private func deleteButtonTap(){
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: {_ in
            Repository().delete(data: self.item)
            self.userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [self.item.id.stringValue])
            
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alert, animated: true)
        
    }
    
    private func rightEditButtonTap(){
        let editViewController = EditViewController()
        editViewController.setData(item: self.item)
        editViewController.bind(EditViewModel())
        
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    
    func setData(item: Item){
        self.item = item
        
        setDisplay()
    }
}
