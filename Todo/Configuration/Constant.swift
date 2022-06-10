//
//  Constant.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/13.
//

import Foundation

struct Constant {
    
    enum CalendarCase: String {
        case week
        case month
    }
    
    //    static var calendarType: String
    //    = UserDefaults.standard.string(forKey: "calendarTypeCheck")
    ////     Constant.CalendarCase(rawValue: UserDefaults.standard.string(forKey: "calendarTypeCheck")!) ?? <#default value#>
    //    {
    //        didSet {
    //            guard let calendarTypeCheck = calendarType else { return }
    //            UserDefaults.standard.set(calendarTypeCheck, forKey: "calendarType")
    //        }
    //    }
    
    
    //MARK: 캘린더 타입 변경 true:Week false:Month (Bool 타입 or String 타입)
    static var calendarWeekType: Bool?
    = UserDefaults.standard.bool(forKey: "calendarMonthTypeCheck")
    {
        didSet {
            guard let calendarWeekTypeCheck = calendarWeekType else { return }
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
