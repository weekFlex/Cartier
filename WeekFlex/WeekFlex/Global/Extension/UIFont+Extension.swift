//
//  UIFont+Extension.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/03/04.
//

import UIKit

// 설명 : Font 사용 시 일일히 Font Name과 size를 기재하지 않기 위한 Extension
// 사용법 : 버튼, 라벨 등등 Text가 있는 곳은 아무곳이나 사용 가능!
// explainLabel.font = UIFont.appleBold(size: 22)

extension UIFont {
    
    // MARK: AppleSDGothicNeo Font
    
    class func appleBold(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Bold", size: size)!
    }
    
    class func appleThin(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Thin", size: size)!
    }
    
    class func appleRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Regular", size: size)!
    }
    
    class func appleLight(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Light", size: size)!
    }
    
    class func appleMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Medium", size: size)!
    }
    
    class func appleSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-SemiBold", size: size)!
    }
     
}
