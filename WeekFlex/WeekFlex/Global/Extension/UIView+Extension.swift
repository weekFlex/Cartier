//
//  UIView+Extension.swift
//  WeekFlex
//
//  Created by dohan on 2021/03/24.
//

import UIKit


extension UIView {

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
