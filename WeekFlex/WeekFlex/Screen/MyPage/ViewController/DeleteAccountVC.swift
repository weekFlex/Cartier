//
//  MyPageVC.swift
//  WeekFlex
//
//  Created by dohan on 2021/05/29.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class DeleteAccountVC: UIViewController {
    
    let bag = DisposeBag()
    
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        didCheck()
    }
    
    func setLayout(){
        background.layer.cornerRadius = 5
        continueBtn.layer.cornerRadius = 5
        continueBtn.isEnabled = false
        
    }
    
    
    
    
    func didCheck(){
        //유의사항 동의버튼
        checkBtn.rx.tap
            .scan(false) { lastState, newState in
                !lastState
            }.subscribe(onNext:{ state in
                self.checkBtn.isSelected = state
                self.continueBtn.isEnabled = state
                if(state){
                    self.continueBtn.backgroundColor = .black
                    
                }else{
                    self.continueBtn.backgroundColor = .gray2
                }

            }).disposed(by: bag)
    }
    
    
}
