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
    
    let settingIndex = [ "화면 설정", "데이터 관리", "알림", "문의", "리뷰", "버전"]
//    let settingIndex = ["사용 방법", "화면 설정", "데이터 관리", "알림", "문의", "리뷰", "오픈소스", "버전"]
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initSettingCell(row: Int) {
        selectionStyle = .none
        settingIndexLabel.setupLabel(text: settingIndex[row])
        settingDetailLabel.isHidden = true
        
        if row == 3 || row == 4 || row == 5 {
            rightImageView.isHidden = true
        }
        
        if row == 5 {
            settingDetailLabel.isHidden = false
            settingDetailLabel.text = appVersion
            settingDetailLabel.font = .NanumSR(.extraBold, size: 12)
            settingDetailLabel.textColor = #colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.3803921569, alpha: 1)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
