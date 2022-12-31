//
//  UIButton.swift
//  Todo
//
//  Created by 김지훈 on 2022/05/14.
//

import Foundation
import UIKit

extension UIButton {
    func setupButtonTitleLabel(text: String) {
        self.titleLabel?.font = .NanumSR(.regular, size: 14)
        self.setTitle(text, for: .normal)
    }
}
