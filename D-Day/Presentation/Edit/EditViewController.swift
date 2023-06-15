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
        tableView.sectionFooterHeight = .leastNormalMagnitude
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        tableView.register(EditTableViewTitleCell.self, forCellReuseIdentifier: "EditTableViewTitleCell")
        tableView.register(EditTableViewDateCell.self, forCellReuseIdentifier: "EditTableViewDateCell")
        tableView.register(EditTableViewToggleCell.self, forCellReuseIdentifier: "EditTableViewToggleCell")
        tableView.register(EditTableViewColorCell.self, forCellReuseIdentifier: "EditTableViewColorCell")
        tableView.register(EditTableViewImageCell.self, forCellReuseIdentifier: "EditTableViewImageCell")
        tableView.register(EditTableViewMemoCell.self, forCellReuseIdentifier: "EditTableViewMemoCell")
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
        view.backgroundColor = .systemGray6
        
        presenter.viewDidLoad()
    }
    
    @objc func leftCancelButtonTap(){
        presenter.leftCancelButtonTap()
    }
    
    @objc func rightSaveButtonTap(){
        presenter.rightSaveButtonTap()
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
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
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
    
    func getTableViewCell(_ editCell: EditCell?) -> UITableViewCell?{
        return tableView.visibleCells.filter({ $0.reuseIdentifier == editCell?.reuseIdentifier}).first
    }
    
    func viewUp(_ editCell: EditCell?){
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame.size.height -= 250
            
            guard let cell = self.tableView.visibleCells.filter({ $0.reuseIdentifier == editCell?.reuseIdentifier}).first else {return}
            self.tableView.bounds.origin.y += cell.frame.origin.y/2
        })
    }
    
    func viewDown(_ editCell: EditCell?){
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame.size.height += 250
            
            guard let cell = self.tableView.visibleCells.filter({ $0.reuseIdentifier == editCell?.reuseIdentifier}).first else {return}
            self.tableView.bounds.origin.y -= cell.frame.origin.y/2
        })
    }
}
