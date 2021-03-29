//
//  MainHomeVC.swift
//  WeekFlex
//
//  Created by dohan on 2021/03/06.
//

import Foundation
import UIKit
import RxSwift

class MainHomeVC: UIViewController {
    
    
    //MARK: Variable
    var routineViewModel: MainRoutineListViewModel = MainRoutineListViewModel()
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
    
    @IBOutlet weak var today: UILabel!
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
        
        setWeekly()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "routineCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        super.viewDidLoad()
    }
}

extension MainHomeVC: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == .delete {
                
                routineViewModel.lists.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            } else if editingStyle == .insert {
                
            }
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineViewModel.lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "routineCell", for: indexPath) as! TableViewCell
        cell.title.text = "\(routineViewModel.lists[indexPath.row].routineName)"
        let num = routineViewModel.lists[indexPath.row].tasks.count
        
        for _ in 0..<num {
            let view = Bundle.main.loadNibNamed("TaskListView", owner: self, options: nil)?.first as! TaskListView
            view.frame = cell.bounds
            view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            view.heightAnchor.constraint(equalToConstant: 63).isActive = true
            cell.stackView.translatesAutoresizingMaskIntoConstraints = false
            cell.stackView.addArrangedSubview(view)
            
            
            //            let item = routineViewModel.lists[indexPath.row].todos[i]
            //            var taskView = TaskListView(frame: self.view.frame)
            //
            //            taskView.star.image = UIImage(named: "icon24StarN" + "\(item.category)")
            //            taskView.taskTitle.text = item.todoTitle
            //            taskView.time.text = "\(String(describing: item.startTime))" + "-" + "\(String(describing: item.endTime))"
            //            print(self.view)
            //            self.view.addSubview(taskView)
            
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
    
    
    
    //    private func bindTableView(){
    //        let cities = ["London", "Vienna", "Lisbon"]
    //
    //        let citiesOb: Observable<[String]> = Observable.of(cities)
    //
    //        citiesOb.bind(to: tableView.rx.items(cellIdentifier: "routineCell", cellType: RoutineCell.self)) { index, model, cell in
    //            cell.title.text = model
    //
    //        }.disposed(by: bag)
    //
    //    }
    //
    private func setWeekly(){
        today.text = "Jan 15th, Friday"
        
        //일주일 시작 요일 받기
        var i = 0
        for day in days {
            day.text = weekDays[i]
            i += 1
        }
        
        //일주일 시작 날짜 받기
        var j = 0
        for date in dates {
            date.text = String(j+1)
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
