//
//  DeleteReasonVC.swift
//  WeekFlex
//
//  Created by dohan on 2021/05/31.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class DeleteReasonVC: UIViewController{
    @IBOutlet var reasonBtns: [UIButton]!
    @IBOutlet weak var deleteBtn: UIButton!
    
    
    @IBAction func didCheckReason(_ sender: UIButton) {
        for idx in 0..<reasonBtns.count {
            reasonBtns[idx].isSelected = false
        }
        sender.isSelected = true
        deleteBtn.isEnabled = true
        deleteBtn.backgroundColor = UIColor(displayP3Red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteBtn.layer.cornerRadius = 8
    }
}
