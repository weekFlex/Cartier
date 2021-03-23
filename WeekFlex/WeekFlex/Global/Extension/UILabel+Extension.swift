//
//  UILabel+Extension.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/03/03.
//

import UIKit

// MARK: setLabel function for UILabel

// Extension 설명: 매번 label 내용, 색깔, 폰트 세가지를 세 줄로 작성하는 것을 하나의 function 으로 합쳐주었습니다. letterSpacing 도 추가로 넣어야한다면 넣어서 사용할 수 있습니다.

// 사용법:
// MyLabel.setLabel(text: "label내용", color: .black, font: UIFont.appleThin(size: 33))
// MyLabelWithLetterSpacing.setLabel(text: "label내용", color: .black, font: UIFont.appleThin(size: 33), letterSpacing: -0.1)

extension UILabel {
    
    func setLabel(text: String, color: UIColor, font: UIFont){
        self.text = text
        self.font = font
        self.textColor = color
    }
    
    func setLabel(text: String, color: UIColor, font: UIFont, letterSpacing: Double){
        self.text = text
        var attributedString = NSMutableAttributedString(string: text)
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSRange(location: 0, length: attributedString.length - 1))
        } else {
            attributedString = NSMutableAttributedString(string: text)
        }
        self.attributedText = attributedString
        self.font = font
        self.textColor = color
    }
}
