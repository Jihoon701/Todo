//
//  EditTodoListBackgroundViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/18.
//

import UIKit

class EditTodoListBackgroundViewController: UIViewController {
    @IBOutlet weak var BackgroundView: UIView!
    var todoListContent = ""
    var todoListId = 0
    var todoListDate = ""
    var todoListAlarmTime = ""
    var todoListBookmark = false
    var todoListAlarm = false
    var selfValue: MainViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(Dismiss))
        BackgroundView.addGestureRecognizer(backgroundTapGesture)
        BackgroundView.isUserInteractionEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embededEditTodo" {
            let containerVC = segue.destination as! EditTodoListViewController
            //MARK: CHECK
            containerVC.editTodoDelegate = selfValue as! EditTodoDelegate
            containerVC.todoContent = todoListContent
            containerVC.todoDate = todoListDate
            containerVC.todoBookmark = todoListBookmark
            containerVC.todoAlarm = todoListAlarm
            containerVC.todoAlarmTime = todoListAlarmTime
            containerVC.todoId = todoListId
        }
    }
    
    @objc func Dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
