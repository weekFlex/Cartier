//
//  ColorCategoryTableViewCell.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/07/22.
//

import UIKit

class ColorCategoryCollectionViewCell: UICollectionViewCell {

    static let identifier = "ColorCategoryCollectionViewCell"
    
    @IBOutlet var checkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLayout()
    }

    func setLayout() {
        checkImage.image = UIImage(named: "icon24CheckVisualWhite")
//        checkImage.isHidden = true // 기본으로 체크가 안되어있도록 함
    }
}
