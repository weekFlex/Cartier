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

    override var isSelected: Bool {
      didSet {
        if isSelected {
            if contentView.backgroundColor == .clear {
                contentView.backgroundColor = .gray
            } else {
                contentView.backgroundColor = .clear
            }
        }
      }
    }
    
    override func awakeFromNib() {
        contentView.backgroundColor = .clear
        routineNameLabel.font = UIFont.appleMedium(size: 16)
        timeLabel?.font = UIFont.appleRegular(size: 12)
        timeLabel?.textColor = UIColor(red: 164/255, green: 164/255, blue: 169/255, alpha: 1.0)
    }
    
    func set(_ list: RoutineList) {
        routineNameLabel.text = list.name
        timeLabel.text = list.time
        if list.check {
            bookmarkImage.image = UIImage(systemName: "bookmark.fill")
        } else {
            bookmarkImage.image = UIImage(systemName: "bookmark")
        }
        
    }

}
