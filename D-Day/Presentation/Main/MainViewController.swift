//
//  MainViewController.swift
//  D-Day
//
//  Created by hana on 2023/01/26.
//

import UIKit
import SnapKit
import SideMenu
import RealmSwift

class MainViewController: UIViewController {
    private lazy var presenter = MainPresenter(viewController: self)

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = presenter
        collectionView.dataSource = presenter
        
        collectionView.register(CollectionViewCell_1x1.self, forCellWithReuseIdentifier: "CollectionViewCell_1x1")
        collectionView.register(CollectionViewCell_2x2.self, forCellWithReuseIdentifier: "CollectionViewCell_2x2")
        collectionView.register(CollectionViewCell_1x4.self, forCellWithReuseIdentifier: "CollectionViewCell_1x4")
        collectionView.register(CollectionViewCell_2x4.self, forCellWithReuseIdentifier: "CollectionViewCell_2x4")
        
        return collectionView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        //, withConfiguration: Image.SymbolConfiguration(pointSize: 28, weight: .regular)), for: .normal)
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.cornerRadius = 25
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        button.addTarget(self, action: #selector(addButtonTap), for: .touchUpInside)
        
        return button
    }()
    
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

//MARK: MainProtocol method
extension MainViewController: MainProtocol{
    func setNavigationBar(){
        let titleLabel = UILabel()
        titleLabel.text = "D-Day"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        let leftTitleButton = UIBarButtonItem(customView: titleLabel)
        
        let rightDisplayButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal",
                           withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)),
            style: .plain,
            target: self,
            action: #selector(rightDisplayButtonTap))
        let rightSortButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down",
                           withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)),
            style: .plain,
            target: self,
            action: #selector(rightSortButtonTap))
        let rightSettingButton = UIBarButtonItem(
            image: UIImage(systemName: "gearshape",
                           withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)),
            style: .plain,
            target: self,
            action: #selector(rightSettingButtonTap))
        
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationBar.backgroundColor = UIColor.systemBackground
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.1
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        self.navigationItem.setLeftBarButton(leftTitleButton, animated: true)
        self.navigationItem.setRightBarButtonItems([rightSettingButton, rightSortButton, rightDisplayButton], animated: true)
    }
    
    func setLayout(){
        [collectionView, addButton].forEach{
            view.addSubview($0)
        }
        
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        addButton.snp.makeConstraints{
            $0.bottom.trailing.equalToSuperview().inset(40)
            $0.width.height.equalTo(50)
        }
    }
    
    func reloadCollectionView(){
        collectionView.reloadData()
    }
    
    func presentToSideMenu(){
        let SetingVC = SettingSideViewController()
        // rootViewController에 SideMenu화면 VC를 삽입
        let sideMenuNav = SideMenuNavigationController(rootViewController: SetingVC)
//        setUpSideMenuNavigationVC(vc: self, menuNavVC: sideMenuNav)
//        let sideMenu = SideMenuManager.default.leftMenuNavigationController!
        present(sideMenuNav, animated: true)
    }
    
    func presentToEditViewController(){
        let editViewController = UINavigationController(rootViewController: EditViewController(delegate: presenter))
        editViewController.modalPresentationStyle = .fullScreen
        
        present(editViewController, animated: true)
    }
    
    func presentToDetailViewController(id: ObjectId) {
        let detailViewController = DetailViewController(id: id)
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
//        self.childViewControllerForPointerLock?.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func showToast(message: String) {
        Util.showToast(view: self.view, message: message)
    }
}

//MARK: @objc method
extension MainViewController{
    @objc func rightDisplayButtonTap(){
        presenter.rightDisplayButtonTap()
    }
    
    @objc func rightSortButtonTap(){
        presenter.rightSortButtonTap()
    }
        
    @objc func rightSettingButtonTap(){
        presenter.rightSettingButtonTap()
    }
    
    @objc func addButtonTap(){
        presenter.addButtonTap()
    }
}

//MARK: enum
extension MainViewController{
    enum DisplayStyle{
        case x11, x22, x14, x24
        
        var id: String{
            switch self{
            case .x11:
                return "CollectionViewCell_1x1"
            case .x22:
                return "CollectionViewCell_2x2"
            case .x14:
                return "CollectionViewCell_1x4"
            case .x24:
                return "CollectionViewCell_2x4"
            }
        }
        
        var title: String{
            switch self{
            case .x11:
                return "1X1"
            case .x22:
                return "2X2"
            case .x14:
                return "1X4"
            case .x24:
                return "2X4"
            }
        }
    }
    
    enum AlertAction{
        case title, dateDesc, dateAsc
        
        var title: String{
            switch self{
            case .title:
                return "제목"
            case .dateDesc:
                return "완료날짜가 가까운"
            case .dateAsc:
                return "완료날짜가 먼"
            }
        }
    }
}
