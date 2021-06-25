//
//  WeekCollectionViewCell.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/04/23.
//

import UIKit

class WeekCollectionViewCell: UICollectionViewCell {
    
    // MARK: Variable Part
    
    static let identifier = "WeekCell"
    var weekLabelTextArray = ["월", "화", "수", "목", "금", "토", "일"]
    
    // MARK: IBOutlet
    
    @IBOutlet var weekLabel: UILabel!
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Function
    
    func configure(with: [String : Int], index: Int, cellWidth: CGFloat) -> (Void) {
        contentView.setRounded(radius: cellWidth/2)
        if with[weekLabelTextArray[index]] == 1 {
            print("yes")
            weekLabel.setLabel(text: weekLabelTextArray[index], color: .white, font: .appleBold(size: 14))
            contentView.backgroundColor = .black
            contentView.setBorder(borderColor: .black, borderWidth: 1)
        } else if with[weekLabelTextArray[index]] == 0 {
            print("no")
            weekLabel.setLabel(text: weekLabelTextArray[index], color: .gray2, font: .appleBold(size: 14))
            contentView.setBorder(borderColor: .gray2, borderWidth: 1)
            contentView.backgroundColor = .clear
        }
    }
}
