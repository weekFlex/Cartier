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
    @IBOutlet weak var via: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfo()
    }
    
    func setInfo(){
        //이름, 프로필사진, 로그인 경로 세팅
    }
    
}
