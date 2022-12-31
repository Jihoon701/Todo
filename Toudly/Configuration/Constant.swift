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
    = UserDefaults.standard.bool(forKey: "isWeekType")
    {
        didSet {
            guard let isWeekType = isWeekType else { return }
            UserDefaults.standard.set(isWeekType, forKey: "isWeekType")
        }
    }
    
    static var todoPrimaryKey: Int
    = UserDefaults.standard.integer(forKey: "todoPrimaryKey")
    {
        didSet {
            let todoPrimaryKey = todoPrimaryKey
            UserDefaults.standard.set(todoPrimaryKey, forKey: "todoPrimaryKey")
        }
    }
    
    static var bookmarkColor: String?
    = UserDefaults.standard.string(forKey: "bookmarkColor")
    {
        didSet {
            let bookmarkColor = bookmarkColor
            UserDefaults.standard.set(bookmarkColor, forKey: "bookmarkColor")
        }
    }
    
    static var firstTimeLauncing: Bool? = {
        UserDefaults.standard.register(defaults: ["firstTimeLauncing" : true])
        return UserDefaults.standard.bool(forKey: "firstTimeLauncing")
    }()
    {
        didSet {
            guard let firstTimeLauncing = firstTimeLauncing else { return }
            UserDefaults.standard.set(firstTimeLauncing, forKey: "firstTimeLauncing")
        }
    }
}
