//
//  SettingTableViewCell.swift
//  Todo
//
//  Created by 김지훈 on 2022/04/19.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingIndexLabel: UILabel!
    @IBOutlet weak var settingDetailLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    
    let settingIndex = ["Information", "Screen", "Data", "Notification", "Inquiry", "Review", "Version"]
    //    let settingIndex = ["Information", "Screen", "Data", "Notification", "Inquiry", "Review", "Open Source", "Version"]
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initSettingCell(row: Int) {
        selectionStyle = .none
        settingIndexLabel.setupLabel(text: settingIndex[row])
        settingDetailLabel.isHidden = true
        
        if row == 4 || row == 5 || row == 6 {
            rightImageView.isHidden = true
        }
        
        if row == 6 {
            settingDetailLabel.isHidden = false
            settingDetailLabel.text = appVersion
            settingDetailLabel.font = .NanumSR(.extraBold, size: 12)
            settingDetailLabel.textColor = #colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.3803921569, alpha: 1)
        }
    } 
}
