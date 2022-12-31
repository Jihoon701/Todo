//
//  CalendarCollectionViewCell.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/12.
//

import UIKit
import RealmSwift

class CalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var UnderLineView: UIView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var CircleImageView: UIImageView!
    let todoCalendar = TodoCalendar()
    let realm = try! Realm()
    
    func initWeekdayCell(text: String) {
        isUserInteractionEnabled = false
        UnderLineView.isHidden = true
        CircleImageView.isHidden = true
        DateLabel.textColor = UIColor.black
        DateLabel.setupLabel(text: text)
    }
    
    func initDayCell(currentDay: String, isTodayDate: Bool, date: String) {
        DateLabel.text = currentDay
        DarwCircleOnTodayDate(isTodayDate: isTodayDate, checkingDate: currentDay)
        checkListExistingDate(date: "\(date)/\(currentDay)")
    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                DateLabel.font = .NanumSR(.extraBold, size: 15)
                DateLabel.textColor = #colorLiteral(red: 0.007843137255, green: 0.1725490196, blue: 0.2117647059, alpha: 1)
            }
            else {
                DateLabel.font = .NanumSR(.regular, size: 13)
                DateLabel.textColor = UIColor.black
            }
        }
    }
    
    func checkListExistingDate(date: String) {
        if realm.objects(TodoList.self).filter("date == %@", date).count > 0 {
            UnderLineView.layer.cornerRadius = 1
            UnderLineView.isHidden = false
        }
        else {
            UnderLineView.isHidden = true
        }
        isUserInteractionEnabled = true
    }
    
    func DarwCircleOnTodayDate(isTodayDate: Bool, checkingDate: String) {
        if isTodayDate && checkingDate == String(Date().day) {
            CircleImageView.isHidden = false
        }
        else {
            CircleImageView.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
