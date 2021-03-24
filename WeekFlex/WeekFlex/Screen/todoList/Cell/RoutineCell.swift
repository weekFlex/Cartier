//
//  RoutineCell.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/03/22.
//

import UIKit

class RoutineCell: UICollectionViewCell {
    
    // MARK: Variable Part
    
    static let identifier = "RoutineCell"
    
    // MARK: IBOutlet
    
    @IBOutlet weak var routineNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bookmarkImage: UIImageView!


    override func awakeFromNib() {
        contentView.backgroundColor = .clear
        routineNameLabel.font = UIFont.appleMedium(size: 16)
        timeLabel?.font = UIFont.appleRegular(size: 12)
        timeLabel?.textColor = UIColor.gray3
    }
    
    func configure(with viewModel: ToDoListItemPresentable) {
        routineNameLabel.text = viewModel.listName
        timeLabel.text = viewModel.listTime
        if viewModel.bookmarkCheck! {
            bookmarkImage.image = UIImage(named: "icon16BookmarkActive")
        } else {
            bookmarkImage.image = UIImage(named: "icon16BookmarkInactive")
        }
        contentView.backgroundColor = .clear
        
    }
    
    func selected() {
        contentView.backgroundColor = .bgSelected
    }

}
