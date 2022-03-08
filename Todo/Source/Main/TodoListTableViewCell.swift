//
//  TodoListTableViewCell.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/16.
//

import UIKit
import RealmSwift

class TodoListTableViewCell: UITableViewCell {

    @IBOutlet weak var CheckboxImageView: UIImageView!
    @IBOutlet weak var TodoListLabel: UILabel!
    private let realm = try! Realm()
    var todoLists = [TodoList]()
    var todoList = TodoList()
    var todoListConent = ""

    var todolistDone = false
    var listCount = 0

    override func awakeFromNib() {
        TodoListLabel.font = UIFont(name: "BMJUAOTF", size: 16)
        let checkboxTapGesture = UITapGestureRecognizer(target: self, action: #selector(PressCheckbox))
        CheckboxImageView.addGestureRecognizer(checkboxTapGesture)
        CheckboxImageView.isUserInteractionEnabled = true
        todoListConent = todoList.todoContent
        todolistDone = todoList.checkbox
        
        super.awakeFromNib()
    }
    
    //MARK: boxchecked 반대로 구현됨
    @objc func PressCheckbox() {
        // todoList Done
        if todolistDone {
            todolistDone = false
            CheckboxImageView.image = UIImage(named: "emptybox_image")
            let attributeString = NSMutableAttributedString(string: todoListConent)
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            TodoListLabel.attributedText = attributeString
        }
        
        // todoList Not Done
        else {
            todolistDone = true
            CheckboxImageView.image = UIImage(named: "checkbox_image")
            let strikethroughlineAttribute = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            let strikethroughlineAttributedString = NSAttributedString(string: todoListConent, attributes: strikethroughlineAttribute)
            TodoListLabel.attributedText = strikethroughlineAttributedString
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
