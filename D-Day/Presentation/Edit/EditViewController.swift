//
//  EditViewController.swift
//  D-Day
//
//  Created by hana on 2023/01/30.
//

import UIKit

class EditViewController: UIViewController{
    private lazy var presenter = EditPresenter(viewController: self, delegate: delegate, item: item)
    private let delegate: EditDelegate
    private var item: Item

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(EditTableViewTitleCell.self, forCellReuseIdentifier: "EditTableViewTitleCell")
        tableView.register(EditTableViewDateCell.self, forCellReuseIdentifier: "EditTableViewDateCell")
        tableView.register(EditTableViewToggleCell.self, forCellReuseIdentifier: "EditTableViewToggleCell")
        tableView.register(EditTableViewSegmentCell.self, forCellReuseIdentifier: "EditTableViewSegmentCell")
        tableView.register(EditTableViewColorCell.self, forCellReuseIdentifier: "EditTableViewColorCell")
        tableView.register(EditTableViewImageCell.self, forCellReuseIdentifier: "EditTableViewImageCell")
        tableView.register(EditTableViewMemoCell.self, forCellReuseIdentifier: "EditTableViewMenoCell")
        tableView.register(EditTableViewPresentButtonCell.self, forCellReuseIdentifier: "EditTableViewPresentButtonCell")
        
        tableView.delegate = presenter
        tableView.dataSource = presenter

        return tableView
    }()
    
    init(delegate: EditDelegate = MainPresenter(viewController: MainViewController()), item: Item = Item(id: "")){
        self.delegate = delegate
        self.item = item
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension EditViewController: EditProtocol{
    func setNavigation(){
        let leftCancelButton = UIBarButtonItem(title: NSLocalizedString("취소", comment: ""), style: .plain, target: self, action: #selector(leftCancelButtonTap))
        let rightSaveButton = UIBarButtonItem(title: NSLocalizedString("저장", comment: ""), style: .plain, target: self, action: #selector(rightSaveButtonTap))

        navigationItem.leftBarButtonItem = leftCancelButton
        navigationItem.rightBarButtonItem = rightSaveButton
    }

    func setLayout(){
        view.backgroundColor = .systemGray6
        view.addSubview(tableView)

        tableView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func showCloseAlertController() {
        let alertController = UIAlertController(title: NSLocalizedString("작성중인 내용이 있습니다. 닫으시겠습니까?", comment: ""), message: nil, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: NSLocalizedString("닫기", comment: ""), style: .destructive){ [weak self] _ in
            self?.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("계속 작성하기", comment: ""), style: .cancel)
        
        [closeAction, cancelAction].forEach{action in
            alertController.addAction(action)
        }
        
        present(alertController, animated: true)
    }
        
    func showToast(message: String) {
        ToastView().removeToast(view: view)
        ToastView().showToast(view: view, message: message)
    }
    
    func dismiss() {
        self.dismiss(animated: true)
    }
    
    func setBgToggle(_ cell: EditCellList){
        if cell == .backgroundColor{
            guard let cell = tableView.visibleCells.filter({ $0.reuseIdentifier == "EditTableViewImageCell"}).first as? EditTableViewImageCell else {return}
            cell.setToggle()
        }
        if cell == .backgroundImage{
            guard let cell = tableView.visibleCells.filter({ $0.reuseIdentifier == "EditTableViewColorCell"}).first as? EditTableViewColorCell else {return}
            cell.setToggle()
        }
    }
}

extension EditViewController{
    @objc func leftCancelButtonTap(){
        presenter.leftCancelButtonTap()
    }
    
    @objc func rightSaveButtonTap(){
        presenter.rightSaveButtonTap()
    }
    
}
