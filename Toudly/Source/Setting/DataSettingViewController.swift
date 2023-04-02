//
//  DataSettingViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/04/26.
//

import UIKit
import RealmSwift

class DataSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var dataSettingTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let dataSettingTitle = ["완료된 투두 데이터 삭제", "진행중인 투두 데이터 삭제", "북마크 투두 데이터 삭제", "전체 투두 데이터 삭제"]
    let realm = try! Realm()
    
    @IBAction func backToSettingVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        titleLabel.setupTitleLabel(text: "데이터 관리")
        dataSettingTableView.delegate = self
        dataSettingTableView.dataSource = self
        dataSettingTableView.register( UINib(nibName: "SettingDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingDetailTableViewCell")
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        super.viewDidLoad()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSettingTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataSettingTableView.dequeueReusableCell(withIdentifier: "SettingDetailTableViewCell", for: indexPath) as! SettingDetailTableViewCell
        cell.titleLabel.text = dataSettingTitle[indexPath.row]
        cell.settingSwitch.isHidden = true
        cell.selectionStyle = .none
        return cell
    }
    
    func deleteSelectedData(messageData: String, filterCondition: String) {
        self.presentAlert(title: "알림", message: "확인 버튼을 누르면 \(messageData) 데이터가 삭제됩니다", isCancelActionIncluded: true) { [self] action in
            try! realm.write {
                realm.delete(realm.objects(TodoList.self).filter(filterCondition))
            }
            self.presentBottomAlert(message: "\(messageData) 투두가 삭제되었습니다")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            deleteSelectedData(messageData: "완료된", filterCondition: "checkbox = true")
        case 1:
            deleteSelectedData(messageData: "진행중인", filterCondition: "checkbox = false")
        case 2:
            deleteSelectedData(messageData: "북마크", filterCondition: "bookmark = true")
        case 3:
            self.presentAlert(title: "알림", message: "확인 버튼을 누르면 전체 데이터가 삭제됩니다", isCancelActionIncluded: true) { [self] action in
                try! realm.write {
                    realm.deleteAll()
                }
                self.presentBottomAlert(message: "모든 투두가 삭제되었습니다")
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSettingTableView.frame.width * 1/8
    }
}
