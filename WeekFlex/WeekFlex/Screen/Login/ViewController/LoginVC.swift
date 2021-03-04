//
//  LoginVC.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/03/04.
//

import AuthenticationServices
import UIKit

class LoginVC: UIViewController {

    @IBOutlet var buttonStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
    }
    
    func setLayout() {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        button.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        buttonStackView.addArrangedSubview(button)
    }
    
    // MARK: - Method
    
    // Apple Login Button 눌렸을 때 액션
    @objc func handleAppleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
            
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}


// MARK: - Extenstion : 애플 로그인 delegate

extension LoginVC: ASAuthorizationControllerDelegate {
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let access_token = appleIDCredential.identityToken
        
            let authorization_code = appleIDCredential.authorizationCode

            // 디버깅용 프린팅
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            
            if let access_token = access_token,
               let authorization_code = authorization_code {
                print("token : \(String(decoding: access_token, as: UTF8.self))")
                print("authorization_code : \(String(decoding: authorization_code, as: UTF8.self))")
            }
     
        default:
            break
        }
    }
        
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
