//
//  MyPageHomeVC.swift
//  WeekFlex
//
//  Created by dohan on 2021/10/04.
//

import Foundation
import UIKit


class MyPageHomeVC: UIViewController{
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var via: UILabel!
    
    @IBAction func categorySetting(_ sender: Any) {
    }
    @IBAction func taskSetting(_ sender: Any) {
    }
    @IBAction func logout(_ sender: Any) {
        let actionSheetController = UIAlertController(title: "로그아웃",
                                                      message: "로그아웃 하시겠습니까?",
                                                      preferredStyle: .alert)
        
        let logout = UIAlertAction(title: "로그아웃", style: .default, handler: {action in
            UserDefaults.standard.removeObject(forKey: "UserToken")
            
            let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
            guard let loginVC = storyboard.instantiateViewController(identifier: "LoginVC") as? LoginVC else { return }
            UIApplication.shared.windows.first?.replaceRootViewController(loginVC, animated: true, completion: nil)
        })
        
        let cancel = UIAlertAction(title: "취소" , style: .cancel, handler: nil)

        actionSheetController.addAction(cancel)
        actionSheetController.addAction(logout)
        
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    @IBAction func contact(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfo()
        logoutButton.point(inside: CGPoint(x: logoutButton.frame.minX, y: 0), with: .none)
    }
    
    func setInfo(){
        //이름, 프로필사진, 로그인 경로,버젼 세팅
        if NetworkState.isConnected() {
            // 네트워크 연결 시
            if let token = UserDefaults.standard.string(forKey: "UserToken") {
                APIService.shared.getUserProfile(token) { [self] result in
                    switch result {
                    case .success(let data):
                        name.text = data.userName
                        switch data.signupType {
                        case "KAKAO":
                            via.text = "카카오톡으로 로그인 됨"
                        case "FACEBOOK":
                            via.text = "페이스북으로 로그인 됨"
                        default:
                            via.text = "로그인 정보 없음"
                        }
                    // 데이터 전달 후 다시 로드
                    case .failure(let error):
                        print(error)
                        
                    }
                }
            }
        } else {
            // 네트워크 미연결 팝업 띄우기
            print("네트워크 미연결")
        }
    }
    
}
extension UIButton {

  open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let margin: CGFloat = 500
    let hitArea = self.bounds.insetBy(dx: -margin, dy: -margin)
    return hitArea.contains(point)
  }
}

extension UIWindow {
    func replaceRootViewController(
        _ replacementController: UIViewController,
        animated: Bool,
        completion: (() -> Void)?
    ) {
           let snapshotImageView = UIImageView(image: self.snapshot())
           self.addSubview(snapshotImageView)

           let dismissCompletion = { () -> Void in // dismiss all modal view controllers
               self.rootViewController = replacementController
               self.bringSubviewToFront(snapshotImageView)
               if animated {
                   UIView.animate(withDuration: 0.5, animations: { () -> Void in
                        snapshotImageView.transform = CGAffineTransform(translationX: 0, y: 1000)
                    }, completion: { (isEnd) -> Void in
                        if isEnd {
                            snapshotImageView.removeFromSuperview()
                            completion?()
                        }
                    }
                   )
               } else {
                   snapshotImageView.removeFromSuperview()
                   completion?()
               }
           }

           if self.rootViewController!.presentedViewController != nil {
               self.rootViewController!.dismiss(animated: false, completion: dismissCompletion)
           } else {
               dismissCompletion()
           }
       }

    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage.init() }
        UIGraphicsEndImageContext()
        return result
    }
}
