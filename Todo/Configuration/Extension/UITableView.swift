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
    
    func scrollToBottom() {
        let rows = self.numberOfRows(inSection: 0)
        if rows > 0 {
            let indexPath = IndexPath(row: rows - 1, section: 0)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
