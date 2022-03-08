//
//  TodoList.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/15.
//

import Foundation
import RealmSwift

// todoContent nil
class TodoList: Object {
    @objc dynamic var todoContent: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var alarm: Bool = false
    @objc dynamic var checkbox: Bool = false
    @objc dynamic var order: Int = 0
    @objc dynamic var id: Int = 0
    
    override static func primaryKey() -> String? {
            return "id"
        }
}
 
