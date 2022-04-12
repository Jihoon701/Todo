//
//  SideMenuViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/03/10.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sideMenuColor: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        //        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        self.view.backgroundColor = sideMenuColor.withAlphaComponent(0.8)
        //        F9F5EFF9F5EF
    }
}
