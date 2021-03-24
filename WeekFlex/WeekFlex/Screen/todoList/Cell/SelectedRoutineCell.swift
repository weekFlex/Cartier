//
//  SelectedRoutineCell.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/03/23.
//

import UIKit

class SelectedRoutineCell: UICollectionViewCell {
    
    // MARK: Variable Part
    
    static let identifier = "SelectedRoutineCell"
    
    // MARK: IBOutlet
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        
//        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont.appleRegular(size: 14)
        self.contentView.backgroundColor = .white
        nameLabel.textColor = .black
    }
    
    func configure(with viewModel: SelectedItemPresentable) {
        nameLabel.text = viewModel.listName
    }
    
    
}
