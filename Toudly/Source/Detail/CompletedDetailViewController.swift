//
//  CompletedDetailViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/04/20.
//

import UIKit
import XLPagerTabStrip
import RealmSwift

class CompletedDetailViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var completeTableView: UITableView!
    @IBOutlet weak var noticeLabel: UILabel!
    let realm = try! Realm()
    var completeList: Results<TodoList>!
    
    override func viewDidLoad() {
        noticeLabel.setupNoticeLabel(labelText: "There is no completed todo list\nTry completing a todo list!")
        completeTableView.delegate = self
        completeTableView.dataSource = self
        completeList = realm.objects(TodoList.self).filter("checkbox = true").sorted(byKeyPath: "date", ascending: true)
        completeTableView.register( UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        incompleteDataLayout()
        super.viewDidLoad()
    }
    
    func incompleteDataLayout() {
        if completeList.count == 0 {
            noticeLabel.isHidden = false
        }
        else {
            noticeLabel.isHidden = true
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Completed")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(TodoList.self).filter("checkbox = true").count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = completeTableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        completeList = realm.objects(TodoList.self).filter("checkbox = true").sorted(byKeyPath: "date", ascending: true)
        cell.selectionStyle = .none
        cell.contentLabel.text = completeList[indexPath.row].todoContent
        cell.dateLabel.text = completeList[indexPath.row].date
        cell.detailCellInit(checkBox: completeList[indexPath.row].checkbox, alarm: completeList[indexPath.row].alarm, alarmTime: completeList[indexPath.row].alarmTime, bookmark: completeList[indexPath.row].bookmark)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return completeTableView.frame.width * 1/6
    }
}
