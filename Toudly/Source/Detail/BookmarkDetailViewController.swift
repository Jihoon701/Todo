//
//  BookmarkDetailViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/04/20.
//

import UIKit
import XLPagerTabStrip
import RealmSwift

class BookmarkDetailViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var bookmarkTableView: UITableView!
    @IBOutlet weak var noticeLabel: UILabel!
    let realm = try! Realm()
    var bookmarkList: Results<TodoList>!
    
    override func viewDidLoad() {
        noticeLabel.setupNoticeLabel(labelText: "북마크가 설정된 투두 리스트가 없습니다.\n알림을 추가해보세요!")
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
        bookmarkList = realm.objects(TodoList.self).filter("bookmark = true").sorted(byKeyPath: "date", ascending: true)
        bookmarkTableView.register( UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        bookmarkDataLayout()
        super.viewDidLoad()
    }
    
    func bookmarkDataLayout() {
        if bookmarkList.count == 0 {
            noticeLabel.isHidden = false
        }
        else {
            noticeLabel.isHidden = true
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "북마크")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(TodoList.self).filter("bookmark = true").count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bookmarkTableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        bookmarkList = realm.objects(TodoList.self).filter("bookmark = true").sorted(byKeyPath: "date", ascending: true)
        cell.selectionStyle = .none
        cell.contentLabel.text = bookmarkList[indexPath.row].todoContent
        cell.dateLabel.text = bookmarkList[indexPath.row].date
        cell.detailCellInit(checkBox: bookmarkList[indexPath.row].checkbox, alarm: bookmarkList[indexPath.row].alarm, alarmTime: bookmarkList[indexPath.row].alarmTime, bookmark: bookmarkList[indexPath.row].bookmark)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return bookmarkTableView.frame.width * 1/6
    }
}
