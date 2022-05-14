//
//  UIString.swift
//  Todo
//
//  Created by 김지훈 on 2022/04/23.
//

import Foundation

extension String {
    func stringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //MARK: 왜 KST 아니고 UTC로 해야 한국시간이 나오는지 확인하기
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        }
        else {
            return nil
        }
    }
}
