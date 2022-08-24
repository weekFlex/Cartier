//
//  MyRoutineListVC.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/03/07.
//

import UIKit
import SnapKit

class MyRoutineListVC: UIViewController {
    
    // MARK: - Property
    var viewModel : RoutineListViewModel?
    var userType: UserType = .existingUser
    let identifier = "MyRoutineListItemTableViewCell"
    private let didDismissCreateTodoVC: Notification.Name = Notification.Name("didDismissCreateTodoVC")
    private lazy var launchTooltipView = MyTopTipView(
        viewColor: UIColor.black,
        tipStartX: 118.0,
        tipWidth: 14.0,
        tipHeight: 9.0,
        text: "일주일을 위한 첫 루틴을 생성해보세요",
        state: .up,
        dismissActions: tooltipAction
    )
    private lazy var secondTooltipView = MyTopTipView(
        viewColor: UIColor.black,
        tipStartX: 118.0,
        tipWidth: 14.0,
        tipHeight: 9.0,
        text: "이번주 일정에 루틴을 추가해주세요!",
        state: .down(height: 35.0),
        dismissActions: tooltipAction
    )
    
    // MARK: @IBOutlet
    @IBOutlet var backButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    
    @IBOutlet var routineTableView: UITableView!
    
    @IBOutlet var routineCreateButtonView: UIView!
    @IBOutlet var routineCreateButton: UIButton!
    @IBOutlet var routinCreateImageView: UIImageView!
    @IBOutlet var routineCreateLabel: UILabel!
    
    // MARK: @IBAction
    @IBAction func routineCreateButtonDidTap(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "AddRoutine", bundle: nil)
        guard let newTab = storyboard.instantiateViewController(identifier: "MakeRoutineNameVC") as? MakeRoutineNameVC else {
            return
        }
        newTab.routineNameArray = viewModel?.routineNameArray()
        newTab.userType = userType
        self.navigationController?.pushViewController(newTab, animated: true)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setData()
        setUserType()
    }
}

// MARK: - Layout
extension MyRoutineListVC {
    func setLayout() {
        // 네비게이션 바
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        // 헤더
        backButton.setImage(UIImage(named: "icon32BackBlack"), for: .normal)
        headerLabel.setLabel(text: "나의 루틴", color: .black, font: .appleBold(size: 24))
        subLabel.setLabel(text: "루틴 카드로 쉽게 할 일을 추가하세요", color: .gray5, font: .appleRegular(size: 16))
        
        // table view
        routineTableView.separatorStyle = .none
        routineTableView.showsVerticalScrollIndicator = false
        // new routine button
        routineCreateButtonView.setBorder(borderColor: .black, borderWidth: 3)
        routinCreateImageView.image = UIImage(named: "icon24PlusVisual")
        routineCreateLabel.setLabel(text: "New Routine", color: .black, font: .metroBold(size: 20))
    }
    
    func setDelegate() {
        routineTableView.dataSource = self
        routineTableView.delegate = self
    }
    
    func setUserType() {
        switch userType {
        case .newUser(let level):
            addTooltip(level)
        case .existingUser:
            break
        }
    }
    
    func addTooltip(_ level: Int) {
        switch level {
        case 1:
            let sender = self.launchTooltipView
            self.view.addSubview(sender)
            
            sender.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(routineCreateButtonView.snp.bottom).inset(-17)
                $0.width.equalTo(250.0)
                $0.height.equalTo(35.0)
            }
        case 2:
            let sender = self.secondTooltipView
            self.view.addSubview(sender)
            self.launchTooltipView.removeFromSuperview()
            sender.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(routineTableView.snp.top).inset(-20)
                $0.width.equalTo(234.0)
                $0.height.equalTo(35.0)
            }
        default:
            break
        }
    }
    
    func tooltipAction() {
        UIView.transition(with: self.view,
                          duration: 0.25,
                          options: [.transitionCrossDissolve],
                          animations: { self.launchTooltipView.removeFromSuperview() },
                          completion: { _ in
        })
        
        UIView.transition(with: self.view,
                          duration: 0.25,
                          options: [.transitionCrossDissolve],
                          animations: { self.secondTooltipView.removeFromSuperview() },
                          completion: { _ in
        })
    }
}

// MARK: - Network
extension MyRoutineListVC {
    func setData() {
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
}

// MARK: - UITableViewDataSource
extension MyRoutineListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfRoutines ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MyRoutineListItemTableViewCell else { return UITableViewCell() }
        
        let routineVM = self.viewModel?.routineAtIndex(indexPath.section)
        cell.routineTitleLabel.text = routineVM?.title
        cell.routineImage.image = UIImage(named: routineVM?.categoryColorImageName ?? "")
        cell.routineElementsLabel.text = "\(routineVM?.numberOfTasks ?? 0)개의 할 일"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let routineVM = self.viewModel?.routineAtIndex(indexPath.section)
        if let token = UserDefaults.standard.string(forKey: "UserToken"),
           let ID = routineVM?.ID {
            APIService.shared.registerRoutine(token, routineID: ID) { result in
                switch result {
                case .success(_):
                    NotificationCenter.default.post(name: self.didDismissCreateTodoVC, object: nil, userInfo: nil) // 전 뷰에서 데이터 로드를 다시 하게 만들기 위해 Notofication post!
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "해당 루틴은\n이미 등록되어있습니다!", message: nil, preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "넹넹구리면", style: .default, handler : nil)
                    alert.addAction(cancel)
                    self.present(alert,animated: false, completion: nil)
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension MyRoutineListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            let routineVM = self.viewModel?.routineAtIndex(indexPath.section)
            let alert = UIAlertController(title: "\(routineVM?.title ?? "") 루틴을\n정말 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "그만두기", style: .default, handler : nil)
            let delete = UIAlertAction(title: "삭제하기", style: .destructive) { UIAlertAction in
                if let token = UserDefaults.standard.string(forKey: "UserToken"),
                   let ID = routineVM?.ID {
                    print(ID)
                    APIService.shared.deleteRoutine(token, routineID: ID) { result in
                        switch result {
                        case .success(_):
                            NotificationCenter.default.post(name: self.didDismissCreateTodoVC, object: nil, userInfo: nil) // 전 뷰에서 데이터 로드를 다시 하게 만들기 위해 Notofication post!
                            self.setData()
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
            alert.addAction(cancel)
            alert.addAction(delete)
            self.present(alert,animated: false, completion: nil)
            
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
