//
//  AddTodoListTableViewCell.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/16.
//

import UIKit
import RealmSwift

protocol NewTodoListDelegate: AnyObject {
    func MakeNewTodoListDelegate()
    func RevokeAddCellDelegate()
}

class AddTodoListTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var AddTodoListTextField: UITextField!
    weak var newListDelegate: NewTodoListDelegate?
    private let realm = try! Realm()
    var todoLists = [TodoList]()
    var date = ""
    var order = 0
    var id = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        AddTodoListTextField.font = UIFont(name: "BMJUAOTF", size: 16)
        AddTodoListTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let text = AddTodoListTextField.text else {return}
//        if text != "" {
//            saveToRealm(text)
//        }
//        else {
//            newListDelegate?.RevokeAddCellDelegate()
//        }
//     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = AddTodoListTextField.text else {return}
        if text != "" {
            saveToRealm(text)
        }
        else {
            newListDelegate?.RevokeAddCellDelegate()
        }
    }
    
    func saveToRealm(_ contentText: String) {
        realm.beginWrite()
        let newTodoList = TodoList()
        newTodoList.todoContent = contentText
        newTodoList.date = date
        newTodoList.order = order
        newTodoList.id = id
        realm.add(newTodoList)
        try! realm.commitWrite()
        newListDelegate?.MakeNewTodoListDelegate()
    }
}
