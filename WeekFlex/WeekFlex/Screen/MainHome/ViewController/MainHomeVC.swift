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
    var today: [String]!    //mmm-dd-e-eeee
    var currentDay: Int = 0 {   //클릭된 현재 날짜인덱스 ( 0-6 )
        didSet {
            changeDate()    //상단 날짜표시
            tableView.reloadData()
            calendarCollectionView.reloadData()
        }
    }
    let weekDays: [String] = ["월","화","수","목","금","토","일"]
    var shouldCollaps = true
    var isFloating = false
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
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "routineCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        setDate()
        getRoutines()
        
        
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
                self.mainViewModel.lists[self.currentDay].routines.remove(at: indexPath.row)
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
        if mainViewModel.lists[currentDay].routines.count == 0 {
            tableView.isHidden = true
            noDataView.isHidden = false
            return 0
        }

        return mainViewModel.lists[currentDay].routines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "routineCell", for: indexPath) as! TableViewCell
        
        //루틴이름
        let cellData = weeklyData[currentDay].items[indexPath.row]
        cell.title.text = "\(cellData.routineName)"
        let num = cellData.todos.count
        
        //셀(루틴) 안에 커스텀 뷰 추가(할일들)
        for i in 0..<num {
            let view = Bundle.main.loadNibNamed("TaskListView", owner: self, options: nil)?.first as! TaskListView
            
            view.cellIndex = indexPath.row
            view.viewIndex = i
            view.delegate = self
            view.frame = cell.bounds
            view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            view.heightAnchor.constraint(equalToConstant: 63).isActive = true
            view.configure(with: cellData.todos[i])
            cell.stackView.translatesAutoresizingMaskIntoConstraints = false
            cell.stackView.addArrangedSubview(view)
            
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}

extension MainHomeVC:  TaskListCellDelegate, EditPopUpDelegate {
    
    func didTabStar(cellIndex: Int, viewIndex: Int, isDone: Bool) {
        print("star")
    }
    
    func didTabMeatBall(cellIndex: Int, viewIndex: Int) {
        print("meatBall")
        guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "EditPopUpVC") as? EditPopUpVC else { return }
        popupVC.delegate = self
        popupVC.taskTitle = mainViewModel.lists[currentDay].routines[cellIndex].tasks[cellIndex].taskTitle
        popupVC.cellIndex = cellIndex
        popupVC.viewIndex = viewIndex
        popupVC.modalPresentationStyle = .overCurrentContext
        //모달 화면 띄우기
        self.present(popupVC, animated: true, completion: nil)
    }
    
    func didTabEdit(cellIndex: Int, viewIndex: Int) {
        print("edit")
    }
    
    func didTabDelete(cellIndex: Int, viewIndex: Int) {
        print("delete")
        
    }
}

extension MainHomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath)as? CalendarCell else { return CalendarCell()}
        let itemViewModel = mainViewModel.lists[indexPath.row]
        cell.configure(with: itemViewModel)
        //상단 날짜 표시 라벨과 날짜 하단 흰색 바
        cell.day.text = weekDays[indexPath.row]
        if currentDay == indexPath.row {
            cell.bar.layer.opacity = 1
        }else{
            cell.bar.layer.opacity = 0
        }
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
        if NetworkState.isConnected() {
            // 네트워크 연결 시
            if let token = UserDefaults.standard.string(forKey: "UserToken") {
                
                APIService.shared.getWeekly(token) { [self] result in
                    switch result {
                    
                    case .success(let data):
                        weeklyData = data
                        print(data)
                        calendarCollectionView.reloadData()
                        // 데이터 전달 후 다시 로드
                        
                    case .failure(let error):
                        print(error)
                        
                    }
                }
            }
        } else {
            // 네트워크 미연결 팝업 띄우기
            
        }
    }
    
    
    
    
    private func setDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM-dd-e-EEEE"
        let day = formatter.string(from:Date())
        today = day.components(separatedBy: "-") // [0] = MMM, [1] = dd, [2] = e(1), [3] = EEEE(Sunday)
        
        if(today[1] == "1") {
            todayLabel.text = today[0] + " " + today[1] + "st, " + today[3]
        }else if(today[1] == "2") {
            todayLabel.text = today[0] + " " + today[1] + "nd, " + today[3]
        }else {
            todayLabel.text = today![0] + " " + today[1] + "th, " + today[3]
        }
        
        if let a = Int(today[2]) {
            currentDay = ( a + 5 ) % 7
        }
        
    }
    
    private func changeDate(){
        
        let selectedDate = mainViewModel.lists[currentDay].date.components(separatedBy: "-")
        if(selectedDate[1] == "1") {
            todayLabel.text = selectedDate[0] + " " + selectedDate[1] + "st, " + selectedDate[2]
        }else if(today[1] == "2") {
            todayLabel.text = selectedDate[0] + " " + selectedDate[1] + "nd, " + selectedDate[2]
        }else {
            todayLabel.text = selectedDate[0] + " " + selectedDate[1] + "th, " + selectedDate[2]
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
