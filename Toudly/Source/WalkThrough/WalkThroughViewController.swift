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
        changeRootVC(vc)
    }
    
    func changeRootVC(_ vc: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            let navigationController = UINavigationController(rootViewController: mainVC)
            
            navigationController.navigationBar.isHidden = true
            window.rootViewController = navigationController
        } else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
