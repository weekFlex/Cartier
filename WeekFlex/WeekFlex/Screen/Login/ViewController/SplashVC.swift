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
            animationView.contentMode = .scaleToFill
            view.addSubview(animationView)
            animationView.play(fromProgress: 0,
                               toProgress: 1,
                               loopMode: LottieLoopMode.playOnce,
                               completion: { (finished) in
                                if finished {
                                    // 끝
                                } else {
                                    // 앱 다시 확인
                                }
                               })
            
        }

}
