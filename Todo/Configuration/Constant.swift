//
//  Constant.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/13.
//

import Foundation

struct Constant {
    
    // 캘린더 타입 변경 true:Week false:Month
    static var calendarWeekTypeCheck: Bool?
   = UserDefaults.standard.bool(forKey: "calendarMonthTypeCheck")
    {
        didSet {
            guard let calendarWeekTypeCheck = calendarWeekTypeCheck else { return }
            print("calendarWeekTypeCheck: \(calendarWeekTypeCheck)")
            UserDefaults.standard.set(calendarWeekTypeCheck, forKey: "calendarWeekTypeCheck")
        }
    }
    
    static var todoPrimaryKey: Int
   = UserDefaults.standard.integer(forKey: "todoPrimaryKey")
    {
        didSet {
            let todoPrimaryKey = todoPrimaryKey
            print("todoPrimaryKey: \(todoPrimaryKey)")
            UserDefaults.standard.set(todoPrimaryKey, forKey: "todoPrimaryKey")
        }
    }
}
