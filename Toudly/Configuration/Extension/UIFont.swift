//
//  UIFont.swift
//  Todo
//
//  Created by 김지훈 on 2022/04/17.
//

import Foundation
import UIKit

extension UIFont {
    
    public enum NanumSquareRound: String {
        case light = "L"
        case regular = "R"
        case bold = "B"
        case extraBold = "EB"
    }
    
    static func NanumSR(_ type: NanumSquareRound, size: CGFloat) -> UIFont {
        return UIFont(name: "NanumSquareRoundOTF\(type.rawValue)", size: size)!
    }
}
