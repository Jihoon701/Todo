//
//  UICollectionView.swift
//  Todo
//
//  Created by 김지훈 on 2022/06/08.
//

import Foundation
import UIKit

extension UICollectionView {
    func reloadData(completion:@escaping ()->()) {
        UICollectionView.animate(withDuration: 0, animations: reloadData)
               { _ in completion() }
       }
}
