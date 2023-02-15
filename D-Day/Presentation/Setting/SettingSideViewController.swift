//
//  SettingSideViewController.swift
//  D-Day
//
//  Created by hana on 2023/02/15.
//

import UIKit
import SideMenu

class SettingSideViewController: UIViewController{
    let menuHeader = ["지원", "알림", "화면", "백업"]
    let menu = [["email 보내기", "리뷰쓰기",], ["알림", "알림시간"], ["위젯 테마"], ["캘린더", "백업", "로그인"]]
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.borderColor = UIColor.label.cgColor
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension SettingSideViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        menu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menu[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") ?? UITableViewHeaderFooterView()
//        let label = UILabel()
//        label.text = meueHeader[section]
//        header.addSubview(label)
        header.textLabel?.text = menuHeader[section]
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default") ?? UITableViewCell(style: .default, reuseIdentifier: "default")
        cell.textLabel?.text = menu[indexPath.section][indexPath.row]
        
        return cell
    }
}
