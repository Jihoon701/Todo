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
    let holidayCalendar = HolidayCalendar()
    let realm = try! Realm()
    var isHoliday = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                DateLabel.font = .NanumSR(.extraBold, size: 15)
                DateLabel.textColor = UIColor.mainDarkGreen
            }
            else {
                DateLabel.textColor = isHoliday ? UIColor.burgundy : UIColor.black
                DateLabel.font = .NanumSR(.regular, size: 13)
            }
        }
    }
    
    func initWeekdayCell(text: String) {
        isUserInteractionEnabled = false
        UnderLineView.isHidden = true
        CircleImageView.isHidden = true
        DateLabel.textColor = UIColor.black
        DateLabel.setupLabel(text: text)
    }
    
    // haveTodayDate: 해당 달에 오늘 날짜가 포함되어 있는지 확인하는 변수
    // haveHolidayDate: 해당 달에 공휴일이 포함되어 있는지 확인하는 변수
    func initDayCell(currentDay: String, haveTodayDate: Bool, date: String, haveHolidayDate: Bool) {
        DateLabel.text = currentDay
        drawCircleOnTodayDate(haveTodayDate: haveTodayDate, checkingDate: currentDay)
        changeTextColorOnHolidayDate(haveHolidayDate: haveHolidayDate, checkingDate: currentDay)
        checkListExistingDate(date: "\(date)/\(currentDay)")
        print("^^   ", haveHolidayDate)
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
    
    func drawCircleOnTodayDate(haveTodayDate: Bool, checkingDate: String) {
        if haveTodayDate && checkingDate == String(Date().day) {
            CircleImageView.isHidden = false
            CircleImageView.tintColor = UIColor.black
        }
        else {
            CircleImageView.isHidden = true
        }
    }
    
    func changeTextColorOnHolidayDate(haveHolidayDate: Bool, checkingDate: String) {
        print("공휴일  ", changeTextColorOnHolidayDate, checkingDate)
        if haveHolidayDate && (holidayCalendar.holidayInfoArray.firstIndex(where: {String($0.day) == checkingDate}) != nil) {
            print("공휴일 존재")
            DateLabel.textColor = UIColor.burgundy
            self.isHoliday = true
        }
        else {
            DateLabel.textColor = UIColor.black
            self.isHoliday = false
        }
    }
}
