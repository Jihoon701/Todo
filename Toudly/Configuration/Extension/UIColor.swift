//
//  UIColor.swift
//  Todo
//
//  Created by 김지훈 on 2022/06/02.
//

import UIKit

extension UIColor {
    convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    static func fromRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    class var mainDarkGreen: UIColor {
        UIColor.fromRGB(red: 2, green: 44, blue: 54)
    }
    
    class var burgundy: UIColor {
        UIColor.fromRGB(red: 128, green: 0, blue: 32)
    }
    
    class var lightGray182: UIColor {
        UIColor.fromRGB(red: 182, green: 182, blue: 182)
    }
}
