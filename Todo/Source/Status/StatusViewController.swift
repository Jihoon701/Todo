//
//  StatusViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/17.
//

import UIKit

class StatusViewController: UIViewController {

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var SearchView: UIView!
    @IBOutlet weak var SearchTextField: UITextField!
    @IBAction func BackToHomeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        TitleLabel.font = UIFont(name: "BMJUAOTF", size: 20)
        SearchView.layer.cornerRadius = 18
        SearchTextField.layer.cornerRadius = 10
        SearchTextField.font = UIFont(name: "BMJUAOTF", size: 14)
        
        SearchTextField.textColor = UIColor.darkGray
        SearchTextField.setupLeftImage(imageName: "search_image")
        super.viewDidLoad()
    }
}
