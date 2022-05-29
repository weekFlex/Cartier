//
//  SplashVC.swift
//  WeekFlex
//
//  Created by 김민희 on 2022/01/19.
//

import UIKit
import Lottie

class SplashVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let animationView = AnimationView(name: "Splash")
        
        animationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        animationView.contentMode = .scaleAspectFill
        view.addSubview(animationView)
        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.playOnce,
                           completion: { (finished) in
            if finished {
                // 끝
                //로그인 분기처리
                if (UserDefaults.standard.string(forKey: "UserToken") != nil) {
                    //로그인 했었으면 바로 메인페이지
                    let nextStoryboard = UIStoryboard.init(name: "TabBar",bundle: nil)
                    guard let nextController = nextStoryboard.instantiateViewController(withIdentifier: "TabBar") as? TabBarVC else {return}
                    UIApplication.shared.windows.first?.replaceRootViewController(nextController, animated: true, completion: nil)
                } else{
                    //로그인 페이지
                    guard let loginTab = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else {
                        return
                    }
                    UIApplication.shared.windows.first?.replaceRootViewController(loginTab, animated: true, completion: nil)
                }
                
                
                
                
            } else {
                // 앱 다시 확인
            }
        })
        
    }
    
}
