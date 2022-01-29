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
import Alamofire

class DeleteReasonVC: UIViewController{
    
    
    let types = ["NOT_USED_OFTEN", "UNCOMFORTABLE", "LACK_BENEFITS", "OTHER_SERVICE", "ETC"]
    var selectedType = ""
    var details = ""
    let defaultEtc = """
                        탈퇴 사유를 남겨주세요.
                        향후 서비스 개선을 위해 노력하겠습니다.
                        """
    let bag = DisposeBag()
    
    
    @IBOutlet var reasonBtns: [UIButton]!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    
    @IBAction func didCheckReason(_ sender: UIButton) {         //기타 제외 다른 선택지 클릭
        self.view.endEditing(true)
        for idx in 0..<reasonBtns.count {
            reasonBtns[idx].isSelected = false
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.textView.alpha = 0
        }, completion: {_ in
            self.textView.isHidden = true
        })
        sender.isSelected = true
        deleteBtn.isEnabled = true
        deleteBtn.backgroundColor = .black
        selectedType = types[reasonBtns.firstIndex(of: sender) ?? 0]
        details = ""
    }
    
    @IBAction func didCheckEtc(_ sender: UIButton) {            //기타 클릭
        for idx in 0..<reasonBtns.count {
            reasonBtns[idx].isSelected = false
        }
        self.view.endEditing(true)
        sender.isSelected = true
        self.textView.isHidden = false
        if(textView.text == defaultEtc){
            deleteBtn.isEnabled = false
            deleteBtn.backgroundColor = .gray2
        }else{
            details = textView.text
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.textView.alpha = 1
        })
        selectedType = types[4]
    }
    
    @IBAction func didTabBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTabDeleteAccountBtn(_ sender: Any) {
        
        let actionSheetController = UIAlertController(title: """
                탈퇴하기를 누르면 되돌릴 수 없습니다.
                정말 탈퇴 하시겠습니까?
                """, message: nil, preferredStyle: .actionSheet )
        
        let actionDelete = UIAlertAction(title: "탈퇴하기" , style: .destructive, handler: {action in
            if NetworkState.isConnected() {
                UserDefaults.standard.setValue("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJpZFwiOjEwLFwiZW1haWxcIjpcInR0QHR0LnR0dFwifSJ9.QFgB-A5HvA1H4Bawt5SqhuDiEHc9rp3f6JlCk1GPYys", forKey: "UserToken")
                
                if let token = UserDefaults.standard.string(forKey: "UserToken") {
                    
                    
                    APIService.shared.deleteAccount(token, self.details, self.selectedType ){ result in
                        switch result {
                            
                        case .success(_):
                            print("탈퇴 완료")
                        case .failure(let error):
                            print(error)
                            print("탈퇴오류!!")
                        }
                    }
                }
            } else {
                print("네트워크 미연결")
            }
            
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        actionSheetController.addAction(actionDelete)
        actionSheetController.addAction(cancel)
        
        self.present(actionSheetController, animated: true, completion: nil)
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
        deleteBtn.backgroundColor = .gray2
        textView.layer.cornerRadius = 5
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 15, bottom: 16, right: 16)
        textView.setBorder(borderColor: .gray1, borderWidth: 1)
    }
    
    func textSetUp(){
        
        textView.rx.didBeginEditing
            .subscribe(onNext: { [self] in
            if(textView.text == defaultEtc ){
                textView.text = nil
                textView.textColor = .gray5
                
            }}).disposed(by: bag)
        
        textView.rx.didEndEditing
            .subscribe(onNext: { [self] in
            if(textView.text == nil || textView.text == ""){
                textView.text = defaultEtc
                textView.textColor = .gray3
                deleteBtn.isEnabled = false
                deleteBtn.backgroundColor = .gray2
            }}).disposed(by: bag)
        
        
        textView.rx.text.subscribe(onNext: { [self] _ in
            if(textView.text == "" || textView.text == defaultEtc){
                deleteBtn.isEnabled = false
                deleteBtn.backgroundColor = .gray2
            }else {
                deleteBtn.isEnabled = true
                deleteBtn.backgroundColor = .black
                details = textView.text
            }}).disposed(by: bag)
    }
}
