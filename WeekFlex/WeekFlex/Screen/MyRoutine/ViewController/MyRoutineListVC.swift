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
        routineTableViewHeight.constant = CGFloat(count*90)
        print(count)
        
        // new routine button
        routineCreateButtonView.setBorder(borderColor: .black, borderWidth: 3)
        routinCreateImageView.image = UIImage(named: "icon24PlusVisual")
        routineCreateLabel.setLabel(text: "New Routine", color: .black, font: .metroBold(size: 20))
    }
    
    func setDelegate() {
        routineTableView.dataSource = self
        
    }
}

extension MyRoutineListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel?.items.count else { return 0 }

        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MyRoutineListItemTableViewCell else { return UITableViewCell() }
        
        guard let itemViewModel = viewModel?.items[indexPath.row] else { return UITableViewCell() }
        
        cell.configure(withViewModel: itemViewModel, index: indexPath.row)
        
        return cell
    }
    
    
}
