//
//  MyRoutineListVC.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/03/07.
//

import UIKit

class MyRoutineListVC: UIViewController {
    
    // MARK: IBOutlet
    
    var viewModel : MyRoutineListViewModel?
    let identifier = "MyRoutineListItemTableViewCell"
    
    // MARK: IBOutlet
    
    // header
    @IBOutlet var backButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    
    // table view
    @IBOutlet var routineTableView: UITableView!
    @IBOutlet var routineTableViewHeight: NSLayoutConstraint!
    
    // new routine button
    @IBOutlet var routineCreateButtonView: UIView!
    @IBOutlet var routinCreateImageView: UIImageView!
    @IBOutlet var routineCreateLabel: UILabel!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MyRoutineListViewModel()
        setLayout()
        setDelegate()
        // view model 을 통해 테이블뷰에 뿌려줄 아이템들을 가져와준다.
    }
    
}

extension MyRoutineListVC {
    
    // MARK: function
    
    func setLayout() {
        
        // 네비게이션 바
        self.navigationController?.isNavigationBarHidden = true
        
        // 헤더
        backButton.setImage(UIImage(named: "icon32BackBlack"), for: .normal)
        headerLabel.setLabel(text: "나의 루틴", color: .black, font: .appleBold(size: 24))
        subLabel.setLabel(text: "루틴 카드로 쉽게 할 일을 추가하세요", color: .gray5, font: .appleRegular(size: 16))
        
        // table view
        routineTableView.separatorStyle = .none
        let count = viewModel?.items.count ?? 0
        routineTableViewHeight.constant = CGFloat(count*98)
        
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
        guard let count = viewModel?.items.count else { return 0 }
        return count
    }
    
    // pacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    // section header 를 투명하게 해준다.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
        
        guard let itemViewModel = viewModel?.items[indexPath.section] else { return UITableViewCell() }
        
        cell.configure(withViewModel: itemViewModel, index: indexPath.section)
        
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
            completionHandler(true)
        }
        editAction.image = UIImage(named: "icon32Edit")
        editAction.backgroundColor = .lightSalmon
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction, ])
        
        return configuration
    }
}
