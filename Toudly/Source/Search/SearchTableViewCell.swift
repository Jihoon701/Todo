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
        setUI()
        super.awakeFromNib()
    }
    
    func setUI() {
        self.selectionStyle = .none
        contentLabel.font = .NanumSR(.regular, size: 14)
        dateLabel.font = .NanumSR(.light, size: 12)
        dateLabel.textColor = .lightGray
    }
    
    func configureSearchCell(target: TodoList, searchLetter: String) {
        contentLabel.attributedText = changeAllOccurrence(entireString: target.todoContent, searchString: searchLetter)
        contentLabel.sizeToFit()
        dateLabel.text = target.date
    }
    
    func configureCell(target: TodoList) {
        contentLabel.text = target.todoContent
        contentLabel.sizeToFit()
        dateLabel.text = target.date
    }
    
    func changeAllOccurrence(entireString: String, searchString: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: entireString)
        let entireLength = entireString.count
        var range = NSRange(location: 0, length: entireLength)
        var rangeArr = [NSRange]()
        
        while (range.location != NSNotFound) {
            range = (attributedString.string as NSString).range(of: searchString, options: .caseInsensitive, range: range)
            rangeArr.append(range)
            
            if (range.location != NSNotFound) {
                range = NSRange(location: range.location + range.length, length: entireString.count - (range.location + range.length))
            }
        }
        
        rangeArr.forEach { (range) in
            attributedString.addAttributes([.font: UIFont.NanumSR(.extraBold, size: 14), .foregroundColor: UIColor.burgundy], range: range)
        }
        
        return attributedString
    }
}
