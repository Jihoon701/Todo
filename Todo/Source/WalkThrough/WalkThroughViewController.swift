//
//  WalkThroughViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/06/20.
//

import UIKit

class WalkThroughViewController: UIViewController {

    @IBOutlet weak var toMainVCButton: UIButton!
    override func viewDidLoad() {
        toMainVCButton.setupButtonTitleLabel(text: "투두 작성하러 가기")
        toMainVCButton.layer.cornerRadius = 15
        super.viewDidLoad()

    }

    @IBAction func toMainVC(_ sender: Any) {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = homeStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        changeRootViewController(vc)
    }
    
}
