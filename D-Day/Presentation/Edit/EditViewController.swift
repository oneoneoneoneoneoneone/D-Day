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
    private var item = Item()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(EditTableViewTitleCell.self, forCellReuseIdentifier: "EditTableViewTitleCell")
        tableView.register(EditTableViewDateCell.self, forCellReuseIdentifier: "EditTableViewDateCell")
        tableView.register(EditTableViewToggleCell.self, forCellReuseIdentifier: "EditTableViewToggleCell")
        tableView.register(EditTableViewSegmentCell.self, forCellReuseIdentifier: "EditTableViewSegmentCell")
        tableView.register(EditTableViewColorCell.self, forCellReuseIdentifier: "EditTableViewColorCell")
        tableView.register(EditTableViewImageCell.self, forCellReuseIdentifier: "EditTableViewImageCell")
        tableView.register(EditTableViewMemoCell.self, forCellReuseIdentifier: "EditTableViewMenoCell")

        tableView.delegate = presenter
        tableView.dataSource = presenter

        return tableView
    }()
    
    init(delegate: EditDelegate = MainPresenter(viewController: MainViewController()), item: Item = Item()){
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
        let leftCancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftCancelButtonTap))
        let rightSaveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(rightSaveButtonTap))

        navigationItem.leftBarButtonItem = leftCancelButton
        navigationItem.rightBarButtonItem = rightSaveButton
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.backgroundColor = .systemGray6
    }

    func setLayout(){
        view.addSubview(tableView)

        tableView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func showCloseAlertController() {
        let alertController = UIAlertController(title: "작성중인 내용이 있습니다. 닫으시겠습니까?", message: nil, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "닫기", style: .destructive){ [weak self] _ in
            self?.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
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
