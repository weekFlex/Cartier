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
import AuthenticationServices


class DeleteReasonVC: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
    var code = ""
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
        details = " "
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
            if UserDefaults.standard.string(forKey: "SignupType") == "APPLE" {
                
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                //이름, 이메일 받아옴
                request.requestedScopes = [.fullName, .email]
                
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
                
            }else{
                self.revoke()
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
    
    func revoke(){
        if NetworkState.isConnected() {
        
                        if let token = UserDefaults.standard.string(forKey: "UserToken") {
        
        
                            APIService.shared.deleteAccount(token, self.code, self.details, self.selectedType ){ result in
        
                                switch result {
        
                                case .success(_):
                                    print("탈퇴 완료")
                                    UserDefaults.standard.removeObject(forKey: "UserToken")
                                    let loginStoryboard = UIStoryboard.init(name: "Login", bundle: nil)
                                    let nextVC = loginStoryboard.instantiateViewController(withIdentifier: "LoginVC")
                                    nextVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                                    
                                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(nextVC, animated: false)

                                case .failure(let error):
                                    print(error)
                                    print("탈퇴오류!!")
                                    print("details: \(self.details) ")
                                    print(self.selectedType)
                                }
                            }
                        }
                    } else {
                        print("네트워크 미연결")
                    }
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // 계정 정보 가져오기
            
            if let authorization_code = appleIDCredential.authorizationCode {
                self.code = (String(decoding: authorization_code, as: UTF8.self))
            }
            print(code)
            //탈퇴
            revoke()
            
            
            
            
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Apple login error")
    }
}

