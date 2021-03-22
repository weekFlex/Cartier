//
//  CategoryCell.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/03/21.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    // MARK: Variable Part
    
    static let identifier = "CategoryCell"
    
    // MARK: IBOutlet
    
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var colorImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override var isSelected: Bool {
        willSet {
            statusBarView.isHidden = newValue ? false : true
            nameLabel.textColor = newValue ? UIColor.black : UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
        }
    }
    
    override func awakeFromNib() {
        statusBarView.isHidden = true
        nameLabel.font = UIFont.appleRegular(size: 14)
        nameLabel.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
    }
    
    func set(_ list: CategoryList) {
        nameLabel.text = list.name
        colorImage.image = UIImage(named: list.color)
    }
    
}
