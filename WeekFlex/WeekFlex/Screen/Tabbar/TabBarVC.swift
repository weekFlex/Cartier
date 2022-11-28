//
//  TabBarVC.swift
//  WeekFlex
//
//  Created by jj-sh on 2021/07/23.
//

import Foundation
import UIKit


class TabBarVC: UITabBarController {
    
    enum TabBarItems: Int {
        case main
        case review
        case myPage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setViewNewbie(isNewbie: Bool) {
        guard let navigation = self.viewControllers?.first as? UINavigationController else {
            return
        }
        guard let mainViewController = navigation.viewControllers.first as? MainHomeVC else {
            return
        }
        mainViewController.userType = isNewbie ? .newUser(level: 1) : .existingUser
    }

}
