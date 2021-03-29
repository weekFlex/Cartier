//
//  UIView+Extension.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/03/21.
//

import UIKit


extension UIView {
    
    // 설명 : UIView 사용 시 모서리 둥글게 하는 처리 extension
    // 사용법 : UIView 에 사용합니다!
    // explainLabel.font = myView.setRounded(radius : 7)
    
    func setRounded(radius : CGFloat?) {
        // UIView 의 모서리 둥글 때
        if let cornerRadius_ = radius {
            self.layer.cornerRadius = cornerRadius_
        }  else {
            // cornerRadius 가 nil 일 경우의 default
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
        
        self.layer.masksToBounds = true
    }
    
    // 설명 : UIView 사용 시 테두리 색깔 및 두께 처리 extension
    // 사용법 : UIView 에 사용합니다!
    // explainLabel.font = myView.setBorder(borderColor : .yellow, borderWidth: 10)
    
    func setBorder(borderColor : UIColor?, borderWidth : CGFloat?) {
        // UIView의 테두리 설정
        
        // UIView 의 테두리 색상 설정
        if let borderColor_ = borderColor {
            self.layer.borderColor = borderColor_.cgColor
        } else {
            self.layer.borderColor = UIColor.black.cgColor
        }
        
        // UIView 의 테두리 두께 설정
        if let borderWidth_ = borderWidth {
            self.layer.borderWidth = borderWidth_
        } else {
            // borderWidth 변수가 nil 일 경우의 default
            self.layer.borderWidth = 1.0
        }
        
    }
    
    //설명: UIView 사용 시 그림자 효과
    //myView.dropShadow()
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}
