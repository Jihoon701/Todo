//
//  ScreenSettingViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/05/31.
//

import UIKit

protocol ScreenSettingDelegate: AnyObject {
    func reloadBookmarkImage()
}

class ScreenSettingViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookmarkSettingLabel: UILabel!
    @IBOutlet weak var bookmarkColorCheckImage: UIImageView!
    @IBOutlet var bookmarkColorButtons: [UIButton]!
    let bookmarkColors = ["apricot", "green", "red", "turquoise", "yellow"]
    
    @IBAction func backToSettingVC(_ sender: Any) {
        NotificationCenter.default.post(name: Constant.reloadBookmark, object: nil)
        self.navigationController?.popViewController(animated: true)
    }

     
    override func viewDidLoad() {
        titleLabel.setupTitleLabel(text: "화면 설정")
        bookmarkSettingLabel.setupLabel(text: "북마크 색상 정하기")
        initColorButtons()
        bookmarkColorCheckImage.image = UIImage(named: "bookmark_gray")
        bookmarkColorCheckImage.image = UIImage.coloredBookmarkImage(bookmarkColorCheckImage.image!)()
        super.viewDidLoad()
    }
    
    func initColorButtons() {
        for colorButton in bookmarkColorButtons {
            colorButton.addTarget(self, action: #selector(bookmarkColorSelected(sender:)), for: .touchUpInside)
        }
    }
    
    @objc func bookmarkColorSelected (sender: UIButton) {
        print(sender.titleLabel?.text!)
        Constant.bookmarkColor = sender.titleLabel?.text!
        self.bookmarkColorCheckImage.image = UIImage.coloredBookmarkImage(self.bookmarkColorCheckImage.image!)()

     
    }
}
