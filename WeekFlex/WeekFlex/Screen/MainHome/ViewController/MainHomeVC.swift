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
            print("currentDay: ",currentDay)
            changeDate()    //클릭된 날짜 바뀌면 상단 날짜표시
            tableView.reloadData()  //바뀐 날짜로 테이블 리로드
            calendarCollectionView.reloadData()
        }
    }
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
        self.view.insertSubview(view, belowSubview: self.floatingStackView)
        return view
    }()
    
    
    
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
        }else {
            animateView(isCollaps: true,  height: 110)
        }
    }
    
    @IBAction func floatingBtnDidTap(_ sender: Any) {       //우측 하단 플로팅 버튼
        if isFloating {
            hideFloating()
        }else{
            showFloating()
        }
        isFloating = !isFloating
    }
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad()")
        UserDefaults.standard.setValue("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJpZFwiOjYsXCJlbWFpbFwiOlwiaHllcmluQG5hdmVyLmNvbVwifSJ9.ynmj6jnNo8vpqj5RnFHQ0UYP9kkxFFXqHw68ztuGTqo", forKey: "UserToken")
        
        //        "accessToken": "exy.asdfgfafasfg",
        //        "code": "dsagvbfqwerdsaxc",
        //        "email": "hyerin@naver.com",
        //        "name": "김혜린",
        //        "signupType": "KAKAO"
        
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "routineCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        getRoutines()
        setDate()
    }
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
                        print("network연결")
                        let routineId = self.weeklyData[self.currentDay].items[indexPath.row].routineId
                        print("routineId: ",routineId)
                        APIService.shared.deleteTodoRoutine(token, routineId: routineId ){ result in
                            switch result {
                            
                            case .success(let data):
                                print("삭제완료: ", data)
                                
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
                
                self.weeklyData[self.currentDay].items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
            
            alert.addAction(cancel)
            alert.addAction(delete)
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "routineCell", for: indexPath) as? TableViewCell else { return UITableViewCell()}
        
        //루틴이름
        let cellData = weeklyData[currentDay].items[indexPath.row]
        cell.title.text = "\(cellData.routineName)"
        let num = cellData.todos.count
        
        //셀(루틴) 안에 커스텀 뷰 추가(할일들)
        for i in 0..<num {
            let view = Bundle.main.loadNibNamed("TaskListView", owner: self, options: nil)?.first as! TaskListView
            
            view.todoId = cellData.todos[i].id
            view.cellIndex = indexPath.row
            view.viewIndex = i
            view.delegate = self
            view.frame = cell.bounds
            view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            view.heightAnchor.constraint(equalToConstant: 63).isActive = true
            let todo = cellData.todos[i]
            //            guard let todo = cellData.todos[i] else {
            //                print("에러: cellData nill값")
            //                return cell }
            view.configure(with: todo )
            cell.stackView.translatesAutoresizingMaskIntoConstraints = false
            cell.stackView.addArrangedSubview(view)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}

extension MainHomeVC:  TaskListCellDelegate, EditPopUpDelegate {
    
    
    
    
    func didTabStar(cellIndex: Int, viewIndex: Int, isDone: Bool) {
        
        isDoneCheck.asObservable()
            .debounce(.seconds(4), scheduler: MainScheduler.asyncInstance )
            .subscribe(onNext: { (_) in
                print("한번만눌러")
            }).disposed(by: bag)
        print("star")
    }
    
    func didTabMeatBall(cellIndex: Int, viewIndex: Int, todoId: Int) {
        //todo 더보기 누르면
        print("meatBall")
        guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "EditPopUpVC") as? EditPopUpVC else { return }
        popupVC.delegate = self
        //        popupVC.taskTitle = mainViewModel.lists[currentDay].routines[cellIndex].tasks[cellIndex].taskTitle
        popupVC.todoId = todoId
        popupVC.modalPresentationStyle = .overCurrentContext
        //모달 화면 띄우기
        self.present(popupVC, animated: true, completion: nil)
    }
    
    func didTabEdit(cellIndex: Int, viewIndex: Int) {
        //수정 누르면
        print("edit")
    }
    
    func didTabDelete(cellIndex: Int, viewIndex:Int, todoId: Int) {
        //삭제 누르면
        print("delete")
        weeklyData[currentDay].items[cellIndex].todos.remove(at: viewIndex)
        tableView.reloadData()
        
    }
}

extension MainHomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
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
        print("getRoutines()")
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let date = dateFormat.string(from:Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        
        if NetworkState.isConnected() {
            // 네트워크 연결 시
            if let token = UserDefaults.standard.string(forKey: "UserToken") {
                
                APIService.shared.getWeekly(token,date: date) { [self] result in
                    switch result {
                    
                    case .success(let data):
                        print(data)
                        weeklyData = data
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
        print("먼대")
    }
    
    
    
    
    private func setDate(){
        // 오늘 요일 계산해서 weekdate에 일주일 날짜 채워넣음
        let startFormatter = DateFormatter()
        startFormatter.dateFormat = "e" // 일요일 1부터
        let date: Int = Int(startFormatter.string(from: Date())) ?? 1
        currentDay = (date + 5) % 7

        //startDay = 그 주 월요일(Date type)
        let startDay = Calendar.current.date(byAdding: .day, value: -(currentDay), to: Date())!
        
//        //오류나서 임시
//        let date: Int = Int(startFormatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)) ?? 1
//        currentDay = (date + 5) % 7
//        let startDay = Calendar.current.date(byAdding: .day, value: -(currentDay), to: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)!
//        ///
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM-dd-EEEE"
        
        for i in 0..<7 {
            let temp = Calendar.current.date(byAdding: .day, value: i, to: startDay)!
            weekDate[i] = formatter.string(from: temp)
        }
        
        changeDate()
        
        
        
    }
    
    //currentDay가 바뀔때마다 상단 날짜 라벨 text 바꿔줌
    private func changeDate(){
        
        let selectedDate = weekDate[currentDay].components(separatedBy: "-")
        if(selectedDate != [""]){
            if(selectedDate[1] == "1") {
                todayLabel.text = selectedDate[0] + " " + selectedDate[1] + "st, " + selectedDate[2]
            }else if(selectedDate[1] == "2") {
                todayLabel.text = selectedDate[0] + " " + selectedDate[1] + "nd, " + selectedDate[2]
            }else {
                todayLabel.text = selectedDate[0] + " " + selectedDate[1] + "th, " + selectedDate[2]
            }
        }
        
        
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
            self.dimView.isHidden = false
            self.dimView.alpha = 1
            self.showFloatingBtn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
            
        }
    }
}
