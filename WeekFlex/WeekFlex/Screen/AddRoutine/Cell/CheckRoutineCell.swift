//
//  CheckRoutineCell.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/07/18.
//

import UIKit

class CheckRoutineCell: UITableViewCell {
    
    static let identifier = "CheckRoutineCell"
    
    @IBOutlet weak var categoryColorImage: UIImageView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskTimeLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskNameLabel.setLabel(text: "", color: .black, font: .appleBold(size: 18))
        taskTimeLabel.setLabel(text: "", color: .gray3, font: .appleRegular(size: 14))
    }

    func configure(data: TaskListData) {
        
        taskNameLabel.text = data.name
//        taskTimeLabel.text = data.da
        categoryColorImage.image = UIImage(named: "icon-24-star-n\(data.categoryColor)")
        
        
    }

}
