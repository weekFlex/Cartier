//
//  MainHomeVC.swift
//  WeekFlex
//
//  Created by dohan on 2021/03/06.
//

import Foundation
import UIKit

class MainHomeVC: UIViewController {
    
    //MARK: Variable
    
    private var shouldCollaps = false
    var isFloating = false
    lazy var floatings: [UIButton] = [self.addTaskBtn, self.getRoutineBtn]
   

    
    //MARK: IBOutlet
    
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var expendedHeader: UIView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var foldingBtn: UIButton!
    @IBOutlet weak var floatingStackView: UIStackView!
    @IBOutlet weak var showFloatingBtn: UIButton!
    @IBOutlet weak var addTaskBtn: UIButton!
    @IBOutlet weak var getRoutineBtn: UIButton!
    
    
    
    //MARK: IBAction
    
    @IBAction func buttonDidTap(_ sender: UIButton) {
        if shouldCollaps {
            animateView(isCollaps: false,  height: 0)
        }else {
            animateView(isCollaps: true,  height: 104)
        }
    }
    @IBAction func floatingBtnDidTap(_ sender: Any) {
        if isFloating {
            hideFloating()
        }else{
            showFloating()
        }
        
        isFloating = !isFloating
        UIView.animate(withDuration: 0.3) {
            showFloatingBtn.transform = roatation
                }
    }
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    
}


extension MainHomeVC {
    
    //MARK: function
    
    var buttonTitle: String {
        return shouldCollaps ? "hide" : "show"
    }
    
    private func animateView(isCollaps:Bool ,  height:Double){
        shouldCollaps = isCollaps
        headerHeight.constant = CGFloat(height)
        foldingBtn.setTitle(buttonTitle, for: .normal)
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideFloating(){
        floatings.reversed().forEach { button in
            UIView.animate(withDuration: 0.3) {
                button.isHidden = true
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    private func showFloating(){
        floatings.forEach { [weak self] button in
            button.isHidden = false
            button.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                button.alpha = 1
                self?.view.layoutIfNeeded()
            }
        }
    }
}
