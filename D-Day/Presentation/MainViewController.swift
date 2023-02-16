//
//  MainViewController.swift
//  D-Day
//
//  Created by hana on 2023/01/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SideMenu

class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    let DisplayList = [MainViewController.DisplayStyle.x11, MainViewController.DisplayStyle.x22, MainViewController.DisplayStyle.x14, MainViewController.DisplayStyle.x24]
    let SortList = [MainViewController.AlertAction.title, MainViewController.AlertAction.dateDesc, MainViewController.AlertAction.dateAsc]
    var currentDisplayIndex = 0
    var currentSortIndex = 0
    var items: [Item] = []
    
    let leftTitleButton = UIBarButtonItem()
    
    let rightDisplayButton = UIBarButtonItem()
    let rightSortButton = UIBarButtonItem()
    let rightSettingButton = UIBarButtonItem()
    
    let collectionView = CollectionViewController(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setAttribute()
        setNavigation()
        setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setData()
    }
    
    func setUpSideMenuNavigationVC(vc: MainViewController, menuNavVC: SideMenuNavigationController) {
        menuNavVC.statusBarEndAlpha = 0
        menuNavVC.dismissOnPresent = true
        menuNavVC.dismissOnPush = true
        menuNavVC.enableTapToDismissGesture = true
        menuNavVC.enableSwipeToDismissGesture = true
        menuNavVC.enableSwipeToDismissGesture = true
        menuNavVC.sideMenuDelegate = vc
        menuNavVC.menuWidth = 238
        menuNavVC.presentationStyle = .menuSlideIn
        SideMenuManager.default.leftMenuNavigationController = menuNavVC
        SideMenuManager.default.leftMenuNavigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setAttribute(){
        rightDisplayButton.image = UIImage(systemName: "line.3.horizontal", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular))
        rightDisplayButton.tintColor = .label
        rightSortButton.image = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular))
        rightSortButton.tintColor = .label
        rightSettingButton.image = UIImage(systemName: "gearshape", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular))
        rightSettingButton.tintColor = .label
        
//        let elements = [UIAction(title: "알림여부", subtitle: "서브타이틀", handler: {_ in print("")}),
//                        UIAction(title: "지원", image: UIImage(systemName: "house"), handler: {_ in print("")}),
//                        UIAction(title: "알림여부", handler: {_ in print("")}),
//                        UIAction(title: "알림여부", handler: {_ in print("")}),
//                        UIAction(title: "알림여부", handler: {_ in print("")}),
//                        UIAction(title: "알림여부", handler: {_ in print("")}),]
//
//        rightSettingButton.menu = UIMenu(title: "dd", subtitle: "gg", options: .destructive, children: elements)
        
        
        //
        //        let displayButton = UIButton()
        //        displayButton.setImage(UIImage(systemName: "line.3.horizontal", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .light)), for: .normal)
        //        displayButton.tintColor = .label
        //        displayButton.frame = CGRectMake(0, 0, 25, 25)
        //        let sortButton = UIButton()
        //        sortButton.setImage(UIImage(systemName: "arrow.up.arrow.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .light)), for: .normal)
        //        sortButton.tintColor = .label
        //        sortButton.frame = CGRectMake(0, 0, 25, 25)
        //        let settingButton = UIButton()
        //        settingButton.setImage(UIImage(systemName: "gearshape", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .light)), for: .normal)
        //        settingButton.tintColor = .label
        //        settingButton.frame = CGRectMake(0, 0, 25, 25)
        //
        //        rightDisplayButton.customView = displayButton
        //        rightSortButton.customView = sortButton
        //        rightSettingButton.customView = settingButton
        
        let titleLabel = UILabel()
        titleLabel.text = "D-Day"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        leftTitleButton.customView = titleLabel
        
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)//, withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)), for: .normal)
        addButton.layer.backgroundColor = UIColor.systemBackground.cgColor
        addButton.layer.cornerRadius = 25
        addButton.layer.shadowOpacity = 0.1
        addButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        
        rightDisplayButton.rx.tap
            .subscribe{_ in
                self.rightDisplayButtonTap()
            }
            .disposed(by: disposeBag)
        
        rightSortButton.rx.tap
            .subscribe{_ in
                self.rightSortButtonTap()
            }
            .disposed(by: disposeBag)
        
        rightSettingButton.rx.tap
            .subscribe{_ in
                self.rightSettingButtonTap()
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .subscribe{_ in
                self.addButtonTap()
            }
            .disposed(by: disposeBag)
    }
    
    private func setNavigation(){
//        self.navigationController?.navigationBar.topItem?.title = "dday"
        self.navigationController?.navigationBar.backgroundColor = UIColor.systemBackground
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.1
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        self.navigationItem.setRightBarButtonItems([rightSettingButton, rightSortButton, rightDisplayButton], animated: false)
        self.navigationItem.setLeftBarButton(leftTitleButton, animated: false)
    }
    
    private func setLayout(){
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
    
    private func setData(){
        self.items = Array(Repository().read())

        setSort()
//        setDisplay()
    }
    
    private func setSort(){
        switch SortList[currentSortIndex]{
        case .title:
            items = items.sorted { $0.title < $1.title }
        case .dateAsc:
            items = items.sorted { $0.date > $1.date }
        case .dateDesc:
            items = items.sorted { $0.date < $1.date }
        }
        
        collectionView.bind(items)
    }
    
    private func setDisplay(){
        collectionView.setDisplayStyle(style: DisplayList[currentDisplayIndex])
    }
    
    
    private func rightDisplayButtonTap(){
        self.currentDisplayIndex = (self.currentDisplayIndex + 1) % DisplayList.count
        
        self.setDisplay()
        
        Util.showToast(view: self.view, message: "\(DisplayList[currentDisplayIndex].title)로 보여집니다.")
    }
    
    private func rightSortButtonTap(){
        self.currentSortIndex = (currentSortIndex + 1) % SortList.count
        
        self.setSort()
        
        Util.showToast(view: self.view, message: "\(SortList[currentSortIndex].title)순으로 정렬됩니다.")
    }
    private func rightSettingButtonTap(){
        let SetingVC = SettingSideViewController()
        let sideMenuNav = SideMenuNavigationController(rootViewController: SetingVC) // rootViewController에는 SideMenu화면 VC를 삽입
//        setUpSideMenuNavigationVC(vc: self, menuNavVC: sideMenuNav)
        
//        let sideMenu = SideMenuManager.default.leftMenuNavigationController!
        present(sideMenuNav, animated: true)
    }
    
    private func addButtonTap(){
        let editViewController = EditViewController()
        editViewController.bind(EditViewModel())
        self.navigationController?.pushViewController(editViewController, animated: true)
    }
}


//Alert 당최.. 먼소린지 =,=
extension MainViewController{
    //typealias 타입의 별칭
    typealias Alert = (title: String?, message: String?, actions: [AlertAction], style: UIAlertController.Style)
    
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



extension MainViewController: SideMenuNavigationControllerDelegate {

    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
    }

    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {

    }

    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
    }

    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {

    }
}
