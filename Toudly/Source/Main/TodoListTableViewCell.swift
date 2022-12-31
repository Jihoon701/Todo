//
//  TodoListTableViewCell.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/16.
//

import UIKit
import RealmSwift

class TodoListTableViewCell: UITableViewCell {
    @IBOutlet weak var checkboxImage: UIImageView!
    @IBOutlet weak var bookmarkImage: UIImageView!
    @IBOutlet weak var alarmImage: UIImageView!
    @IBOutlet weak var todoListLabel: UILabel!
    private let realm = try! Realm()
    var todoListContent = ""
    var todoId = 0
    var bookmarkCheck = false
    var todolistDone = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initTodoCell(todolistDone: Bool, todoListContent: String, bookmarkCheck: Bool, alarmCheck: Bool, todoId: Int) {
        self.todolistDone = todolistDone
        self.todoListContent = todoListContent
        self.bookmarkCheck = bookmarkCheck
        self.todoId = todoId
        self.selectionStyle = .none
        let checkboxTapGesture = UITapGestureRecognizer(target: self, action: #selector(PressCheckbox))
        checkboxImage.addGestureRecognizer(checkboxTapGesture)
        checkboxImage.isUserInteractionEnabled = true
        todoListLabel.font = .NanumSR(.regular, size: 13)
        
        bookmarkImage.isHidden = !bookmarkCheck
        alarmImage.isHidden = !alarmCheck
        
        if todolistDone {
            strikeThroughTodoList()
        }
        else {
            originalTodoList()
        }
    }
    
    @objc func PressCheckbox(todoListDone: Bool) {
        if todolistDone {
            updateRealmCheckbox(id: todoId, checkbox: false)
            originalTodoList()
        }
        else {
            updateRealmCheckbox(id: todoId, checkbox: true)
            strikeThroughTodoList()
        }
    }
    
    func updateRealmCheckbox(id: Int, checkbox: Bool) {
        try! realm.write {
            realm.create(TodoList.self, value: ["id": id, "checkbox": checkbox], update: .modified)
        }
    }
    
    func strikeThroughTodoList() {
        checkboxImage.image = UIImage(named: "checkBox")
        let strikethroughlineAttribute = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.thick.rawValue]
        let strikethroughlineAttributedString = NSAttributedString(string: todoListContent, attributes: strikethroughlineAttribute)
        todoListLabel.attributedText = strikethroughlineAttributedString
        bookmarkImage.image = UIImage(named: "bookmark_gray")
    }
    
    func originalTodoList() {
        checkboxImage.image = UIImage(named: "emptyBox")
        let attributeString = NSMutableAttributedString(string: todoListContent)
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        todoListLabel.attributedText = attributeString
        bookmarkImage.image = UIImage.coloredBookmarkImage(bookmarkImage.image!)()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
