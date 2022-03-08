//
//  CalendarCollectionViewCell.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/12.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var UnderLineView: UIView!
    @IBOutlet weak var DateLabel: UILabel!
    var listExist: Bool = false
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                DateLabel.font = UIFont(name: "BMJUAOTF", size: 19)
                DateLabel.textColor = #colorLiteral(red: 0.5215686275, green: 0.4705882353, blue: 0.4078431373, alpha: 1)
            }
            else {
                DateLabel.font = UIFont(name: "BMJUAOTF", size: 14)
                DateLabel.textColor = UIColor.black
            }
        }
    }
    
    func ListExistCheck() {
        if listExist {
            UnderLineView.isHidden = false
            UnderLineView.layer.cornerRadius = 1
        }
        else {
            UnderLineView.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UnderLineView.isHidden = true
    }
    

}
