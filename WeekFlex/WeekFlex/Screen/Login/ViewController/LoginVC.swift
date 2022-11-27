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
        startAnimation()
        setLayout()
    }
}

// MARK: - View Layout
extension LoginVC {

    func setLayout() {
        [kakaoButton, googleButton, appleButton].forEach {
            $0.setTitle("", for: .normal)
        }
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
}

// MARK: - Social Login Action
extension LoginVC {
    /// Apple Login Action
    @objc func handleAppleSignIn() {
        print(#function)
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        //이름, 이메일 받아옴
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }


    /// Kakao Login Action
    @objc func handleKakaoSignIn(){
        print(#function)
        if UserApi.isKakaoTalkLoginAvailable() { // 카카오톡 설치되어있는지 확인

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
                            guard let token = oauthToken?.accessToken,
                                  let email = user?.kakaoAccount?.email,
                                  let name = user?.kakaoAccount?.profile?.nickname else{
                                print("token/email/name is nil")
                                return
                            }

                            self.email = email
                            self.accessToken = token
                            self.name = name
                            self.signupType = "KAKAO"

                            userLogin()
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
                            guard let token = oauthToken?.accessToken,
                                  let email = user?.kakaoAccount?.email,
                                  let name = user?.kakaoAccount?.profile?.nickname else{
                                print("token/email/name is nil")
                                return
                            }

                            self.email = email
                            self.accessToken = token
                            self.name = name
                            self.signupType = "KAKAO"

                            userLogin()
                        }
                    }
                }
            }
        }
    }

    /// Google Login Action
    @objc func handleGoogleSignIn() {
        print(#function)
        GIDSignIn.sharedInstance.signOut()
        let config = GIDConfiguration.init(clientID: Storage().clientID)

        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in

            guard error == nil else { return }
            guard let user = user else { return }

            //토큰 받아오기
            user.authentication.do { authentication, error in
                guard error == nil else { return }
                guard let authentication = authentication else { return }
                self.accessToken = authentication.idToken
                self.email = user.profile?.email ?? ""
                self.name = user.profile?.name ?? ""
                self.signupType = "GOOGLE"
                self.userLogin()
            }
        }
    }

    /// 회원가입 후 로그인 API
    func userLogin() {
        if NetworkState.isConnected() {
            guard let token = accessToken else { return }
            APIService.shared.socialLogin(token, code, email, name, signupType) { result in
                switch result {
                case .success(let data):
                    print("회원가입 성공")
                    UserDefaults.standard.set(data.token, forKey: "UserToken") //토큰 저장
                    UserDefaults.standard.set(self.signupType, forKey: "SignupType")
                    print(">>token? ",data.token)
                    let nextStoryboard = UIStoryboard.init(name: "TabBar",bundle: nil)
                    guard let nextController = nextStoryboard.instantiateViewController(withIdentifier: "TabBar") as? TabBarVC else {return}
                    nextController.modalPresentationStyle = .fullScreen
                    self.present(nextController, animated: true,completion: nil) //로그인 성공하면 메인화면으로 이동
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            print("네트워크 미연결")
        }
    }
}

// MARK: Apple Login Delegate
extension LoginVC: ASAuthorizationControllerDelegate {
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // 계정 정보 가져오기
            if let access_token = appleIDCredential.identityToken,
               let authorization_code = appleIDCredential.authorizationCode,
               let email = appleIDCredential.email,
               let familyName = appleIDCredential.fullName?.familyName,
               let givenName = appleIDCredential.fullName?.givenName{
                
                //정보 저장
                self.signupType = "APPLE"
                self.name = familyName + givenName
                self.email = email
                self.accessToken = String(decoding: access_token, as: UTF8.self)
                self.code = (String(decoding: authorization_code, as: UTF8.self))
                
            }
            print("Apple Login Access Token: \(accessToken)")
            userLogin()
        default:
            break
        }
    }
    
    /// Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Apple login error")
    }
}

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    ///애플로그인 화면
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
