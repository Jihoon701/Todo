//
//  DetailTableViewCell.swift
//  Todo
//
//  Created by 김지훈 on 2022/04/25.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var alarmImage: UIImageView!
    @IBOutlet weak var bookmarkImage: UIImageView!
    @IBOutlet weak var boxImage: UIImageView!
    @IBOutlet weak var alarmSetTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.font = .NanumSR(.regular, size: 14)
        contentLabel.textColor = .black
        dateLabel.font = .NanumSR(.light, size: 12)
        dateLabel.textColor = .lightGray
        alarmSetTimeLabel.font = .NanumSR(.regular, size: 12)
        alarmSetTimeLabel.textColor = .lightGray
        alarmSetTimeLabel.isHidden = true
    }
    
    func detailCellInit(checkBox: Bool, alarm: Bool, alarmTime: String, bookmark: Bool) {
        if alarm {
            alarmImage.image = UIImage(named: "alarm")
            alarmSetTimeLabel.isHidden = false
            alarmSetTimeLabel.text = alarmTime
        }
        else {
            alarmImage.image = UIImage(named: "alarmdisabled")
            alarmSetTimeLabel.isHidden = true
        }
        
        if checkBox {
            boxImage.image = UIImage(named: "checkBox")
        }
        else {
            boxImage.image = UIImage(named: "emptyBox")
        }
        
        if bookmark {
            bookmarkImage.image = UIImage.coloredBookmarkImage(bookmarkImage.image!)()
        }
        else {
            bookmarkImage.image = UIImage(named: "bookmark_gray")
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
