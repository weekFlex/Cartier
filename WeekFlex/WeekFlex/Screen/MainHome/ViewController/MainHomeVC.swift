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

class MainHomeVC: UIViewController {
    
    
    //MARK: Variable
    var mainViewModel: MainHomeViewModel = MainHomeViewModel()
    var routineViewModel: MainRoutineListViewModel = MainRoutineListViewModel()
    var today: [String]!    //mmm-dd-e-eeee
    var currentDay: Int!
//    var startDayString: [String]! //mmm-dd-e-eeee
//    var startDay: Date!
    
    
    let weekDays: [String] = ["월","화","수","목","금","토","일"]
    let categories:[String] = ["1","3","3","8","1","0","0"]
    var shouldCollaps = true
    var isFloating = false
    let bag = DisposeBag()
    lazy var floatingStacks:[UIStackView] = [self.getRoutineStack, self.addTaskStack]
    lazy var dimView: UIView = {
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
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet var days: [UILabel]!
    @IBOutlet var stars: [UIImageView]!
    @IBOutlet var dates: [UILabel]!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    
    //MARK: IBAction
    
    @IBAction func buttonDidTap(_ sender: UIButton) {
        if shouldCollaps {
            animateView(isCollaps: false,  height: 0)
        }else {
            animateView(isCollaps: true,  height: 110)
        }
    }
    
    @IBAction func floatingBtnDidTap(_ sender: Any) {
        if isFloating {
            hideFloating()
        }else{
            showFloating()
        }
        isFloating = !isFloating
    }
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        
        setDate()
        setWeekly()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "routineCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
        super.viewDidLoad()
    }
}


//MARK: TableView
extension MainHomeVC: UITableViewDataSource,UITableViewDelegate {
    
    //스와이프 삭제 액션
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == .delete {
                
                routineViewModel.lists.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            } else if editingStyle == .insert {
                
            }
        }
    
    //셀 높이가 내용에 따라 동적으로 변하도록
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewModel.lists[currentDay].routines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "routineCell", for: indexPath) as! TableViewCell
        
        //루틴이름
        var cellData = mainViewModel.lists[currentDay].routines[indexPath.row]
        cell.title.text = "\(cellData.routineName)"
        let num = cellData.tasks.count
        
        for i in 0..<num {
            let view = Bundle.main.loadNibNamed("TaskListView", owner: self, options: nil)?.first as! TaskListView
            view.frame = cell.bounds
            view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            view.heightAnchor.constraint(equalToConstant: 63).isActive = true
            view.star.setImage(UIImage(named:cellData.tasks[i].category ), for: .normal)
            view.taskTitle.text = cellData.tasks[i].taskTitle
            view.time.text = cellData.tasks[i].time
            cell.stackView.translatesAutoresizingMaskIntoConstraints = false
            cell.stackView.addArrangedSubview(view)
            
        }
        
        cell.selectionStyle = .none
        
        
        let w = cell.stackView.frame.size.height
        let h = cell.stackView.frame.size.height
        
        
        print(indexPath.row, " = ", h)
        
        
        return cell
    }
    
    
}

extension MainHomeVC {
    
    
    
    //MARK: function
    private func setDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM-dd-e-EEEE"
        let day = formatter.string(from:Date())
        today = day.components(separatedBy: "-") // [0] = MMM, [1] = dd, [2] = e(1), [3] = EEEE(Sunday)
        currentDay = (Int(today[2]) ?? 2 + 5) % 7
        print(today[0],today[1],today[2],today[3])
    }
    
    
    private func setWeekly(){
        if(today[1] == "1") {
            todayLabel.text = today[0] + " " + today[1] + "st, " + today[3]
        }else if(today[1] == "2") {
            todayLabel.text = today[0] + " " + today[1] + "nd, " + today[3]
        }else {
            todayLabel.text = today![0] + " " + today[1] + "th, " + today[3]
        }
        
        //일주일 시작 요일 받기
        var i = 0
        for day in days {
            day.text = weekDays[i%7]
            i += 1
        }
        
        //일주일 시작 날짜 받기
        var j = 0
//        let ddFormatter = DateFormatter()
//        ddFormatter.dateFormat = "dd"
        
        for date in dates {
            let arr = mainViewModel.lists[0].date.components(separatedBy: "-")
            date.text = arr[1]
//            date.text = ddFormatter.string(from: Date(timeInterval: Double(86400 * j), since: startDay))
            j += 1
        }
        
        //가장 많은 카테고리 배열 받기
        
        var k = 0
        for star in stars {
            if(categories[k] == "0"){
                star.alpha = 0
            }else{
                star.image = UIImage(named: "icon24StarN"+categories[k])
            }
            
            k += 1
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
