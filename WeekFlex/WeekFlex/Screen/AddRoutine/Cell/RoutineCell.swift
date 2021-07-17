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
    var routine: TaskListData?
    
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
    
    func configure(data: TaskListData) {
        
        routine = data
        
        routineNameLabel.text = data.name
        
        if data.days != nil {
            // 시간이 들어왔다면? (민승이가 넘겨줘씅ㄹ 때)
            
        } else {
            timeLabel.text = ""
        }
        
        if data.isBookmarked {
            // 북마크가 되어있는 지
            bookmarkImage.image = UIImage(named: "icon16BookmarkActive")
        } else {
            bookmarkImage.image = UIImage(named: "icon16BookmarkInactive")
        }
        
        contentView.backgroundColor = .clear
        
    }
    
    func selected() {
        // 선택되어 있다면?
        contentView.backgroundColor = .bgSelected
    }

}
