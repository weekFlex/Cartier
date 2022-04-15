//
//  UIWindow+Extension.swift
//  WeekFlex
//
//  Created by 김민희 on 2022/01/25.
//

import UIKit

extension UIWindow {
    
    // 설명 : 특정 뷰로 이동 시 위로 씌우는 것이 아니라 RootView를 제거하고 이동 하는 View로 Root를 변경시켜주는 Extension
    // UIApplication.shared.windows.first?.replaceRootViewController(loginView, animated: true, completion: nil)
    
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

