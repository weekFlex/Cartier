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
     
    // MARK: Metropolis Font

    class func metroBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Metropolis-Bold", size: size)!
    }
    
    class func metroBlack(size: CGFloat) -> UIFont {
        return UIFont(name: "Metropolis-Black", size: size)!
    }
    
    class func metroExtraBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Metropolis-ExtraBold", size: size)!
    }
    
    class func metroExtraLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Metropolis-ExtraLight", size: size)!
    }
    
    class func metroLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Metropolis-Light", size: size)!
    }
    
    class func metroMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Metropolis-Medium", size: size)!
    }
    
    class func metroRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Metropolis-Regular", size: size)!
    }
    
    class func metroSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Metropolis-SemiBold", size: size)!
    }
    
    class func metroThin(size: CGFloat) -> UIFont {
        return UIFont(name: "Metropolis-Thin", size: size)!
    }
    
}
