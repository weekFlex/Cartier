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
    @IBAction func deleteAccount(_ sender: Any) {
        let deleteStoryboard = UIStoryboard.init(name: "DeleteAccount", bundle: nil)
        guard let nextVC = deleteStoryboard.instantiateViewController(withIdentifier: "DeleteAccount") as? DeleteAccountVC else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
        
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
//extension UIButton {
//
//  open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//    let margin: CGFloat = 500
//    let hitArea = self.bounds.insetBy(dx: -margin, dy: -margin)
//    return hitArea.contains(point)
//  }
//}
