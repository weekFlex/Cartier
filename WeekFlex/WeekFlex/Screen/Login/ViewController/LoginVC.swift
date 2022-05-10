//
//  LoginVC.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/03/04.
//

import AuthenticationServices
import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import GoogleSignIn

class LoginVC: UIViewController {
    
    //MARK: Variable
    var accessToken: String?
    var code: String = ""
    var email: String = ""
    var name: String = ""
    var signupType: String = ""
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var weekFlexImageView: UIImageView!
    @IBOutlet weak var leftLineView: UIView!
    @IBOutlet weak var rightLineView: UIView!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var loginStackView: UIStackView!
    
    @IBOutlet weak var kakaoButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [kakaoButton, googleButton, appleButton].forEach {
            $0.setTitle("", for: .normal)
        }
        //테스트용 회원탈퇴!
        
        startAnimation()
        setLayout()
    }
}

extension LoginVC {
    
    // MARK: - View Layout
    
    func setLayout() {
        appleButton.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)
        kakaoButton.addTarget(self, action: #selector(handleKakaoSignIn), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        
    }
    
    func startAnimation() {
        let animationObject = [self.titleLabel, self.subTitleLabel, self.weekFlexImageView,
                               self.leftLineView, self.rightLineView, self.startLabel, self.loginStackView]
        
        UIView.animate(withDuration: 0) {
            let scale = CGAffineTransform(scaleX: 1.0, y: 1.0)
            let move = CGAffineTransform(translationX: 0, y: +70)
            
            let combine = scale.concatenating(move)
            animationObject.forEach {
                $0?.transform = combine
                $0?.alpha = 0.0
            }
        } completion: { finished in
            
            UIView.animate(withDuration: 0.8) {
                [self.titleLabel, self.subTitleLabel].forEach {
                    $0?.transform = .identity
                    $0?.alpha = 1
                }
            }
            
            UIView.animate(withDuration: 1.1) {
                self.weekFlexImageView.transform = .identity
                self.weekFlexImageView.alpha = 1
            }
            
            UIView.animate(withDuration: 1.4) {
                [self.leftLineView, self.rightLineView, self.startLabel].forEach {
                    $0?.transform = .identity
                    $0?.alpha = 1
                }
            }
            
            UIView.animate(withDuration: 1.7) {
                self.loginStackView.transform = .identity
                self.loginStackView.alpha = 1
            }
        }
    }
    
    // MARK: - Method
    
    // Apple Login Button 눌렸을 때 액션
    @objc func handleAppleSignIn() {
        print("애플로그인 눌림")
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        //이름, 이메일 받아옴
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    // Kakao Login Buttoon 눌렸을 때 액션
    @objc func handleKakaoSignIn(){
        print("카톡 로그인 눌림")
        //test용 연결끊기
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("unlink() success.")
            }
        }
        //카카오톡 설치되어있는지 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            
            //카톡 로그인. api 호출 결과 클로저로 전달
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    self.signupType = "KAKAO"
                    
                    // TODO: SNSRegisterScene으로 넘어가기.
                     _ = oauthToken
                    
                    //사용자 정보 불러옴
                    UserApi.shared.me { [self] user, error in
                        if let error = error {
                            print(error)
                        } else {
                            //닉네임(이름), 토큰, 이메일 받아옴
                            guard let token = oauthToken?.accessToken, let email = user?.kakaoAccount?.email,
                                  let name = user?.kakaoAccount?.profile?.nickname else{
                                      print("token/email/name is nil")
                                      return
                                  }

                            self.email = email
                            self.accessToken = token
                            self.name = name
                            
                            login()
                        }
                    }
                }
            }
        } else {
            // 카톡 없을때 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoAccount() success.")
                    
                    // do something
                    _ = oauthToken
                    
                    UserApi.shared.me { [self] user, error in
                        if let error = error {
                            print(error)
                        } else {
                            //닉네임(이름), 토큰, 이메일 받아옴
                            guard let token = oauthToken?.accessToken, let email = user?.kakaoAccount?.email,
                                  let name = user?.kakaoAccount?.profile?.nickname else{
                                      print("token/email/name is nil")
                                      return
                                  }

                            self.email = email
                            self.accessToken = token
                            self.name = name
                            
                            login()
                        }
                    }
                }
            }
        }
    }
    
    // Google Login 눌렸을때 액션
    @objc func handleGoogleSignIn() {
        print("구글로그인 눌림")
        let config = GIDConfiguration(clientID: "960803817590-b9ggher3ot9hm43rpen88dtuo56ekq83.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            if let error = error {
                print(error)
                return
            }
            guard let user = user else { return }
            
            
            self.accessToken = user.authentication.idToken
            self.email = user.profile?.email ?? ""
            self.name = user.profile?.name ?? ""
            self.signupType = "GOOGLE"
            self.login()
        }
    }
    
    func login(){
        print("로그인===========")
        print(accessToken)
        print(email)
        print(code)
        print(name)
        print(signupType)
        
        //화면 전환
        
        
        if NetworkState.isConnected() {
            if let token = self.accessToken {
                APIService.shared.socialLogin(token, code, email, name, signupType) { result in
                    switch result {
                    case .success(_):
                        print("회원가입 성공")
                        //토큰 저장
                        UserDefaults.standard.set(self.accessToken, forKey: "UserToken")
                        
                        let nextStoryboard = UIStoryboard.init(name: "TabBar",bundle: nil)
                        guard let nextController = nextStoryboard.instantiateViewController(withIdentifier: "TabBar") as? TabBarVC else {return}
                        nextController.modalPresentationStyle = .fullScreen
                        self.present(nextController, animated: true,completion: nil)
                        
                    case .failure(let error):
                        print(error)
                    }
                }
                
                
            }
        } else {
            print("네트워크 미연결")
        }
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
                self.accessToken = String(decoding: access_token, as: UTF8.self)
                self.code = (String(decoding: authorization_code, as: UTF8.self))
                
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
