//
//  EditViewController.swift
//  D-Day
//
//  Created by hana on 2023/01/30.
//

import UIKit
import RxSwift

class EditViewController: UIViewController{
    let disposeBag = DisposeBag()
    final let cellList = CellList.allCases
    //var item = Item()
//    let cellList = [["제목", "날짜", "시작일", "반복"], ["배경색", "배경이미지", "동그랗게"], ["메모"]]
//    final let dataList = ["제목", "날짜", "시작일", "반복"]
//    final let viewList = ["배경색", "배경이미지", "동그랗게"]
//    final let extList = ["메모"]
    var viewModel = EditViewModel()
    var item = Item()
    
    let rightSaveButton = UIBarButtonItem()
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
                
        setAttribute()
        setNavigation()
        setLayout()
    }
    
    private func setNavigation(){
//        navigationController?.navigationBar.isTranslucent = true
        navigationItem.rightBarButtonItem = rightSaveButton
    }
    
    private func setAttribute(){
        rightSaveButton.title = "저장"
//        rightSaveButton.rx.tap
//            .subscribe{_ in
//                self.rightSaveButtonTap()
//            }
//            .disposed(by: disposeBag)
                
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(EditTableViewTitleCell.self, forCellReuseIdentifier: "EditTableViewTitleCell")
        tableView.register(EditTableViewDateCell.self, forCellReuseIdentifier: "EditTableViewDateCell")
        tableView.register(EditTableViewToggleCell.self, forCellReuseIdentifier: "EditTableViewToggleCell")
        tableView.register(EditTableViewSegmentCell.self, forCellReuseIdentifier: "EditTableViewSegmentCell")
        tableView.register(EditTableViewColorCell.self, forCellReuseIdentifier: "EditTableViewColorCell")
        tableView.register(EditTableViewImageCell.self, forCellReuseIdentifier: "EditTableViewImageCell")
        tableView.register(EditTableViewMemoCell.self, forCellReuseIdentifier: "EditTableViewMenoCell")
    }
    
    private func setLayout(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(_ viewModel: EditViewModel){
        self.viewModel = viewModel
        
        viewModel.saveItem
            .emit(to: self.rx.setSave)//.map{a in self.item = a}
            .disposed(by: disposeBag)
            
        viewModel.id
            .accept(item.id)    //relay의 추가는 .accept()로 접근
        
        rightSaveButton.rx.tap
            .bind(to: viewModel.saveButtonTapped)
            .disposed(by: disposeBag)
    }
    
    func setData(item: Item){
        self.item = item
    }
}

extension EditViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        CellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellList.filter{ item in
            item.section.rawValue == section
        }.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row + cellList.filter{ item in
            item.section.rawValue < indexPath.section
        }.count
        
        if cellList[row] == .date{
            return 240
        }
        else if cellList[row] == .backgroundImage{
            return 120
        }
        else if cellList[row] == .memo{
            return 120
        }
        else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row + cellList.filter{ cell in
            cell.section.rawValue < indexPath.section
        }.count
        
        switch cellList[row] {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewTitleCell", for: indexPath) as! EditTableViewTitleCell
            cell.selectionStyle = .none
            cell.setPlaceholderText(text: cellList[row].text)
            cell.bind(viewModel.title, viewModel.titleColor)
            cell.setDate(text: item.title, color: item.titleColor)
            
            return cell
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewDateCell", for: indexPath) as! EditTableViewDateCell
            cell.selectionStyle = .none
            cell.setLabelText(text: cellList[row].text)
            cell.bind(viewModel.date)
            cell.setDate(date: item.date)
            
            return cell
        case .isStartCount:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewToggleCell", for: indexPath) as! EditTableViewToggleCell
            cell.selectionStyle = .none
            cell.setLabelText(text: cellList[row].text)
            cell.bind(viewModel.isStartCount)
            cell.setDate(isOn: item.isStartCount)
            
            return cell
        case .repeatCode:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewSegmentCell", for: indexPath) as! EditTableViewSegmentCell
            cell.selectionStyle = .none
            cell.setLabelText(text: cellList[row].text)
            cell.bind(viewModel.repeatCode)
            cell.setDate(value: item.repeatCode)
            
            return cell
        case .backgroundColor:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewColorCell", for: indexPath) as! EditTableViewColorCell
            cell.selectionStyle = .none
            cell.setLabelText(text: cellList[row].text)
            cell.bind(viewModel.isBgColor, viewModel.bgColor)
            cell.setDate(isOn: item.isBackgroundColor, color: item.backgroundColor)
            
            return cell
        case .backgroundImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewImageCell", for: indexPath) as! EditTableViewImageCell
            cell.selectionStyle = .none
            cell.setLabelText(text: cellList[row].text)
            cell.bind(viewModel.isBgImage)
            cell.setDate(isOn: item.isBackgroundImage, id: item.id.stringValue)
            
            return cell
        case .isCircle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewToggleCell", for: indexPath) as! EditTableViewToggleCell
            cell.selectionStyle = .none
            cell.setLabelText(text: cellList[row].text)
            cell.bind(viewModel.isCircle)
            cell.setDate(isOn: item.isCircle)
            
            return cell
        case .memo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewMenoCell", for: indexPath) as! EditTableViewMemoCell
            cell.selectionStyle = .none
//            cell.setPlaceholderText(text: cellList[row].text)
            cell.bind(viewModel.memo)
            cell.setDate(text: item.memo)
            
            return cell
        }
    }
    
}

extension Reactive where Base: EditViewController{
    var setSave: Binder<Item>{
        return Binder(base) {base, data in
            if (data.title == ""){
                Util.showToast(view: base.view, message: "제목을 입력해주세요")
                return
            }
            
            //저장
            Repository().edit(data: data)
            
            //알림시간 불러오기
            let alertTime = Util.getAlertTime()
            
            //알림 추가
            let userNotificationCenter = UNUserNotificationCenter.current()
            userNotificationCenter.addNotificationRequest(by: data, alertTime: alertTime ?? AlertTime(isOn: true, day: 0, time: Date.now))
                     
            if base.navigationController?.viewControllers.filter({$0 is DetailViewController}).count == 0{
                let detailViewController = DetailViewController()
                detailViewController.setData(item: data)
                base.navigationController?.pushViewController(detailViewController, animated: true)
            }
            else{
                let detailViewController = base.navigationController?.viewControllers.filter{$0 is DetailViewController}.first as! DetailViewController
                detailViewController.setData(item: data)
                base.navigationController?.popToViewController(detailViewController, animated: true)
            }
        }
    }
}

extension EditViewController{
    enum CellType: Int, CaseIterable{
        case main = 0
        case view = 1
        case ext = 2
    }
    
    enum CellList: CaseIterable{
        case title, date, isStartCount, repeatCode, backgroundColor, backgroundImage, isCircle, memo

        var section: CellType{
            switch self{
            case.title, .date, .isStartCount, .repeatCode:
                return .main
            case .backgroundColor, .backgroundImage, .isCircle:
                return .view
            case .memo:
                return .ext
            }
        }
        
        var text: String{
            switch self{
            case .title:
                return "제목을 입력해주세요."
            case .date:
                return "날짜"
            case .isStartCount:
                return "시작일"
            case .repeatCode:
                return "반복"
            case .backgroundColor:
                return "배경색"
            case .backgroundImage:
                return "배경이미지"
            case .isCircle:
                return "동그랗게"
            case .memo:
                return "메모"
            }
        }
    }
}
