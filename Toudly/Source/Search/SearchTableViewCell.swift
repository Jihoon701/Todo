//
//  SearchTableViewCell.swift
//  Todo
//
//  Created by 김지훈 on 2022/04/20.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        contentLabel.font = .NanumSR(.regular, size: 14)
        dateLabel.font = .NanumSR(.light, size: 12)
        dateLabel.textColor = .lightGray
        super.awakeFromNib()
    }
}
