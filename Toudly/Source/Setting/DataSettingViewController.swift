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
    let dataSettingTitle = ["Delete completed todo data", "Delete in progress todo data", "Delete bookmarked todo data", "Delete all todo data"]
    let realm = try! Realm()
    
    @IBAction func backToSettingVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        titleLabel.setupTitleLabel(text: "Manage Data")
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
        self.presentAlert(title: "Notice", message: "Press OK button to delete \(messageData) data", isCancelActionIncluded: true) { [self] action in
            try! realm.write {
                realm.delete(realm.objects(TodoList.self).filter(filterCondition))
            }
            self.presentBottomAlert(message: "\(messageData) todo deleted")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            deleteSelectedData(messageData: "completed", filterCondition: "checkbox = true")
        case 1:
            deleteSelectedData(messageData: "in progress", filterCondition: "checkbox = false")
        case 2:
            deleteSelectedData(messageData: "bookmarked", filterCondition: "bookmark = true")
        case 3:
            self.presentAlert(title: "Notice", message: "Press OK button to delete all data", isCancelActionIncluded: true) { [self] action in
                try! realm.write {
                    realm.deleteAll()
                }
                self.presentBottomAlert(message: "All todo deleted")
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSettingTableView.frame.width * 1/8
    }
}
