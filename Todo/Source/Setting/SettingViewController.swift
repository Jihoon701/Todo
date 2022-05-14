//
//  SettingViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/04/19.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingTableView: UITableView!
    
    @IBAction func BackToHomeVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        titleLabel.setupTitleLabel(text: "설정")
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.allowsSelection = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        super.viewDidLoad()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self
            compseVC.setToRecipients(["kb5i701@gmail.com"])
            self.present(compseVC, animated: true, completion: nil)
        }
        else {
            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default)
            sendMailErrorAlert.addAction(confirmAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: infolist 확인하기
    //MARK: appID 바꾸기
    func rateThisApp() {
        if let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id\(1597618795)?ls=1&mt=8&action=write-review"), UIApplication.shared.canOpenURL(reviewURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil) } else { UIApplication.shared.openURL(reviewURL) } }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        cell.initSettingCell(row: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        case 2:
            let vc = storyboard?.instantiateViewController(withIdentifier: "DataSettingViewController") as! DataSettingViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 3:
            let vc = storyboard?.instantiateViewController(withIdentifier: "AlarmSettingViewController") as! AlarmSettingViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 4:
            sendEmail()
            
        case 5:
            rateThisApp()
            
        case 6:
            let vc = storyboard?.instantiateViewController(withIdentifier: "OpenSourceViewController") as! OpenSourceViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return settingTableView.frame.width * 1/8
    }
}
