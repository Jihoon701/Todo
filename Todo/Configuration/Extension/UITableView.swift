//
//  UITableView.swift
//  Todo
//
//  Created by 김지훈 on 2022/02/08.
//

import Foundation
import UIKit

extension UITableView {
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: reloadData)
        { _ in completion() }
    }
}
