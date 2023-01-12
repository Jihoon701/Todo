//
//  AlarmDetailViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/04/19.
//

import UIKit
import XLPagerTabStrip
import RealmSwift

class AlarmDetailViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var AlarmTableView: UITableView!
    let realm = try! Realm()
    var alarmlist: Results<TodoList>!
    
    override func viewDidLoad() {
        noticeLabel.setupNoticeLabel(labelText: "There are no todo lists with alarm set\nTry adding notifications!")
        AlarmTableView.delegate = self
        AlarmTableView.dataSource = self
        alarmlist = realm.objects(TodoList.self).filter("alarm = true").sorted(byKeyPath: "date", ascending: true)
        AlarmTableView.register( UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        alarmDataLayout()
        super.viewDidLoad()
    }
    
    func alarmDataLayout() {
        if alarmlist.count == 0 {
            noticeLabel.isHidden = false
        }
        else {
            noticeLabel.isHidden = true
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Notification")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(TodoList.self).filter("alarm = true").count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AlarmTableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        alarmlist = realm.objects(TodoList.self).filter("alarm = true").sorted(byKeyPath: "date", ascending: true)
        cell.selectionStyle = .none
        cell.contentLabel.text = alarmlist[indexPath.row].todoContent
        cell.dateLabel.text = alarmlist[indexPath.row].date
        cell.detailCellInit(checkBox: alarmlist[indexPath.row].checkbox, alarm: alarmlist[indexPath.row].alarm, alarmTime: alarmlist[indexPath.row].alarmTime, bookmark: alarmlist[indexPath.row].bookmark)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AlarmTableView.frame.width * 1/6
    }
}
