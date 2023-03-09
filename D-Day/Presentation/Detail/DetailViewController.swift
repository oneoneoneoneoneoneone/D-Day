//
//  DetailViewController.swift
//  D-Day
//
//  Created by hana on 2023/01/30.
//

import UIKit
import RealmSwift


class DetailViewController: UIViewController{
    private lazy var presenter = DetailPresenter(viewController: self, id: id)
    private let id: ObjectId
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
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
    
    private let vvStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        return stackView
    }()
    private let memoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(shareButtonTap), for: .touchUpInside)
        
        return button
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTap), for: .touchUpInside)
        
        return button
    }()
    
    init(id: ObjectId) {
        self.id = id

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
       
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
}

//MARK: DetailProtocol Method
extension DetailViewController: DetailProtocol{
    func setNavigation(){
        let rightEditButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(rightEditButtonTap))
        
        navigationItem.rightBarButtonItem = rightEditButton
        
        navigationItem.backAction = UIAction(handler: {_ in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func setLayout(){
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
    
    func setData(item: Item, image: UIImage){
        titleLabel.text = item.title
        titleLabel.textColor = UIColor(hexCode: item.titleColor)
        dDayLabel.text = "D\(Util.NumberOfDaysFromDate(from: item.date))"
        dDayLabel.textColor = UIColor(hexCode: item.titleColor)
        dateLabel.text = Util.StringFromDate(date: item.date)
        memoLabel.text = item.memo
        
        imageView.layer.cornerRadius = item.isCircle ? (imageView.frame.height)/2 : 0
        if item.isBackgroundColor{
            imageView.backgroundColor = UIColor(hexCode: item.backgroundColor)
        }
        if item.isBackgroundImage{
            imageView.image = image
        }
    }

    func presentToEditViewController(item: Item) {
        let editViewController = UINavigationController(rootViewController: EditViewController2(item: item))
        editViewController.modalPresentationStyle = .fullScreen
        
        present(editViewController, animated: true)
    }
    
    func showDeleteAlertController(){
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: {_ in
            self.presenter.deleteItem()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    func showShareActivityViewController(title: String, date: String, image: UIImage){
        var activityItems: [Any] = []
        //이미지 + text. ..
        activityItems.append(title)
        activityItems.append(date)
        activityItems.append(image)
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        //제거할 공유타입
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact, .openInIBooks, .saveToCameraRoll]
        
        //복사하기 햇을때 사진만 복사 댐.
        present(activityViewController, animated: true)
    }
    
    ///현재 화면 캡쳐
    func transformToImage() -> UIImage? {
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
}

//MARK: @objc Method
extension DetailViewController{
    @objc func shareButtonTap(){
        presenter.shareButtonTap()
    }
    
    @objc func deleteButtonTap(){
        presenter.deleteButtonTap()
    }
    
    @objc func rightEditButtonTap(){
        presenter.rightEditButtonTap()
    }
}
