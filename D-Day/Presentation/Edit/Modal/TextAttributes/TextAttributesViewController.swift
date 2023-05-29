//
//  TextAttributesViewController.swift
//  D-Day
//
//  Created by hana on 2023/05/23.
//

import UIKit

class TextAttributesViewController: UIViewController{
    private lazy var presenter = TextAttributesPresenter(viewController: self, id: id, title: itemTitle, dday: dday, background: background)
    private var itemTitle = Title()
    private var dday = DDay()
    private var background = Background()
    private var id = ""
    
    private let detailView = DetailView()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(TextAttributesSwitchCell.self, forCellReuseIdentifier: "TextAttributesSwitchCell")
        
        tableView.delegate = presenter
        tableView.dataSource = presenter

        return tableView
    }()
    
    init(id: String, title: Title, dday: DDay, background: Background){
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
}

extension TextAttributesViewController: TextAttributesProtocol{
    func setLayout(){
        [detailView, tableView].forEach{
            view.addSubview($0)
        }
        
        detailView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.width)
        }
        
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
}
