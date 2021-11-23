//
//  MainHomeVC.swift
//  WeekFlex
//
//  Created by dohan on 2021/03/06.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import CoreData

class MainHomeVC: UIViewController {
    
    //MARK: Variable
    
    var weeklyData: [DailyData] = []
    var mainViewModel: MainHomeViewModel = MainHomeViewModel()
    
    
    var weekDate: [String] = [String](repeating: "", count: 7)
    var currentDay: Int = 0 {   //클릭된 현재 날짜인덱스 ( 0-6 )
        didSet {
            changeDate()    //클릭된 날짜 바뀌면 상단 날짜표시
            tableView.reloadData()  //바뀐 날짜로 테이블 리로드
            calendarCollectionView.reloadData()
        }
    }
    var representCategory: [Int] = [Int](repeating: -1, count: 7)
    let weekDays: [String] = ["월","화","수","목","금","토","일"]
    var shouldCollaps = true
    var isFloating = false
    var isDoneCheck = BehaviorRelay<Bool>(value:false)
    let bag = DisposeBag()
    lazy var floatingStacks:[UIStackView] = [self.getRoutineStack, self.addTaskStack]
    lazy var dimView: UIView = {    //플로팅버튼 배경
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.alpha = 0
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(view, belowSubview: self.floatingStackView)

        return view
    }()
    
    // noti
    let didDismissCreateTodoVC: Notification.Name = Notification.Name("didDismissCreateTodoVC")
    
    // 모달 뒤에 뜰 회색 전체 뷰
    var modalBackgroundView: UIView!
    
    //MARK: IBOutlet
    
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var expendedHeader: UIView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var foldingBtn: UIButton!
    @IBOutlet weak var floatingStackView: UIStackView!
    @IBOutlet weak var showFloatingBtn: UIButton!
    @IBOutlet weak var addTaskBtn: UIButton!
    @IBOutlet weak var getRoutineBtn: UIButton!
    @IBOutlet weak var getRoutineStack: UIStackView!
    @IBOutlet weak var addTaskStack: UIStackView!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: IBAction
    
    @IBAction func buttonDidTap(_ sender: UIButton) {       //Expended Header 펼치는 버튼
        if shouldCollaps {
            animateView(isCollaps: false,  height: 0)
        } else {
            animateView(isCollaps: true,  height: 110)
        }
    }
    
    @IBAction func floatingBtnDidTap(_ sender: Any) {       //우측 하단 플로팅 버튼
        if isFloating {
            hideFloating()
        } else {
            showFloating()
        }
    }
    
    @IBAction func addToDoBtnDidTap(_ sender: Any) {
        let editRoutineStoryboard = UIStoryboard.init(name: "EditRoutine", bundle: nil)
        guard let editRoutineVC = editRoutineStoryboard.instantiateViewController(identifier: "EditRoutineVC") as? EditRoutineVC else { return }
        editRoutineVC.modalTransitionStyle = .coverVertical
        editRoutineVC.modalPresentationStyle = .custom
        editRoutineVC.entryNumber = 3
        editRoutineVC.date = weeklyData[currentDay].date
        self.present(editRoutineVC, animated: true, completion: .none)
        clearPage()
    }
    
    @IBAction func getRoutineBtnDidtap(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
        let myRoutineStoryboard = UIStoryboard.init(name: "MyRoutine", bundle: nil)
        guard let myRoutineVC = myRoutineStoryboard.instantiateViewController(identifier: "MyRoutineListVC") as? MyRoutineListVC else { return }
        self.navigationController?.pushViewController(myRoutineVC, animated: true)
        clearPage()
    }
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissCreateTodoVC(_:)), name: didDismissCreateTodoVC, object: nil)
        UserDefaults.standard.setValue("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJpZFwiOjYsXCJlbWFpbFwiOlwiaHllcmluQG5hdmVyLmNvbVwifSJ9.ynmj6jnNo8vpqj5RnFHQ0UYP9kkxFFXqHw68ztuGTqo", forKey: "UserToken")
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "routineCell")
        tableView.register(UINib(nibName: "TodayTaskCell", bundle: nil), forCellReuseIdentifier: "todayCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        getRoutines()
        setDate()
        saveLastWeek()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first , touch.view == self.dimView {
            self.tabBarController?.tabBar.isHidden = false
            hideFloating()
        } }
}


//MARK: TableView
extension MainHomeVC: UITableViewDataSource,UITableViewDelegate {
    
    //스와이프 삭제 액션
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "이번주의 해당 루틴 전체가 삭제됩니다.", message: "이대로 삭제를 진행할까요?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "그만두기", style: .default, handler : nil)
            let delete = UIAlertAction(title: "삭제하기", style: .cancel) { (action) in
                if NetworkState.isConnected() {
                    // 네트워크 연결 시
                    if let token = UserDefaults.standard.string(forKey: "UserToken") {
                        let routineId = self.weeklyData[self.currentDay].items[indexPath.row].routineId
                        APIService.shared.deleteTodoRoutine(token, routineId: routineId ){ result in
                            switch result {
                            
                            case .success(_):
                                print("삭제완료")
                            case .failure(let error):
                                print(error)
                                print("오류!!")
                            }
                        }
                    }
                } else {
                    // 네트워크 미연결 팝업 띄우기
                    print("네트워크 미연결")
                }
                
                self.weeklyData[self.currentDay].items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.calendarCollectionView.reloadData()
                self.tableView.reloadData()
            }
            alert.addAction(delete)
            alert.addAction(cancel)
            present(alert,animated: false, completion: nil)
            
        }
    }
    
    //셀 높이가 내용에 따라 동적으로 변하도록
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = weeklyData[safe: currentDay] else {
            tableView.isHidden = true
            noDataView.isHidden = false
            return 0
        }
        
        if data.items.count == 0 {
            tableView.isHidden = true
            noDataView.isHidden = false
            return 0
        }
        
        tableView.isHidden = false
        noDataView.isHidden = true
        
        
        return data.items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = weeklyData[currentDay].items[indexPath.row]
        let num = cellData.todos.count
        
        if(indexPath.row == 0 && cellData.routineName == ""){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as? TodayTaskCell else { return UITableViewCell()}
            //셀(루틴) 안에 커스텀 뷰 추가(할일들)
            for i in 0..<num {
                
                let view = Bundle.main.loadNibNamed("TaskListView", owner: self, options: nil)?.first as! TaskListView
                let todo = cellData.todos[i]
                view.todoId = cellData.todos[i].id
                view.cellIndex = indexPath.row
                view.viewIndex = i
                view.delegate = self
                view.configure(with: todo )
                view.frame = cell.bounds
                if(todo.startTime == nil){
                    view.heightAnchor.constraint(equalToConstant: 35).isActive = true
                }else{
                    view.heightAnchor.constraint(equalToConstant: 51).isActive = true
                }
                
                
                cell.stackView.translatesAutoresizingMaskIntoConstraints = false
                cell.stackView.addArrangedSubview(view)
            }
            
            cell.selectionStyle = .none
            
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "routineCell", for: indexPath) as? TableViewCell else { return UITableViewCell()}
            
            cell.title.text = "\(cellData.routineName)"
            //셀(루틴) 안에 커스텀 뷰 추가(할일들)
            for i in 0..<num {
                
                let view = Bundle.main.loadNibNamed("TaskListView", owner: self, options: nil)?.first as! TaskListView
                let todo = cellData.todos[i]
                view.todoId = cellData.todos[i].id
                view.cellIndex = indexPath.row
                view.viewIndex = i
                view.delegate = self
                view.configure(with: todo )
                view.frame = cell.bounds
                if(todo.startTime == nil){
                    view.heightAnchor.constraint(equalToConstant: 35).isActive = true
                }else{
                    view.heightAnchor.constraint(equalToConstant: 51).isActive = true
                }
                
                
                cell.stackView.translatesAutoresizingMaskIntoConstraints = false
                cell.stackView.addArrangedSubview(view)
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

extension MainHomeVC: TaskListCellDelegate, EditPopUpDelegate {
    
    
    func didTabStar(cellIndex: Int, viewIndex: Int, isDone: Bool) {
        weeklyData[currentDay].items[cellIndex].todos[viewIndex].done = isDone
        calendarCollectionView.reloadData()
    }
    
    func didTabMeatBall(cellIndex: Int, viewIndex: Int, todoId: Int) {
        //todo 더보기 누르면
        //모달 화면 띄우기
        
        showDim(true)
        guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "EditVC") as? EditVC else { return }
        popupVC.taskTitle = weeklyData[currentDay].items[cellIndex].todos[viewIndex].name
        popupVC.delegate = self
        popupVC.cellIndex = cellIndex
        popupVC.viewIndex = viewIndex
        popupVC.todoId = todoId
        popupVC.modalPresentationStyle = .overFullScreen
        
        self.present(popupVC, animated: true, completion: nil)
    }
    
    func didTabEdit(cellIndex: Int, viewIndex: Int) {
        //수정 누르면
        self.dismiss(animated: true, completion: .none)
        modalAppeared()
        //민승이 뷰 띄우기!!
        let editRoutineStoryboard = UIStoryboard.init(name: "EditRoutine", bundle: nil)
        guard let editRoutineVC = editRoutineStoryboard.instantiateViewController(identifier: "EditRoutineVC") as? EditRoutineVC else { return }
        editRoutineVC.modalTransitionStyle = .coverVertical
        editRoutineVC.modalPresentationStyle = .custom
        editRoutineVC.entryNumber = 4
        editRoutineVC.cellIndex = cellIndex
        editRoutineVC.viewIndex = viewIndex
        editRoutineVC.saveTodoDataDelegate = self
        editRoutineVC.hideViewDelegate = self
        let data = weeklyData[currentDay].items[cellIndex].todos[viewIndex]
        editRoutineVC.todoData = data
        self.present(editRoutineVC, animated: true, completion: .none)
    }
    
    func modalAppeared() {
        modalBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: Int(view.bounds.width), height: Int(view.bounds.height)))
        modalBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.addSubview(modalBackgroundView)
    }
    
    func didTabDelete(cellIndex: Int, viewIndex:Int, todoId: Int) {
        //삭제 누르면
        showDim(false)
        weeklyData[currentDay].items[cellIndex].todos.remove(at: viewIndex)
        if weeklyData[currentDay].items[cellIndex].todos.count == 0 {
            weeklyData[currentDay].items.remove(at: cellIndex)
        }
        tableView.reloadData()
        calendarCollectionView.reloadData()
        
    }
    
}
extension MainHomeVC: SaveTodoProtocol, HideViewProtocol {
    // 할일 수정했을 때 가져오는 것
    func saveTodoProtocol(savedTodoData: TodoData, cellIndex: Int, viewIndex: Int) {
        print("성공! \(savedTodoData)  \(cellIndex)  \(viewIndex)")
        hideFloating()
        isFloating = !isFloating
        getRoutines() //네트워크 통신 한번더
        calendarCollectionView.reloadData() // 리로드
        tableView.reloadData() 
    }
    
    func hideViewProtocol() {
        modalBackgroundView.removeFromSuperview()
    }
    
}

extension MainHomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    //일주일 날짜 캘린더
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath)as? CalendarCell else { return CalendarCell()}
        cell.day.text = weekDays[indexPath.row]
        cell.date.text = weekDate[indexPath.row].components(separatedBy: "-")[1]
        
        if currentDay == indexPath.row {
            cell.bar.layer.opacity = 1
        }else{
            cell.bar.layer.opacity = 0
        }
        guard let itemViewModel = weeklyData[safe: indexPath.row] else { return cell }
        cell.configure(with: itemViewModel)
        //상단 날짜 표시 라벨과 날짜 하단 흰색 바
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                            indexPath: IndexPath) -> CGSize {
        let width = calendarCollectionView.frame.width / 7
        return CGSize(width: width, height: self.calendarCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentDay = indexPath.row
        self.calendarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
    }
}

extension MainHomeVC {
    
    //MARK: function
    private func getRoutines(){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let date = dateFormat.string(from:Date())
        if NetworkState.isConnected() {
            // 네트워크 연결 시
            if let token = UserDefaults.standard.string(forKey: "UserToken") {
                APIService.shared.getWeekly(token,date: date) { [self] result in
                    switch result {
                    case .success(let data):
                        weeklyData = data
                        for i in 0..<7 {
                            for j in 0..<weeklyData[i].items.count {
                                var data = weeklyData[i].items[j].todos
                                for k in 0..<data.count {
                                    weeklyData[i].items[j].todos[k].startTime = data[k].startTime?.changeTime()
                                    weeklyData[i].items[j].todos[k].endTime = data[k].endTime?.changeTime()
                                }
                            }
                        }
                        print(weeklyData)
                        
                        calendarCollectionView.reloadData()
                        tableView.reloadData()
                    // 데이터 전달 후 다시 로드
                    case .failure(let error):
                        print(error)
                        print("오류!!")
                    }
                }
            }
        } else {
            // 네트워크 미연결 팝업 띄우기
            print("네트워크 미연결")
        }
    }
    
    private func setDate() {
        // 오늘 요일 계산해서 weekdate에 일주일 날짜 채워넣음
        let startFormatter = DateFormatter()
        startFormatter.dateFormat = "e" // 일요일 1부터
        let date: Int = Int(startFormatter.string(from: Date())) ?? 1
        currentDay = (date + 5) % 7
        
        //startDay = 그 주 월요일(Date type)
        let startDay = Calendar.current.date(byAdding: .day, value: -(currentDay), to: Date())!
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM-dd-EEEE"
        
        for i in 0..<7 {
            let temp = Calendar.current.date(byAdding: .day, value: i, to: startDay)!
            weekDate[i] = formatter.string(from: temp)
        }
        changeDate()
    }
    
    //currentDay가 바뀔때마다 상단 날짜 라벨 text 바꿔줌
    private func changeDate() {
        let selectedDate = weekDate[currentDay].components(separatedBy: "-")
        if(selectedDate != [""]){
            if(selectedDate[1] == "1") {
                todayLabel.text = selectedDate[0] + " " + selectedDate[1] + "st, " + selectedDate[2]
            } else if(selectedDate[1] == "2") {
                todayLabel.text = selectedDate[0] + " " + selectedDate[1] + "nd, " + selectedDate[2]
            } else {
                todayLabel.text = selectedDate[0] + " " + selectedDate[1] + "th, " + selectedDate[2]
            }
        }
    }
    
   
    
    
    func saveLastWeek(){
        let save = CheckLastSave()
        save.check()
    }
    
    
    
    var buttonImg: UIImage {
        return shouldCollaps ? UIImage(named: "icon32UpWhite")!: UIImage(named: "icon32DownWhite" )!
    }
    
    private func animateView(isCollaps:Bool ,  height:Double){
        shouldCollaps = isCollaps
        headerHeight.constant = CGFloat(height)
        foldingBtn.setImage(buttonImg, for: .normal)
        UIView.animate(withDuration: 0.2){
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideFloating(){
        floatingStacks.reversed().forEach { stack in
            UIView.animate(withDuration: 0.2) {
                stack.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
        UIView.animate(withDuration: 0.2) {
            self.dimView.alpha = 0
            self.showFloatingBtn.transform = CGAffineTransform(rotationAngle: 0)
            
        }
        self.tabBarController?.tabBar.isHidden = false
        isFloating = !isFloating
    }
    
    private func showFloating(){
        floatingStacks.forEach { [weak self] stack in
            stack.isHidden = false
            stack.alpha = 0
            UIView.animate(withDuration: 0.2) {
                stack.alpha = 1
                self?.view.layoutIfNeeded()
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.tabBarController?.tabBar.isHidden = true
            self.dimView.isHidden = false
            self.dimView.alpha = 1
            self.showFloatingBtn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
        }
        isFloating = !isFloating
    }
    
    func showDim(_ isTrue: Bool){
        if isTrue{
            UIView.animate(withDuration: 0.3) {
                self.dimView.isHidden = false
                self.dimView.alpha = 1
                self.tabBarController?.tabBar.isHidden = true
            }
        }else {
            self.dimView.alpha = 0
            self.dimView.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
//            clearPage()
        }
        
    }
    
    private func clearPage(){
        floatingStacks.forEach { stack in
            stack.isHidden = true
            stack.alpha = 0     //다시 보여줄 때를 위해
        }
        isFloating = !isFloating
        self.dimView.alpha = 0
        self.showFloatingBtn.transform = CGAffineTransform(rotationAngle: 0)
    }
    
    // MARK: Method
    // 할일 추가했을 때!
    @objc func didDismissCreateTodoVC(_ noti: Notification) {
        clearPage()
        tabBarController?.tabBar.isHidden = false
        getRoutines() //네트워크 통신 한번더
        calendarCollectionView.reloadData() // 리로드
        tableView.reloadData() // 리로드
    }
    
}

class CheckLastSave {
    
    let lastSaveDate: String
    let key = "lastSaveDate"
    
    func firstDayOfWeek() -> String {
        let startFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        startFormatter.dateFormat = "e" // 일요일 1부터
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date: Int = Int(startFormatter.string(from: Date())) ?? 1
        let currentDay = (date + 5) % 7
        let startDay = Calendar.current.date(byAdding: .day, value: -(currentDay), to: Date())!
        let result = dateFormatter.string(from: startDay)
    
        return result
    }
    
    func sendStars(data:[DailyData]){
        var starArray : [Int] = []
        for d in data {
            var categoryCounter = [Int](repeating: 0, count: 16)
            
            for routine in d.items{
                for todo in routine.todos{
                    if todo.done {
                        categoryCounter[todo.categoryColor] += 1
                    }
                }
            }
            
            guard let categoryIndex = categoryCounter.firstIndex(of: categoryCounter.max() ?? 0) else { return  }
            starArray.append(categoryIndex)
        }
        
        
        if NetworkState.isConnected() {
            // 네트워크 연결 시
            
            if let token = UserDefaults.standard.string(forKey: "UserToken") {
                APIService.shared.createLastStars(token, starArray, self.lastSaveDate ) { result in
                    switch result {
                    case .success(let _):
                        print("회고별추가 성공")
                        UserDefaults.standard.set(self.firstDayOfWeek(), forKey: self.key)
                        for s in starArray {
                            print(s)
                        }
                    case .failure(let error):
                        print(error)
                        print("오류!!")
                    }
                }
            }
        } else {
            // 네트워크 미연결 팝업 띄우기
            print("네트워크 미연결")
        }
        
    }
    
    func getLastWeek(date:String) {
        var lastData:[DailyData] = []
        
        if NetworkState.isConnected() {
            // 네트워크 연결 시
            if let token = UserDefaults.standard.string(forKey: "UserToken") {
                APIService.shared.getWeekly(token, date: date) { result in
                    switch result {
                    case .success(let data):
                        lastData = data
                        
                        for w in lastData {
                            print(w.items.count)
                            if w.items.count == 0 { continue }
                            self.sendStars(data: lastData)
                            break
                        }
                        
                        print("지난주 불러오기성공")
                    case .failure(let error):
                        print(error)
                        print("오류!!")
                    }
                }
                
            
            }
            
        } else {
            // 네트워크 미연결 팝업 띄우기
            print("네트워크 미연결")
        }
        
    }
    
    func check(){
        
        if(lastSaveDate == "none"){
            UserDefaults.standard.set(firstDayOfWeek(), forKey: key)
        }else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let lastDate:Date = dateFormatter.date(from: lastSaveDate)!
            let interval = Date().timeIntervalSince(lastDate)
            let days = Int(interval/86400)
            if(days >= 7){
                getLastWeek(date: lastSaveDate)
                UserDefaults.standard.set(self.firstDayOfWeek(), forKey: self.key)
            }
        }
    }
    
    
    
    init(){
//        self.lastSaveDate = UserDefaults.standard.string(forKey: key) ?? "none"
        self.lastSaveDate = "2021-08-09"
    }
    
    
}
