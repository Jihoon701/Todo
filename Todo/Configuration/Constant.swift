//
//  Constant.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/13.
//

import Foundation

struct Constant {

    static let reloadBookmark = Notification.Name("reloadBookmark")
    
    static var isWeekType: Bool?
    = UserDefaults.standard.bool(forKey: "calendarMonthTypeCheck")
    {
        didSet {
            guard let calendarWeekTypeCheck = isWeekType else { return }
            UserDefaults.standard.set(calendarWeekTypeCheck, forKey: "calendarWeekTypeCheck")
        }
    }
    
    static var todoPrimaryKey: Int
    = UserDefaults.standard.integer(forKey: "todoPrimaryKey")
    {
        didSet {
            let todoPrimaryKey = todoPrimaryKey
            print("todoPrimaryKey:  \(todoPrimaryKey)")
            UserDefaults.standard.set(todoPrimaryKey, forKey: "todoPrimaryKey")
        }
    }
    
    static var bookmarkColor: String?
    = UserDefaults.standard.string(forKey: "bookmarkColor")
    {
        didSet {
            let bookmarkColor = bookmarkColor
//            print("bookmarkColor:  \(bookmarkColor)")
            UserDefaults.standard.set(bookmarkColor, forKey: "bookmarkColor")
        }
    }
}
