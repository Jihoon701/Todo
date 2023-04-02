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
        noticeLabel.setupNoticeLabel(labelText: "알람이 설정된 투두 리스트가 없습니다.\n알림을 추가해보세요!")
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
        return IndicatorInfo(title: "알림")
//        return IndicatorInfo(title: "Notification")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(TodoList.self).filter("alarm = true").count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AlarmTableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        cell.configureDetailCell(target: alarmlist[indexPath.row])
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return AlarmTableView.frame.width * 1/6
//    }
}
