//
//  MyRoutineListVC.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/03/07.
//

import UIKit

class MyRoutineListVC: UIViewController {
    
    // MARK: IBOutlet
    
    var viewModel : RoutineListViewModel?
    let identifier = "MyRoutineListItemTableViewCell"
    
    // MARK: IBOutlet
    
    // header
    @IBOutlet var backButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    
    // table view
    @IBOutlet var routineTableView: UITableView!
    
    // new routine button
    @IBOutlet var routineCreateButtonView: UIView!
    @IBOutlet var routineCreateButton: UIButton!
    @IBOutlet var routinCreateImageView: UIImageView!
    @IBOutlet var routineCreateLabel: UILabel!
    
    
    @IBAction func routineCreateButtonDidTap(_ sender: Any) {
        // New Routine 버튼 클릭 시 Event
        
        let storyboard = UIStoryboard.init(name: "AddRoutine", bundle: nil)
        guard let newTab = storyboard.instantiateViewController(identifier: "MakeRoutineNameVC") as? MakeRoutineNameVC else {
            return
        }
        
        newTab.routineNameArray = viewModel?.routineNameArray()
        
        self.navigationController?.pushViewController(newTab, animated: true)
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setLayout()
        setDelegate()
    }
    
}

extension MyRoutineListVC {
    
    // MARK: function
    
    func setData() {
        // view model 을 통해 테이블뷰에 뿌려줄 아이템들을 가져와준다.
        if let token = UserDefaults.standard.string(forKey: "UserToken") {
            RoutineService().getRoutines(token: token) {
                routineList in
                // if getRoutine service failed,
                if let routineList = routineList {
                    self.viewModel = RoutineListViewModel(routines: routineList)
                }
                DispatchQueue.main.async {
                    self.routineTableView.reloadData()
                }
            }
        }
    }
    
    func setLayout() {
        
        // 네비게이션 바
        self.navigationController?.isNavigationBarHidden = true
        
        // 헤더
        backButton.setImage(UIImage(named: "icon32BackBlack"), for: .normal)
        headerLabel.setLabel(text: "나의 루틴", color: .black, font: .appleBold(size: 24))
        subLabel.setLabel(text: "루틴 카드로 쉽게 할 일을 추가하세요", color: .gray5, font: .appleRegular(size: 16))
        
        // table view
        routineTableView.separatorStyle = .none
        
        // new routine button
        routineCreateButtonView.setBorder(borderColor: .black, borderWidth: 3)
        routinCreateImageView.image = UIImage(named: "icon24PlusVisual")
        routineCreateLabel.setLabel(text: "New Routine", color: .black, font: .metroBold(size: 20))
    }
    
    func setDelegate() {
        routineTableView.dataSource = self
        routineTableView.delegate = self
    }
}

extension MyRoutineListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfRoutines ?? 0
    }
    
    // pacing between sections
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    // section header 를 투명하게 해준다.
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 각 섹션에 대해서 하나의 아이템만 넣어준다.
        return 1
    }
    
    // indexpath.row 가 아닌, section 으로 array 데이터를 가져와준다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MyRoutineListItemTableViewCell else { return UITableViewCell() }
        
        let routineVM = self.viewModel?.routineAtIndex(indexPath.section)
        cell.routineTitleLabel.text = routineVM?.title
        cell.routineImage.image = UIImage(named: routineVM?.categoryColorImageName ?? "")
        cell.routineElementsLabel.text = "\(routineVM?.numberOfTasks ?? 0)개의 할 일"
        return cell
    }
}

extension MyRoutineListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(named: "icon40DeleteWhite")
        deleteAction.backgroundColor = .color1
        
        let editAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            
            // edit 버튼 클릭 시 뷰 이동 Event
            
            let storyboard = UIStoryboard.init(name: "AddRoutine", bundle: nil)
            guard let newTab = storyboard.instantiateViewController(identifier: "SelectToDoVC") as? SelectToDoVC else {
                return
            }
            
            let routineVM = self.viewModel?.routineAtIndex(indexPath.section)
            newTab.routineName = routineVM?.title // 루틴 이름 넘겨주기
            
            newTab.selectedViewModel = routineVM!.rountineTaskList
            newTab.routineEditEnable = true
            // edit 버튼을 눌러서 왔다는 것을 알려주기 위한 bool 값
            
            self.navigationController?.pushViewController(newTab, animated: true)
            
            completionHandler(true)
        }
        
        editAction.image = UIImage(named: "icon32Edit")
        editAction.backgroundColor = .lightSalmon
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction, ])
        
        return configuration
    }
    
}
