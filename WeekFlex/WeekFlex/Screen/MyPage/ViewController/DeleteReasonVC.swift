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
    
    let bag = DisposeBag()
    
    
    @IBOutlet var reasonBtns: [UIButton]!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    
    @IBAction func didCheckReason(_ sender: UIButton) {
        for idx in 0..<reasonBtns.count {
            reasonBtns[idx].isSelected = false
        }
        self.view.endEditing(true)
        sender.isSelected = true
        deleteBtn.isEnabled = true
        deleteBtn.backgroundColor = .black
        UIView.animate(withDuration: 0.1, animations: {
            self.textView.alpha = 0
        }, completion: {_ in 
            self.textView.isHidden = true
        })
    }
    
    @IBAction func didCheckEtc(_ sender: UIButton) {
        for idx in 0..<reasonBtns.count {
            reasonBtns[idx].isSelected = false
        }
        self.view.endEditing(true)
        sender.isSelected = true
        self.textView.isHidden = false
        deleteBtn.isEnabled = true
        deleteBtn.backgroundColor = .black
        UIView.animate(withDuration: 0.1, animations: {
            self.textView.alpha = 1
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        textSetUp()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    func setLayout(){
        deleteBtn.layer.cornerRadius = 5
        textView.layer.cornerRadius = 5
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 15, bottom: 16, right: 16)
        textView.setBorder(borderColor: .gray1, borderWidth: 1)
    }
    
    func textSetUp(){
        
        textView.rx.didBeginEditing.subscribe(onNext: { [self] in
            if(self.textView.text == """
                        탈퇴 사유를 남겨주세요.
                        향후 서비스 개선을 위해 노력하겠습니다.
                        """ ){
                self.textView.text = nil
                self.textView.textColor = .gray5
            }
            
        }).disposed(by: bag)
        
        textView.rx.didEndEditing.subscribe(onNext: { [self] in
            
            if(textView.text == nil || textView.text == ""){
                textView.text = """
                        탈퇴 사유를 남겨주세요.
                        향후 서비스 개선을 위해 노력하겠습니다.
                        """
                textView.textColor = .gray3
            }
        })
    }
}
