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
    private let id: String
    
    private let detailView = DetailView()
    
    private let bottomStackView: UIStackView = {
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
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
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
        button.setTitle(NSLocalizedString("삭제", comment: ""), for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTap), for: .touchUpInside)
        
        return button
    }()
    
    init(id: String) {
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
        let rightEditButton = UIBarButtonItem(title: NSLocalizedString("수정", comment: ""), style: .plain, target: self, action: #selector(rightEditButtonTap))
        navigationItem.rightBarButtonItem = rightEditButton
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationItem.backAction = UIAction(handler: {_ in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func setLayout(){
        [detailView, bottomStackView].forEach{
            view.addSubview($0)
        }
        
        [memoLabel, buttonStackView].forEach{
            bottomStackView.addArrangedSubview($0)
        }
        
        [shareButton, deleteButton].forEach{
            buttonStackView.addArrangedSubview($0)
        }
        
        detailView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.width)
        }
        
        bottomStackView.snp.makeConstraints{
            $0.top.equalTo(detailView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setData(item: Item, image: UIImage?){
        detailView.setData(title: item.title, date: item.date, isStartCount: item.isStartCount, background: item.background, image: image)
        detailView.setData(textAttributes: Array(item.textAttributes))
        detailView.setCornerRadius(item.background?.isCircle == true ? (view.frame.width)/2 : 0)
        detailView.reloadView()
        memoLabel.text = item.memo
    }

    func presentToEditViewController(item: Item) {
        let editViewController = UINavigationController(rootViewController: EditViewController(item: item))
        editViewController.modalPresentationStyle = .fullScreen
        
        present(editViewController, animated: true)
    }
    
    func showDeleteAlertController(){
        let alert = UIAlertController(title: NSLocalizedString("삭제하시겠습니까?", comment: ""), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("삭제", comment: ""), style: .destructive, handler: {_ in
            self.presenter.deleteItem()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("취소", comment: ""), style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    func showShareActivityViewController(title: String, date: String, image: UIImage){
        var activityItems: [Any] = []
        //이미지 + text. ..
        activityItems.append(title)
        activityItems.append(date)
        activityItems.append(image)
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        //terminating with uncaught exception of type NSException
        activityViewController.popoverPresentationController?.barButtonItem = UIBarButtonItem(customView: shareButton)
        
        //제거할 공유타입
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact, .openInIBooks, .saveToCameraRoll]
        
        //복사하기 햇을때 사진만 복사 댐.
        present(activityViewController, animated: true)
    }
    
    ///현재 화면 캡쳐
    func transformToImage() -> UIImage? {
        //비트맵 기반 그래픽 컨텍스트를 만들음
        UIGraphicsBeginImageContextWithOptions(detailView.bounds.size, detailView.isOpaque, 0.0)
        defer{
            UIGraphicsEndImageContext()
        }
        //UIGraphicsBeginImageContextWithOptions.. 변수로 치환한 것도 아닌데.. 어케 이어지는..
        if let context = UIGraphicsGetCurrentContext(){
            detailView.layer.render(in: context)
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
