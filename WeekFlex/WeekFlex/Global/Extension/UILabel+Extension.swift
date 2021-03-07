//
//  UILabel+Extension.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/03/03.
//

import UIKit

// MARK: setLabel function for UILabel

// Extension 설명: 매번 label 내용, 색깔, 폰트 세가지를 세 줄로 작성하는 것을 하나의 function 으로 합쳐주었습니다

// 사용법: MyLabel.setLabel(text: "label내용", color: .black, font: UIFont.appleThin(size: 33))

extension UILabel {
    func setLabel(text: String, color: UIColor, font: UIFont){
        self.text = text
        self.font = font
        self.textColor = color
    }
}
