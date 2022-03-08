//
//  MainViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/12.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var CalendarCollectionView: UICollectionView!
    @IBOutlet weak var CalendarCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var MenuImageView: UIImageView!
    @IBOutlet weak var CalendarImageView: UIImageView!
    @IBOutlet weak var RightArrowImageView: UIImageView!
    @IBOutlet weak var LeftArrowImageView: UIImageView!
    @IBOutlet weak var PlusBoxImageView: UIImageView!
    @IBOutlet weak var GraphImageView: UIImageView!
    @IBOutlet weak var TodoListTableView: UITableView!
    @IBOutlet weak var TodoListTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var TodoScrollView: UIScrollView!
    @IBOutlet weak var TodoResultLabel: UILabel!
    
    let realm = try! Realm()
    var todoLists = [TodoList]()
    var list: Results<TodoList>!
    var realmNotificationToken: NotificationToken?

    //MARK: Check if this var is essential
    var currentHomeDate: String = "0000.00"

    let now = Date()
    var cal = Calendar.current
    let dateFormatter = DateFormatter()
    let currentDateFormatter = DateFormatter()
    var components = DateComponents()
    var currentComponents = DateComponents()
    var prevComponents = DateComponents()
    var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    var daysInMonthType: [String] = []
    var daysInWeekType: [String] = []
    var daysCountInMonth = 0 // 해당 월이 며칠까지 있는지
    var weekdayAdding = 0 // 시작일
    var checkAddingList = false
    var currentDate = false
    var selectedRow = 0
    var addTodoListCalendarCheck = false
    
    var selectedDate = ""
    var calendarMonth = 0
    var calendarYear = 0
    var calendarDay = 0
    
    var todoCount = 0
    var todoDone = 0
    var todoLeft = 0
    
    private func initView() {
        self.initCollection()
        dateFormatter.dateFormat = "yyyy년 M월"
        currentDateFormatter.dateFormat = "yyyy년 M월"
        
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1
        
        currentComponents.year = cal.component(.year, from: now)
        currentComponents.month = cal.component(.month, from: now)
        currentComponents.day = cal.component(.day, from: now)
        
        calendarYear = Int(currentComponents.year!)
        calendarMonth = Int(currentComponents.month!)
        calendarDay = Int(currentComponents.day!)
        selectedDate = "\(calendarYear)/\(calendarMonth)/\(calendarDay)"
        print("호호호호호",selectedDate)
        self.calculation()
    }
    
    private func calculation() {
        let firstDayOfMonth = cal.date(from: components)
        calendarYear = cal.component(.year, from: firstDayOfMonth!)
        calendarMonth = cal.component(.month, from: firstDayOfMonth!)
        calendarDay = cal.component(.day, from: firstDayOfMonth!)
        
        
        let firstWeekday = cal.component(.weekday, from: firstDayOfMonth!)
        let currentWeekday = cal.component(.weekday, from: now)
        
        let firstDayOfPrevMonth = cal.date(byAdding: .month, value: -1, to: Date())!
        let daysCountInPrevMonth = cal.range(of: .day, in: .month, for: firstDayOfPrevMonth)!.count
        let firstDayOfNextMonth = cal.date(byAdding: .month, value: 1, to: Date())!
        let daysCountInNextMonth = cal.range(of: .day, in: .month, for: firstDayOfNextMonth)!.count
        
        daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        weekdayAdding = 2 - firstWeekday
        //MARK: 체크
        currentHomeDate = dateFormatter.string(from: firstDayOfMonth!)
        DateLabel.text = currentHomeDate
        
        daysInWeekType = weekCalendarCalculaton(weekday: currentWeekday, prevMonthDaysCount: daysCountInPrevMonth, currentMonthDaysCount: daysCountInMonth, nextMonthDaysCount: daysCountInNextMonth).map { String($0) }
        
        print(weekCalendarCalculaton(weekday: currentWeekday, prevMonthDaysCount: daysCountInPrevMonth, currentMonthDaysCount: daysCountInMonth, nextMonthDaysCount: daysCountInNextMonth))
        
        self.daysInMonthType.removeAll()
        for day in weekdayAdding...daysCountInMonth {
            if day < 1 {
                self.daysInMonthType.append("")
            } else {
                self.daysInMonthType.append(String(day))
            }
        }
        
        if components.year == currentComponents.year && components.month == currentComponents.month {
            currentDate = true
        }
        else {
            currentDate = false
        }
    }
    
    private func initCollection() {
        CalendarCollectionView.delegate = self
        CalendarCollectionView.dataSource = self
        TodoListTableView.delegate = self
        TodoListTableView.dataSource = self
        TodoListTableView.dragInteractionEnabled = true
        TodoListTableView.dragDelegate = self
        TodoListTableView.dropDelegate = self
        
        CalendarCollectionView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCollectionViewCell")
        TodoListTableView.register( UINib(nibName: "TodoListTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoListTableViewCell")
        TodoListTableView.register(UINib(nibName: "AddTodoListTableViewCell", bundle: nil), forCellReuseIdentifier: "AddTodoListTableViewCell")
    }
    
    private func weekCalendarCalculaton(weekday: Int, prevMonthDaysCount: Int, currentMonthDaysCount: Int, nextMonthDaysCount: Int) -> Array<Int> {
        var tmpWeekDays: Array<Int> = Array(repeating: 0, count: 7)
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.dateFormat = "d"
        let currentDate = Int(currentDateFormatter.string(from: Date()))
        
        var startWeekday = currentDate! - weekday + 1
        var endWeekday = currentDate! + 7 - weekday
        
        // 달력 앞부분
        if startWeekday < 1 {
            startWeekday = prevMonthDaysCount + startWeekday
            var temp = 0
            
            for i in startWeekday...prevMonthDaysCount {
                tmpWeekDays[i-startWeekday] = i
                temp += 1
            }
            
            for j in 1...endWeekday {
                tmpWeekDays[temp] = j
                temp += 1
            }
            return tmpWeekDays
        }
        
        // 달력 뒷부분
        if endWeekday > currentMonthDaysCount {
            endWeekday = endWeekday - currentMonthDaysCount
            var temp = 0
            
            for i in startWeekday...currentMonthDaysCount {
                tmpWeekDays[i-startWeekday] = i
                temp += 1
            }
            
            for j in 1...endWeekday {
                tmpWeekDays[temp] = j
                temp += 1
            }
            return tmpWeekDays
        }
        
        for i in startWeekday...endWeekday {
            tmpWeekDays[i-startWeekday] = i
        }
        return tmpWeekDays
    }
    
    override func viewDidLoad() {
        
        self.initView()

        //MARK: 밑에 코드 구현 안해도 됨 - 확인
        //MARK: 필터 적용시 cell 개수도 다시 확인
        list = realm.objects(TodoList.self).filter("date == %@", selectedDate).sorted(byKeyPath: "order", ascending: true)
        checkAddingList = false
        
        TodoResultLabel.font = UIFont(name: "BMJUAOTF", size: 16)
        TodoResultLabel.text = "Todo: \(todoCount)  Done: \(todoDone)   Left: \(todoLeft) "
 
        print("ㅎㅎㅎ", currentHomeDate)
        let menuImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(TodoMenu))
        let calendarImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(ChangeCalendarType))
        let graphImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(PresentStatusVC))
        let plusBoxImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(AddTodoList))
        let leftImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(PreviousMonth))
        let rightImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(NextMonth))
        
        if Constant.calendarWeekTypeCheck! {
            RightArrowImageView.isHidden = true
            LeftArrowImageView.isHidden = true
        }
        else {
            RightArrowImageView.isHidden = false
            LeftArrowImageView.isHidden = false
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        MenuImageView.addGestureRecognizer(menuImageTapGesture)
        MenuImageView.isUserInteractionEnabled = true
        CalendarImageView.addGestureRecognizer(calendarImageTapGesture)
        CalendarImageView.isUserInteractionEnabled = true
        GraphImageView.addGestureRecognizer(graphImageTapGesture)
        GraphImageView.isUserInteractionEnabled = true
        PlusBoxImageView.addGestureRecognizer(plusBoxImageTapGesture)
        PlusBoxImageView.isUserInteractionEnabled = true
        LeftArrowImageView.addGestureRecognizer(leftImageTapGesture)
        LeftArrowImageView.isUserInteractionEnabled = true
        RightArrowImageView.addGestureRecognizer(rightImageTapGesture)
        RightArrowImageView.isUserInteractionEnabled = true
        
        CalendarCollectionView.layer.cornerRadius = 15
        CalendarCollectionView.layer.borderWidth = 2
        CalendarCollectionView.layer.borderColor = #colorLiteral(red: 0.231372549, green: 0.2, blue: 0.1843137255, alpha: 1)
        
        print("ㄹㄹㄹ", currentHomeDate)
        DateLabel.text = String(currentHomeDate)
        
        realmNotificationToken = realm.observe { (notification, realm) in
            self.TodoListTableView.reloadData()
        }
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        realmNotificationToken?.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func ChangeCalendarType() {
        CalendarCollectionView.reloadData()
        // Week (true)
        if Constant.calendarWeekTypeCheck! {
            calculation()
            Constant.calendarWeekTypeCheck = false
            RightArrowImageView.isHidden = false
            LeftArrowImageView.isHidden = false
            CalendarCollectionViewHeight.constant = CalendarCollectionView.collectionViewLayout.collectionViewContentSize.height
            view.setNeedsLayout()
        }
        // Month (false)
        else {
            components.month = cal.component(.month, from: now)
            calculation()
            Constant.calendarWeekTypeCheck = true
            RightArrowImageView.isHidden = true
            LeftArrowImageView.isHidden = true
            DateLabel.text = String(currentHomeDate)
            CalendarCollectionViewHeight.constant = CalendarCollectionView.collectionViewLayout.collectionViewContentSize.height
            view.setNeedsLayout()
        }
        list = realm.objects(TodoList.self).filter("date == %@", selectedDate).sorted(byKeyPath: "order", ascending: true)
        TodoListTableView.reloadData {
            self.TodoScrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    @objc func AddTodoList() {
        checkAddingList = true
        TodoListTableView.reloadData()
    }
    
    @objc func TodoMenu() {
        
    }
    
    @objc func PresentStatusVC() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "StatusViewController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    @objc func PreviousMonth() {
        components.month = components.month! - 1
        calendarYear = components.year!
        calendarMonth = components.month!
        calculation()
        CalendarCollectionView.reloadData()
        list = realm.objects(TodoList.self).filter("date == %@", selectedDate).sorted(byKeyPath: "order", ascending: true)
        TodoListTableView.reloadData {
            self.TodoScrollView.setContentOffset(CGPoint.zero, animated: true)
        }
        CalendarCollectionViewHeight.constant = CalendarCollectionView.collectionViewLayout.collectionViewContentSize.height
        view.setNeedsLayout()
    }
    
    @objc func NextMonth() {
        components.month = components.month! + 1
        calendarYear = components.year!
        calendarMonth = components.month!
        calculation()
        CalendarCollectionView.reloadData()
        list = realm.objects(TodoList.self).filter("date == %@", selectedDate).sorted(byKeyPath: "order", ascending: true)
        TodoListTableView.reloadData {
            self.TodoScrollView.setContentOffset(CGPoint.zero, animated: true)
        }
        CalendarCollectionViewHeight.constant = CalendarCollectionView.collectionViewLayout.collectionViewContentSize.height
        view.setNeedsLayout()
    }
    
    //MARK: 개념확인
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        CalendarCollectionViewHeight.constant = CalendarCollectionView.collectionViewLayout.collectionViewContentSize.height
        view.setNeedsLayout()
        CalendarCollectionView.reloadData()
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7
        default:
            if Constant.calendarWeekTypeCheck! {
                return daysInWeekType.count
            }
            else {
                return daysInMonthType.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CalendarCollectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
        cell.DateLabel.font = UIFont(name: "BMJUAOTF", size: 14)
        cell.listExist = false
        cell.CircleImageView.isHidden = true
        
        switch indexPath.section {
        case 0:
            cell.isUserInteractionEnabled = false
            cell.DateLabel.text = weeks[indexPath.item]
            cell.DateLabel.textColor = UIColor.black
            
        default:
            if Constant.calendarWeekTypeCheck! {
                cell.DateLabel.text = daysInWeekType[indexPath.item]
            }
            else {
                cell.DateLabel.text = daysInMonthType[indexPath.item]
            }
            
            let currentDateFormatter = DateFormatter()
            currentDateFormatter.dateFormat = "d"
            
            // addTodoListCalendarCheck -> false 그대로
            // true add하던 날짜로 select
            
            // 오늘 날짜가 있으면 해당 날짜 select
            if currentDate && cell.DateLabel.text == currentDateFormatter.string(from: Date()) {
                cell.CircleImageView.isHidden = false
                CalendarCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
                selectedDate = "\(calendarYear)/\(calendarMonth)/\(daysInMonthType[indexPath.item])"
                TodoListTableView.reloadData()
            }
            // 없으면 첫째날 select
            else if cell.DateLabel.text == "1" {
                CalendarCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
                selectedDate = "\(calendarYear)/\(calendarMonth)/\(daysInMonthType[indexPath.item])"
                TodoListTableView.reloadData()
            }
            else {
                cell.isSelected = false
                cell.DateLabel.textColor = UIColor.black
            }
            
            let existingDate = "\(calendarYear)/\(calendarMonth)/\(cell.DateLabel.text!)"
            if (realm.objects(TodoList.self).filter("date == %@", existingDate).count > 0 && indexPath.section == 1){
                cell.listExist = true
            }
            else {
                cell.listExist = false
            }
            cell.ListExistCheck()
            cell.isUserInteractionEnabled = true
        }
        // 해당 날짜에 투두 작성했으면 밑줄처리
        cell.ListExistCheck()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = CalendarCollectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
        selectedDate = "\(calendarYear)/\(calendarMonth)/\(daysInMonthType[indexPath.item])"
        TodoListTableView.reloadData {
            self.TodoScrollView.setContentOffset(CGPoint.zero, animated: true)
        }
        cell.isSelected = true
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CalendarCollectionView.frame.size.width / 7 - 5
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list = realm.objects(TodoList.self).filter("date == %@", selectedDate).sorted(byKeyPath: "order", ascending: true)
        if checkAddingList {
            return list.count + 1
        }
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == list.count && checkAddingList {
            let addCell = TodoListTableView.dequeueReusableCell(withIdentifier: "AddTodoListTableViewCell", for: indexPath) as! AddTodoListTableViewCell
            addCell.AddTodoListTextField.text = ""
            addCell.date = selectedDate
            addCell.order = list.count
            addCell.id = Constant.todoPrimaryKey
            Constant.todoPrimaryKey += 1
            addCell.newListDelegate = self
            return addCell
        }
        
        let listCell = TodoListTableView.dequeueReusableCell(withIdentifier: "TodoListTableViewCell", for: indexPath) as! TodoListTableViewCell
        list = realm.objects(TodoList.self).filter("date == %@", selectedDate).sorted(byKeyPath: "order", ascending: true)
//        list = realm.objects(TodoList.self).sorted(byKeyPath: "order", ascending: true)
        listCell.todoListConent = list[indexPath.row].todoContent
        listCell.todolistDone = list[indexPath.row].checkbox
        listCell.selectionStyle = .none
        listCell.listCount = list.count
        listCell.todoList = list[indexPath.row]
        listCell.TodoListLabel.text = list[indexPath.row].todoContent
        return listCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellWidth = TodoListTableView.frame.width * 1/9
        return cellWidth
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath) as? TodoListTableViewCell) != nil {
            guard let vc = self.storyboard!.instantiateViewController(withIdentifier: "EditTodoListBackgroundViewController") as? EditTodoListBackgroundViewController else {return}
            selectedRow = indexPath.row
            vc.vcDelegate = self
            vc.selfValue = self
            vc.TodoListContentBackground = list[indexPath.row].todoContent
            vc.TodoListIdBackground = list[indexPath.row].id
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.view.backgroundColor = .black.withAlphaComponent(0.7)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        try! realm.write {
            let sourceList = list[sourceIndexPath.row]
            let destinationList = list[destinationIndexPath.row]
            let destinationListOrder = destinationList.order
            if sourceIndexPath.row < destinationIndexPath.row {
                for index in sourceIndexPath.row...destinationIndexPath.row {
                    list[index].order -= 1
                }
            }
            else {
                for index in (destinationIndexPath.row..<sourceIndexPath.row).reversed() {
                    list[index].order += 1
                }
            }
            sourceList.order = destinationListOrder
        }
    }
}

extension MainViewController: NewTodoListDelegate, DeleteCellDelegate, EditVCDelegate {
    
    func DelegateEditVC() {
        print("CHECK DELEGATE")
    }
    
    func ReorderDeletedList() {
        let endIndex = list.count
        let startIndex = selectedRow
        try! realm.write {
            print(startIndex, endIndex)
            for index in startIndex..<endIndex {
                print(index)
                list[index].order -= 1
            }
        }
        CalendarCollectionView.reloadSections(IndexSet(1...1))
    }
    
    func MakeNewTodoListDelegate() {
        checkAddingList = false
        addTodoListCalendarCheck = true
        CalendarCollectionView.reloadSections(IndexSet(1...1))
        addTodoListCalendarCheck = false
    }
    
    func RevokeAddCellDelegate() {
        checkAddingList = false
        TodoListTableView.reloadData()
    }
}
