//
//  SelectIconCell.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/10/09.
//

import UIKit

class SelectIconCell: UICollectionViewCell {
    
    static let identifier = "SelectIconCell"
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var mentLabel: UILabel!
    
    override var isSelected: Bool {
      didSet {
        if isSelected {
            backView.setBorder(borderColor: .orange, borderWidth: 2)
        } else {
            backView.setBorder(borderColor: nil, borderWidth: 0)
        }
      }
    }
    
    func configure(image: String, ment: String) {
        backView.backgroundColor = .bgSelected
        iconImageView.image = UIImage(named: "Character/character-80-\(image)")
        mentLabel.setLabel(text: ment, color: .gray4, font: .appleMedium(size: 13))
    }
    
}
