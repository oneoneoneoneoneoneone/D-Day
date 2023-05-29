//
//  TextAttributesViewController.swift
//  D-Day
//
//  Created by hana on 2023/05/23.
//

import UIKit

class TextAttributesViewController: UIViewController{
    private lazy var presenter = TextAttributesPresenter(viewController: self, delegate: delegate, id: id, title: itemTitle, dday: dday, background: background)
    private let delegate: TextAttributesDelegate
    private var itemTitle = Title()
    private var dday = DDay()
    private var background = Background()
    private var id = ""
    
    private let detailView: DetailView = {
        let detailView = DetailView()
        detailView.setLabelDrag()
        
        return detailView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(TextAttributesSwitchCell.self, forCellReuseIdentifier: "TextAttributesSwitchCell")
        
        tableView.delegate = presenter
        tableView.dataSource = presenter

        return tableView
    }()
    
    init(delegate: TextAttributesDelegate, id: String, title: Title, dday: DDay, background: Background){
        self.delegate = delegate
        self.id = id
        self.itemTitle = title
        self.dday = dday
        self.background = background
        
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
    
    @objc func rightEditButtonTap(){
        presenter.rightEditButtonTap()
    }
    @objc func leftCencelButtonTap(){
        presenter.leftCencelButtonTap()
    }
}

extension TextAttributesViewController: TextAttributesProtocol{
    func setNavigation(){
        let rightEditButton = UIBarButtonItem(title: NSLocalizedString("확인", comment: ""), style: .plain, target: self, action: #selector(rightEditButtonTap))
        navigationItem.rightBarButtonItem = rightEditButton
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        
        let leftCencelButton = UIBarButtonItem(title: NSLocalizedString("취소", comment: ""), style: .plain, target: self, action: #selector(leftCencelButtonTap))
        navigationItem.leftBarButtonItem = leftCencelButton
        navigationItem.leftBarButtonItem?.tintColor = .systemBlue
        
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
//        navigationItem.backAction = UIAction(handler: {_ in
//            self.navigationController?.popViewController(animated: true)
//        })
    }
    
    func setLayout(){
        [detailView, tableView].forEach{
            view.addSubview($0)
        }
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.width)
        }
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snp.makeConstraints{
            $0.top.equalTo(detailView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setData(title: Title, dday: DDay, backgound: Background, image: UIImage?) {
        detailView.setTitle(itemTitle)
        detailView.setDday(dday)
        detailView.setBackground(background, image: image)
        detailView.layer.cornerRadius = background.isCircle ? (view.frame.width)/2 : 0
    }
    
    func getTitleTextAttributes() -> TextAttributes{
        return detailView.titleTextAttributes
    }
    
    func getDDayTextAttributes() -> TextAttributes{
        return detailView.dDayTextAttributes
    }
    
    func getDateTextAttributes() -> TextAttributes{
        return detailView.dateTextAttributes
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}
