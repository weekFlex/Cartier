//
//  MyTopTipView.swift
//  WeekFlex
//
//  Created by Hailey on 2022/05/19.
//

import UIKit
import SnapKit

class MyTopTipView: UIView {
    init(
        viewColor: UIColor,
        tipStartX: CGFloat,
        tipWidth: CGFloat,
        tipHeight: CGFloat,
        text: String
    ) {
        super.init(frame: .zero)
        self.backgroundColor = viewColor
        
        let path = CGMutablePath()
        
        let tipWidthCenter = tipWidth / 2.0
        let endXWidth = tipStartX + tipWidth
        
        path.move(to: CGPoint(x: tipStartX, y: 0))
        path.addLine(to: CGPoint(x: tipStartX + tipWidthCenter, y: -tipHeight))
        path.addLine(to: CGPoint(x: endXWidth, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = viewColor.cgColor
        
        self.layer.insertSublayer(shape, at: 0)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5
        
        self.addLabel(text: text)
        addRemoveButton()
    }
    
    private func addLabel(text: String) {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.setLabel(text: text, color: .white, font: .appleMedium(size: 14))
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(7)
            $0.left.equalToSuperview().inset(10)
        }
    }
    
    
    private func addRemoveButton() {
        let removeButton = UIButton()
        removeButton.setTitle("", for: .normal)
        removeButton.setImage(UIImage(named: "icon16CancleWhite"), for: .normal)
        
        self.addSubview(removeButton)
        removeButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(8)
            $0.top.equalToSuperview().inset(9)
            $0.width.height.equalTo(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
