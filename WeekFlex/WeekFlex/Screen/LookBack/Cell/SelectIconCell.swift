//
//  SelectIconCell.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/10/09.
//

import UIKit

class SelectIconCell: UICollectionViewCell {
    
    static let identifier = "SelectIconCell"
    var index: IndexPath?
    var color: [UIColor] = [.color06, .color3, .color2, .color15, .color1, .color09]
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var mentLabel: UILabel!
    
    override var isSelected: Bool {
      didSet {
        if isSelected {
            if index!.row < 6 {
                backView.setBorder(borderColor: color[index!.row], borderWidth: 2)
                mentLabel.textColor = color[index!.row]
                backView.layer.cornerRadius = backView.layer.frame.height / 2.0
            }
            
            
        } else {
            backView.setBorder(borderColor: nil, borderWidth: 0)
            mentLabel.textColor = .gray4
        }
      }
    }
    
    func configure(image: String, ment: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(roundCell), name: .roundCell, object: nil)
        backView.backgroundColor = .bgSelected
        print(backView.layer.frame.height, backView.layer.frame.width)
        iconImageView.image = UIImage(named: "Character/character-80-\(image)")
        mentLabel.setLabel(text: ment, color: .gray4, font: .appleMedium(size: 13))
    }
    
    @objc func roundCell() {
        backView.layer.cornerRadius = backView.layer.frame.height / 2.0
    }
    
}

extension Notification.Name {
    // Observer 이름 등록
    static let roundCell = Notification.Name("roundCell")
}
