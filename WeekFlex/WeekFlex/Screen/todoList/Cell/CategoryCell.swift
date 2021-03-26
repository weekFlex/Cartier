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
            // 한 카테고리만 선택되어 있을 수 있고 , 다른 카테고리가 선택된다면 style이 바껴야함
            statusBarView.isHidden = newValue ? false : true
            nameLabel.textColor = newValue ? UIColor.black : .gray4
        }
    }
    
    override func awakeFromNib() {
        statusBarView.isHidden = true
        nameLabel.font = UIFont.appleRegular(size: 14)
        nameLabel.textColor = .gray4
    }
    
    func configure(with viewModel: CategoryListItemPresentable) {
        nameLabel.text = viewModel.categoryName
        colorImage.image = UIImage(named: viewModel.categoryColor!)
    }
    
}
