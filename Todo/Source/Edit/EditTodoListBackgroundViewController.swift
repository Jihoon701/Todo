//
//  EditTodoListBackgroundViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/18.
//

import UIKit

protocol EditVCDelegate: AnyObject {
    func DelegateEditVC()
}

class EditTodoListBackgroundViewController: UIViewController {

    @IBOutlet weak var BackgroundView: UIView!
    weak var vcDelegate: EditVCDelegate?
    var TodoListContentBackground = ""
    var TodoListIdBackground = 0
    var TodoListIdStartIndex = 0
    var selfValue: MainViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(Dismiss))
        BackgroundView.addGestureRecognizer(backgroundTapGesture)
        BackgroundView.isUserInteractionEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embededEditTodo" {
            print("프리페어")
            vcDelegate?.DelegateEditVC()
            let containerVC = segue.destination as! EditTodoListViewController
            containerVC.deleteDelegate = selfValue
            containerVC.TodoListContentText = TodoListContentBackground
            containerVC.TodoListId = TodoListIdBackground
        }
    }
    
    @objc func Dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
