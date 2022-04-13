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
    @IBOutlet weak var FireImageView: UIImageView!
    @IBOutlet weak var TodoListLabel: UILabel!
    private let realm = try! Realm()
    var todoLists = [TodoList]()
    var todoList = TodoList()
    var todoListContent = ""
    var emphasisCheck = false
    var alarmCheck = false
    var todoId = 0
    
    var todolistDone = false
    var listCount = 0
    
    override func awakeFromNib() {
        TodoListLabel.font = UIFont(name: "BMJUAOTF", size: 14)
        let checkboxTapGesture = UITapGestureRecognizer(target: self, action: #selector(PressCheckbox))
        CheckboxImageView.addGestureRecognizer(checkboxTapGesture)
        CheckboxImageView.isUserInteractionEnabled = true
        FireImageView.isHidden = true
        todoListContent = todoList.todoContent
        EmphasisImage()
        
        super.awakeFromNib()
    }
    
    //MARK: 왜 CellforRowAt에서는 되고 여기서는 안되는지 확인
    func EmphasisImage() {
        if emphasisCheck {
            FireImageView.isHidden = false
        }
        else {
            FireImageView.isHidden = true
        }
    }
    
    //MARK: boxchecked 반대로 구현됨
    @objc func PressCheckbox() {
        let emphasisColor = #colorLiteral(red: 0.6352941176, green: 0.2156862745, blue: 0.262745098, alpha: 1)
        let checkedEmphasisColor = #colorLiteral(red: 0.2274509804, green: 0.2941176471, blue: 0.3254901961, alpha: 1)
        
        // todoList Done
        if todolistDone {
//            try! realm.write {
//                realm.create(TodoList.self, value: ["id": todoId, "checkbox": todolistDone], update: .modified)
//            }
            todolistDone = false
            CheckboxImageView.image = UIImage(named: "emptybox_image")
            let attributeString = NSMutableAttributedString(string: todoListContent)
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            TodoListLabel.attributedText = attributeString
            FireImageView.tintColor = emphasisColor
            print("111")

        }
        
        // todoList Not Done
        else {
//            try! realm.write {
//                realm.create(TodoList.self, value: ["id": todoId, "checkbox": todolistDone], update: .modified)
//            }
            todolistDone = true
            CheckboxImageView.image = UIImage(named: "checkbox_image")
            let strikethroughlineAttribute = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.thick.rawValue]
            let strikethroughlineAttributedString = NSAttributedString(string: todoListContent, attributes: strikethroughlineAttribute)
            TodoListLabel.attributedText = strikethroughlineAttributedString
            FireImageView.tintColor = checkedEmphasisColor
            print("222")

        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
