//
//  MyRoutineListVC.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/03/07.
//

import UIKit

class MyRoutineListVC: UIViewController {

    // MARK: IBOutlet
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    @IBOutlet var routineTableView: UITableView!
    @IBOutlet var routineCreateButton: UIView!
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
}

extension MyRoutineListVC {
    
    // MARK: function
    
    func setLayout() {
        backButton.setImage(UIImage(named: "icon32BackBlack"), for: .normal)
        headerLabel.setLabel(text: "나의 루틴", color: .black, font: .appleBold(size: 24))
        subLabel.setLabel(text: "루틴 카드로 쉽게 할 일을 추가하세요", color: .gray5, font: .appleRegular(size: 16))
        
    }
}
