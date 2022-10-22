//
//  MyTopTipView.swift
//  WeekFlex
//
//  Created by Hailey on 2022/05/19.
//

import UIKit
import SnapKit

enum TipState {
    case up
    case down(height: CGFloat)
}

class MyTopTipView: UIView {
    
    var dismissActions: (() -> Void)?
    init(viewColor: UIColor, tipStartX: CGFloat, tipWidth: CGFloat, tipHeight: CGFloat, text: String, state: TipState) {
        
        super.init(frame: .zero)
        self.backgroundColor = viewColor
        
        let path = CGMutablePath()
        
        let tipWidthCenter = tipWidth / 2.0
        let endXWidth = tipStartX + tipWidth
        
        switch state {
            
        case .up:
            path.move(to: CGPoint(x: tipStartX, y: 0))
            path.addLine(to: CGPoint(x: tipStartX + tipWidthCenter - 1, y: -tipHeight))
            path.addLine(to: CGPoint(x: tipStartX + tipWidthCenter + 1, y: -tipHeight))
            path.addLine(to: CGPoint(x: endXWidth, y: 0))
            
        case .down(let height):
            path.move(to: CGPoint(x: tipStartX, y: height))
            path.addLine(to: CGPoint(x: tipStartX + tipWidthCenter - 1, y: height+tipHeight))
            path.addLine(to: CGPoint(x: tipStartX + tipWidthCenter + 1, y: height+tipHeight))
            path.addLine(to: CGPoint(x: endXWidth, y: height))
        }
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = viewColor.cgColor
        
        self.layer.insertSublayer(shape, at: 0)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5
        
        self.addLabel(text: text)
        addRemoveButton()
    }
    
    convenience init(viewColor: UIColor, tipStartX: CGFloat, tipWidth: CGFloat, tipHeight: CGFloat, text: String, state: TipState, dismissActions: @escaping () -> Void) {
        self.init(viewColor: viewColor, tipStartX: tipStartX, tipWidth: tipWidth, tipHeight: tipHeight, text: text, state: state)
        self.dismissActions = dismissActions
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
        removeButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        removeButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(8)
            $0.top.equalToSuperview().inset(9)
            $0.width.height.equalTo(16)
        }
    }
    
    @objc func dismissAction() {
        guard let dismissActions = dismissActions else {
            return
        }
        dismissActions()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
