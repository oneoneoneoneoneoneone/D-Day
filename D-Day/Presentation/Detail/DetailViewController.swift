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
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let dDayLabel = UILabel()
    let dateLabel = UILabel()
    let vvStackView = UIStackView()
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
        vStackView.spacing = 10
        
        vvStackView.axis = .vertical
        vvStackView.alignment = .center
        vvStackView.distribution = .fillEqually
        vvStackView.spacing = 20
        
        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.distribution = .fillEqually
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .medium)
        titleLabel.numberOfLines = 0
        dDayLabel.font = .systemFont(ofSize: 42, weight: .semibold)
        dateLabel.font = .systemFont(ofSize: 14, weight: .light)
        memoLabel.font = .systemFont(ofSize: 14, weight: .light)
        memoLabel.numberOfLines = 0

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
        [imageView, vStackView, vvStackView].forEach{
            view.addSubview($0)
        }
        
        [titleLabel, dDayLabel, dateLabel].forEach{
            vStackView.addArrangedSubview($0)
        }
        
        [memoLabel, hStackView].forEach{
            vvStackView.addArrangedSubview($0)
        }
        
        [shareButton, deleteButton].forEach{
            hStackView.addArrangedSubview($0)
        }
        
        vStackView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.width)
        }
        imageView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalTo(vStackView)
        }
        
        vvStackView.snp.makeConstraints{
            $0.top.equalTo(vStackView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setDisplay(){
        titleLabel.text = item.title
        titleLabel.textColor = UIColor(hexCode: item.titleColor)
        dDayLabel.text = "D\(Util.NumberOfDaysFromDate(from: item.date))"
        dateLabel.text = Util.StringFromDate(date: item.date)
        memoLabel.text = item.memo
        
        imageView.layer.cornerRadius = item.isCircle ? (imageView.frame.height)/2 : 0
        if item.isBackgroundColor{
            imageView.isHidden = true
            imageView.backgroundColor = UIColor(hexCode: item.backgroundColor)
        }
        if item.isBackgroundImage{
            imageView.isHidden = false
            imageView.image = Repository().loadImageFromDocumentDirectory(imageName: item.id.stringValue)
        }
    }
    
    ///현재 화면 캡쳐
    private func transformToImage() -> UIImage? {
        //비트맵 기반 그래픽 컨텍스트를 만들음
        UIGraphicsBeginImageContextWithOptions(vStackView.bounds.size, vStackView.isOpaque, 0.0)
        defer{
            UIGraphicsEndImageContext()
        }
        //UIGraphicsBeginImageContextWithOptions.. 변수로 치환한 것도 아닌데.. 어케 이어지는..
        if let context = UIGraphicsGetCurrentContext(){
            vStackView.layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        return nil
    }
    
    private func shareButtonTap(){
        
        let image = transformToImage()
        
        var activityItems: [Any] = []
        
        //이미지 + text. ..
        activityItems.append(item.title)
        activityItems.append(Util.StringFromDate(date: item.date))
        activityItems.append(image)
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        //제거할 공유타입
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact, .openInIBooks, .saveToCameraRoll]
        
        //복사하기 햇을때 사진만 복사 댐.
        
        present(activityViewController, animated: true)
    }
    
    private func deleteButtonTap(){
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: {_ in
            self.userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [self.item.id.stringValue])
            Repository().deleteImageToDocumentDirectory(imageName: self.item.id.stringValue)
            Repository().delete(data: self.item)
            
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
