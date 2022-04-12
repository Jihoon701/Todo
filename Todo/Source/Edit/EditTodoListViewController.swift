//
//  EditTodoListViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/17.
//

import UIKit
import RealmSwift
import UserNotifications

protocol DeleteCellDelegate: AnyObject {
    func ReorderDeletedList()
}

class EditTodoListViewController: UIViewController {
    
    weak var deleteDelegate: DeleteCellDelegate?
    var TodoListContentText = ""
    var TodoListId = 0
    var TodoListOrder = 0
    var TodoListCellCount = 0
    
    override func viewDidLoad() {
        TodoListContentTextField.text = TodoListContentText
        TodoListContentTextField.font = UIFont(name: "BMJUAOTF", size: 13)
        self.view.layer.cornerRadius = 15
        EmphasisSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        AlarmSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UNUserNotificationCenter.current().delegate = self
        super.viewDidLoad()
    }
    
    @IBAction func BackToHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SaveEditedTodoList(_ sender: Any) {
        //        let editedTodoList = TodoList()
        //        editedTodoList.todoContent = TodoListContentTextField.text ?? ""
        //        editedTodoList.id = TodoListId
        //
        //        try! realm.write {
        //            realm.add(editedTodoList, update: .modified)
        //        }
        try! realm.write {
            realm.create(TodoList.self, value: ["id": TodoListId, "todoContent": TodoListContentTextField.text ?? ""], update: .modified)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var TodoListContentTextField: UITextField!
    @IBOutlet weak var EmphasisSwitch: UISwitch!
    @IBOutlet weak var AlarmSwitch: UISwitch!
    private let realm = try! Realm()
    
    @IBAction func EmphasisSwitchTapped(_ sender: Any) {
        
    }
    
    @IBAction func AlarmSwitchTapped(_ sender: Any) {
        if AlarmSwitch.isOn {
            //            try! realm.write {
            //                realm.create(TodoList.self, value: ["id": TodoListId, "alarm": false], update: .modified)
            //            }
            try! realm.write {
                realm.create(TodoList.self, value: ["id": TodoListId, "alarm": true], update: .modified)
            }
            requestAuthNoti()
            requestSendNoti()
        }
        else {
            try! realm.write {
                realm.create(TodoList.self, value: ["id": TodoListId, "alarm": false], update: .modified)
            }
            //            try! realm.write {
            //                realm.create(TodoList.self, value: ["id": TodoListId, "alarm": true], update: .modified)
            //            }
            //            requestAuthNoti()
            //            requestSendNoti()
            
        }
        print("하하")
        //        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DeleteTodoList(_ sender: Any) {
        let TodoListToDelete = realm.objects(TodoList.self).filter("id == \(TodoListId)")
        try! realm.write {
            realm.delete(TodoListToDelete)
        }
        print(TodoListCellCount)
        deleteDelegate?.ReorderDeletedList()
        dismiss(animated: true, completion: nil)
    }
    
    func requestAuthNoti() {
        let notiAuthOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        UNUserNotificationCenter.current().requestAuthorization(options: notiAuthOptions) { (success, error) in
            if let error = error {
                print(#function, error)
            }
        }
    }
    
    func requestSendNoti() {
        let notiContent = UNMutableNotificationContent()
        notiContent.title = "TODO 알림!"
        notiContent.body = "아아아아"
        notiContent.badge = 1
        
        var datComp = DateComponents()
        datComp.hour = 7
        datComp.minute = 50
        
        
        //        let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: true)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notiContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            print(#function, error ?? "애ㅐㄴ야ㅗㄹ내먀오")
        }
    }
}

extension EditTodoListViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
