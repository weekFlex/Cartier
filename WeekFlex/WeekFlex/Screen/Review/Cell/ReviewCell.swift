//
//  ReviewCellCollectionViewCell.swift
//  WeekFlex
//
//  Created by dohan on 2021/06/11.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewCharacter: UIImageView!
    @IBOutlet var categories: [UIImageView]!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    func configure(with viewModel: ReviewItemPresentable){
        dateLabel.text = viewModel.date
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        
    }

}
