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
    
    //MARK: IBOutlet
    
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var expendedHeader: UIView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var foldingBtn: UIButton!
    
    //MARK: IBAction
    
    @IBAction func buttonTap(_ sender: Any) {
        if shouldCollaps{
            animateView(isCollaps: false,  height: 0)
        }else {
            animateView(isCollaps: true,  height: 104)
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
}
