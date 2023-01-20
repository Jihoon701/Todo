//
//  String.swift
//  Toudly
//
//  Created by 김지훈 on 2023/01/13.
//

import Foundation

extension String {
    func stringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        }
        else {
            return nil
        }
    }
}
