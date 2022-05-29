//
//  MainViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/12.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var calendarDateLabel: UILabel!
    @IBOutlet weak var CalendarCollectionView: UICollectionView!
    @IBOutlet weak var CalendarCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var previousMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var todoListTableView: UITableView!
    
    let todoCalendar = TodoCalendar()
    let realm = try! Realm()
    var list: Results<TodoList>!
    var realmNotificationToken: NotificationToken?
    
    var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    var addTodoListCellExist = false
    var selectedRow = 0
    var todoListEdited = false
    var selectedDateConfirmed = false
    var selectedDate = ""
    var editedTodoListDate = ""
    
    func initCollection() {
        CalendarCollectionView.delegate = self
        CalendarCollectionView.dataSource = self
        
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        
        todoListTableView.dragInteractionEnabled = true
        todoListTableView.dragDelegate = self
        todoListTableView.dropDelegate = self
        
        CalendarCollectionView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCollectionViewCell")
        todoListTableView.register( UINib(nibName: "TodoListTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoListTableViewCell")
        todoListTableView.register(UINib(nibName: "AddTodoListTableViewCell", bundle: nil), forCellReuseIdentifier: "AddTodoListTableViewCell")
    }

    override func viewDidLoad() {
        self.initCollection()
        todoCalendar.initCalendar()
        calendarDateLabel.setupTitleLabel(text: todoCalendar.CalendarTitle())
        list = realm.objects(TodoList.self).filter("date == %@", selectedDate).sorted(byKeyPath: "order", ascending: true)
        todoListTableView.layer.cornerRadius = 10
        addTodoListCellExist = false
        
        if Constant.calendarWeekType! {
            nextMonthButton.isHidden = true
            previousMonthButton.isHidden = true
        }
        else {
            nextMonthButton.isHidden = false
            previousMonthButton.isHidden = false
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        realmNotification()
        
//        todoListTableView.estimatedRowHeight = todoListTableView.frame.width * 1/5
//        todoListTableView.rowHeight = UITableView.automaticDimension
        super.viewDidLoad()
    }
    
    func realmNotification() {
        realmNotificationToken = realm.observe { [self] (notification, realm) in
            todoListTableView.reloadData()
            CalendarCollectionView.reloadData()
            todoListEdited = true
            // TODO: collectionview reload하면 selectday 바뀜
        }
    }
    
    func changeCalendar(_ calendarType: Bool) {
        CalendarCollectionView.reloadData()
        todoCalendar.initCalendar()
        Constant.calendarWeekType = !calendarType
        nextMonthButton.isHidden = !calendarType
        previousMonthButton.isHidden = !calendarType
        calendarDateLabel.setupTitleLabel(text: todoCalendar.CalendarTitle())
        CalendarCollectionViewHeight.constant = CalendarCollectionView.collectionViewLayout.collectionViewContentSize.height
        view.setNeedsLayout()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) { [self] in
            todoListTableView.reloadData()
        }
    }
    
    @IBAction func changeCalendarType(_ sender: Any) {
        changeCalendar(Constant.calendarWeekType!)
    }
    
    @IBAction func addTodoList(_ sender: Any) {
        addTodoListCellExist = true
        todoListTableView.reloadData()
        //        todoListTableView.scrollToBottom()
    }
    
    @IBAction func toDetailVC(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func toSearchVC(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SearchViewController")
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true)
    }
    
    @IBAction func toSettingVC(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController")as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func rearrangeCalendar() {
        list = realm.objects(TodoList.self).filter("date == %@", selectedDate).sorted(byKeyPath: "order", ascending: true)
        CalendarCollectionView.reloadData()
        todoListTableView.reloadData()
        CalendarCollectionViewHeight.constant = CalendarCollectionView.collectionViewLayout.collectionViewContentSize.height
        view.setNeedsLayout()
    }
    
    @IBAction func toPreviousMonth(_ sender: Any) {
        todoCalendar.moveCalendarMonth(value: -1, calendarTitleLabel: calendarDateLabel)
        rearrangeCalendar()
    }
    
    @IBAction func toNextMonth(_ sender: Any) {
        todoCalendar.moveCalendarMonth(value: 1, calendarTitleLabel: calendarDateLabel)
        rearrangeCalendar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: 두번 작동 확인
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews    viewDidLayoutSubviews   viewDidLayoutSubviews")
        print("Hello From \(NSStringFromSelector(#function))")
        super.viewDidLayoutSubviews()
        CalendarCollectionViewHeight.constant = CalendarCollectionView.collectionViewLayout.collectionViewContentSize.height
//        todoListTableView.beginUpdates()
//        todoListTableView.endUpdates()
        becomeFirstResponderTextField()
        view.setNeedsLayout()
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
            if Constant.calendarWeekType! {
                return todoCalendar.daysInWeekType.count
            }
            else {
                return todoCalendar.daysInMonthType.count
            }
        }
    }
    
    func checkSelectedDate(indexPath: IndexPath, calendarType: Bool) {
        selectedDate = "\(todoCalendar.calendarYear)/\(todoCalendar.calendarMonth)/"
        if calendarType {
            selectedDate += "\(todoCalendar.daysInWeekType[indexPath.item])"
        }
        else {
            selectedDate += "\(todoCalendar.daysInMonthType[indexPath.item])"
        }
        print("-> ",selectedDate)
    }
    
    func selectCalendarCell(indexPath: IndexPath, calendarType: Bool) {  //true if weektype else false
        checkSelectedDate(indexPath: indexPath, calendarType: calendarType)
        CalendarCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        //        todoListTableView.reloadData()
    }
    
    enum SelectedDayStatus {
        case selectableDate
        case ordinaryDay
    }
    
    func checkSelectedWeeklyStatus(currentDay: String) -> SelectedDayStatus {
        if todoListEdited && currentDay == editedTodoListDate {
            todoListEdited = false
            selectedDateConfirmed = true
            return .selectableDate
        }
        else if selectedDateConfirmed == false && currentDay == String(todoCalendar.currentDate.day) {
            return .selectableDate
        }
        else {
            return .ordinaryDay
        }
    }
    
    func confirmSelectedDate() -> Bool {
        if todoListEdited == false && selectedDateConfirmed == false {
            return true
        }
        else {
            return false
        }
    }
    
    func checkSelectedMonthlyStatus(currentDay: String, isTodayDate: Bool) -> SelectedDayStatus {
        // 새로운 셀 추가할 때 (AddTodoList)
        // TODO: 밑에 조건들보다 addcell하는 날짜가 더 앞에 있으면 밑에 조건들로 select 바뀜
        if todoListEdited && currentDay == editedTodoListDate { // 1
            todoListEdited = false
            selectedDateConfirmed = true
            return .selectableDate
        }
        // 오늘 날짜가 있으면 해당 날짜 select
        // selectedDateConfirmed false여야됨
        else if confirmSelectedDate() && isTodayDate && currentDay == String(todoCalendar.currentDate.day) {    // 2
            return .selectableDate
        }
        // 없으면 1일 select
        else if confirmSelectedDate() && currentDay == String(1) {  // 3
            return .selectableDate
        }
        else {
            return .ordinaryDay
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CalendarCollectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
        let isTodayDate = todoCalendar.isTodayDate()
        if indexPath.section == 0 {
            cell.initWeekdayCell(text: weeks[indexPath.item])
            return cell
        }
        
        //MARK: delegate 사용해서 custom cell view 안에다 함수 정의하기 OR MainViewcontroller에다 부분 정의
        //MARK: Constant calendarWeekType 타입 불리언 OR 스트링 -> Enum
        if Constant.calendarWeekType! {    // 일주일 단위로 보여줄 때 week type
            cell.initDayCell(currentDay: todoCalendar.daysInWeekType[indexPath.item], isTodayDate: isTodayDate, date: "\(todoCalendar.calendarYear)/\(todoCalendar.calendarMonth)")
            // if문도 불리언으로 값 전달
            switch checkSelectedWeeklyStatus(currentDay: todoCalendar.daysInWeekType[indexPath.item]) {
            case .selectableDate:
                selectCalendarCell(indexPath: indexPath, calendarType: true)
            default:
                cell.isSelected = false
                cell.DateLabel.textColor = UIColor.black
            }
        }
        else {  // 한달 단위로 보여줄 때 month type
            cell.initDayCell(currentDay: todoCalendar.daysInMonthType[indexPath.item], isTodayDate: isTodayDate, date: "\(todoCalendar.calendarYear)/\(todoCalendar.calendarMonth)")
            switch checkSelectedMonthlyStatus(currentDay: todoCalendar.daysInMonthType[indexPath.item], isTodayDate: isTodayDate) {
            case .selectableDate:
                selectCalendarCell(indexPath: indexPath, calendarType: false)
            default:
                cell.isSelected = false
                cell.DateLabel.textColor = UIColor.black
            }
        }
//        todoListTableView.reloadData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = CalendarCollectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
        checkSelectedDate(indexPath: indexPath, calendarType: Constant.calendarWeekType!)
        cell.isSelected = true
        print("리로드 1")
        todoListTableView.reloadData()
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

extension MainViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list = realm.objects(TodoList.self).filter("date == %@", selectedDate).sorted(byKeyPath: "order", ascending: true)
        print("개수", list.count)
        if addTodoListCellExist {
            return list.count + 1
        }
        return list.count
    }
    
    func becomeFirstResponderTextField() {
        print("vcvc")
        if let cell = todoListTableView.visibleCells.last {
            for view in cell.contentView.subviews {
                if let textfield = view as? UITextField {
                    print("텍스트필드 firstresponder")
                    textfield.becomeFirstResponder()
                    return
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let editedDateArray = selectedDate.components(separatedBy: "/")
        editedTodoListDate = editedDateArray[editedDateArray.count-1]
        
        if indexPath.row == list.count && addTodoListCellExist {
            let addCell = todoListTableView.dequeueReusableCell(withIdentifier: "AddTodoListTableViewCell", for: indexPath) as! AddTodoListTableViewCell
            addCell.initAddCell(date: selectedDate, order: list.count, id: Constant.todoPrimaryKey)
            Constant.todoPrimaryKey += 1
            addCell.newListDelegate = self
            // TODO: 메인 화면에서 함수 호출 -> cell 안에서 작동하게 하는 방법 찾기
            textFieldShouldReturn(addCell.AddTodoListTextField)
        
            addTodoListCellExist = false
            

            
            return addCell
        }
        
        let listCell = todoListTableView.dequeueReusableCell(withIdentifier: "TodoListTableViewCell", for: indexPath) as! TodoListTableViewCell
        list = realm.objects(TodoList.self).filter("date == %@", selectedDate).sorted(byKeyPath: "order", ascending: true)
        let currentTodoList = list[indexPath.row]
        listCell.initTodoCell(todolistDone: currentTodoList.checkbox, todoListContent: currentTodoList.todoContent, bookmarkCheck: currentTodoList.bookmark, alarmCheck: currentTodoList.alarm, todoId: currentTodoList.id)
        return listCell
    }
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        todoListTableView.estimatedRowHeight = todoListTableView.frame.width * 1/5
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath) as? TodoListTableViewCell) != nil {
            guard let vc = self.storyboard!.instantiateViewController(withIdentifier: "EditTodoListViewController") as? EditTodoListViewController else {return}
            selectedRow = indexPath.row
            // TODO: 데이터 전달 확인
            vc.todoContent = list[indexPath.row].todoContent
            vc.todoId = list[indexPath.row].id
            vc.todoBookmark = list[indexPath.row].bookmark
            vc.todoAlarm = list[indexPath.row].alarm
            vc.todoAlarmTime = list[indexPath.row].alarmTime
            vc.todoDate = list[indexPath.row].date
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

extension MainViewController: NewTodoListDelegate, EditTodoDelegate {
    func alertAlarmComplete() {
        self.presentBottomAlert(message: "알림이 설정되었습니다")
    }
    
    func reorderDeletedList() {
        let endIndex = list.count
        let startIndex = selectedRow
        try! realm.write {
            for index in startIndex..<endIndex {
                print(index)
                list[index].order -= 1
            }
        }
        // todo 아예 없으면 날짜 밑에 밑줄 없애기
        CalendarCollectionView.reloadData()
    }
    
    func makeNewTodoList() {
        list = realm.objects(TodoList.self).filter("date == %@", selectedDate).sorted(byKeyPath: "order", ascending: true)
        todoListEdited = true
        CalendarCollectionView.reloadData()
        todoListTableView.reloadData()
    }
    
    func revokeAddCell() {
        addTodoListCellExist = false
        todoListTableView.reloadData()
    }
}
