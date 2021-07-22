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
        
        if let days = data.days?.map({ $0.name }).joined(separator: ", ") {
            if let startTime = data.days?[0].startTime?.changeTime(),
               let endTime = data.days?[0].endTime?.changeTime() {
                taskTimeLabel.text = "\(days) \(startTime)-\(endTime)"
            } else {
                taskTimeLabel.text = "\(days)"
            }
        }
        
        categoryColorImage.image = UIImage(named: "icon-24-star-n\(data.categoryColor)")
        
        
    }

}
