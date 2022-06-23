//
//  TodoManualViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/06/23.
//

import UIKit

class TodoManualViewController: UIViewController {

    @IBAction func backToSettingVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
