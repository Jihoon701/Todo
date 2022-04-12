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
        setKeyboardEvent()
        AddTodoListTextField.font = UIFont(name: "BMJUAOTF", size: 14)
        AddTodoListTextField.delegate = self
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        vc.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        print("터터ㅓ터터터")
        sender.cancelsTouchesInView = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        print("터치")
    //        guard let text = AddTodoListTextField.text else {return}
    //
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
    
    func setKeyboardEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillAppear(_ sender: NotificationCenter) {
        print("입력")
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.view.frame.origin.y -= 150
    }
    
    @objc func keyboardWillDisappear(_ sender: NotificationCenter) {
        print("철회")
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.view.frame.origin.y += 150
    }
}
