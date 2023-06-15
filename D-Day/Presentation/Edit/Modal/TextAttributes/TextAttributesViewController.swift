//
//  TextAttributesViewController.swift
//  D-Day
//
//  Created by hana on 2023/05/23.
//

import UIKit

class TextAttributesViewController: UIViewController{
    private lazy var presenter = TextAttributesPresenter(viewController: self, delegate: delegate, textAttributes: textAttributes)
    private let delegate: TextAttributesDelegate
    
    var textAttributes: [TextAttributes]
    
    private let detailView: DetailView = {
        let detailView = DetailView()
        detailView.setLabelDrag()
        
        return detailView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(TextAttributesCell.self, forCellReuseIdentifier: "TextAttributesCell")
        tableView.register(TextAttributesButtonCell.self, forCellReuseIdentifier: "TextAttributesButtonCell")
        
        tableView.delegate = presenter
        tableView.dataSource = presenter
        
        return tableView
    }()
    
    init(delegate: TextAttributesDelegate, textAttributes: [TextAttributes]){
        self.delegate = delegate
        self.textAttributes = textAttributes
        
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
    
    func setViewData(title: String, date: Date, isStartCount: Bool, background: Background, image: UIImage){
        detailView.setData(title: title, date: date, isStartCount: isStartCount, background: background, image: image)
        detailView.layer.cornerRadius = background.isCircle ? (view.frame.width)/2 : 0
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
    
    func setData(textAttributes: [TextAttributes]) {
        detailView.setData(textAttributes: textAttributes)
    }
    
    func setIsHidden(_ cell: TextType?, value: Bool){
        detailView.setIsHidden(cell, value)
    }
    func setTextColor(_ cell: TextType?, value: String){
        detailView.setTextColor(cell, value)
    }
    
    func resetPosition() {
        detailView.resetPosition()
        detailView.reloadView()
    }
    
    func getTableViewEditCell() -> [UITableViewCell] {
        return tableView.visibleCells.filter{$0.reuseIdentifier == "TextAttributesCell"}
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
