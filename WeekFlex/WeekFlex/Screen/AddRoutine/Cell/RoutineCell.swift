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
    var bookmarkDelegate: TodoBookmarkDelegate?
    // MARK: IBOutlet
    
    @IBOutlet weak var routineNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBAction func bookmarkButtonDidTap(_ sender: UIButton) {
        guard let id = routine?.id else { return }
        bookmarkDelegate?.bookmarkRegister(id: id)
    }
    
    override func awakeFromNib() {
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .clear
        routineNameLabel.font = UIFont.appleMedium(size: 16)
        timeLabel?.font = UIFont.appleRegular(size: 12)
        timeLabel?.textColor = UIColor.gray3
        timeLabel.text = ""
        bookmarkButton.setTitle("", for: .normal)
//        bookmarkButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
    }
    
    func configure(data: TaskListData) {
        routine = data
        routineNameLabel.text = data.name
        contentView.backgroundColor = .clear
        guard let bookmark = data.isBookmarked else {
            bookmarkButton.setImage(UIImage(named: "icon16BookmarkInactive"), for: .normal)
            return
        }
        let image = bookmark ? "icon16BookmarkActive" : "icon16BookmarkInactive"
        bookmarkButton.setImage(UIImage(named: image), for: .normal)
    }
    
    func selected() {
        // 선택되어 있다면?
        contentView.backgroundColor = .bgSelected
    }

}

protocol TodoBookmarkDelegate {
    func bookmarkRegister(id: Int)
}
