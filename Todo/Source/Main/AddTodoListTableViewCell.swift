//
//  AddTodoListTableViewCell.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/16.
//

import UIKit
import RealmSwift

protocol NewTodoListDelegate: AnyObject {
    func makeNewTodoList()
    func revokeAddCell()
}

class AddTodoListTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var AddTodoListTextField: UITextField!
    weak var newListDelegate: NewTodoListDelegate?
    private let realm = try! Realm()
    var date = ""
    var order = 0
    var id = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // TODO: 데이터 전달 확인
    func initAddCell(date: String, order: Int, id: Int) {
        self.date = date
        self.order = order
        self.id = id
        AddTodoListTextField.text = ""
        AddTodoListTextField.font = .NanumSR(.regular, size: 13)
        AddTodoListTextField.delegate = self
        AddTodoListTextField.returnKeyType = .done
//        print("BECOMEFIRSTRESPONDER", AddTodoListTextField.becomeFirstResponder())

        
        NotificationCenter.default.addObserver(self, selector: #selector(stopAddingCell), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopAddingCell), name: UIApplication.willResignActiveNotification, object: nil)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        newListDelegate?.makeNewTodoList()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = AddTodoListTextField.text
        if text != "" {
            saveToRealm(text!)
        }
        else {
            newListDelegate?.revokeAddCell()
        }
        return true
    }
    
    @objc func stopAddingCell() {
        AddTodoListTextField.text = ""
        textFieldShouldReturn(self.AddTodoListTextField)
    }
}
