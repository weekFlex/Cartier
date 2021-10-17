//
//  ReviewCellCollectionViewCell.swift
//  WeekFlex
//
//  Created by dohan on 2021/06/11.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewCharacter: UIImageView!
    @IBOutlet var categories: [UIImageView]!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setLayout()
    }
    
    
    
    func configure(with data: RetrospectionData){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        guard let startDay = dateformatter.date(from: data.startDate) else { return }
        guard let endDay = Calendar.current.date(byAdding: .day, value: 7, to: startDay) else { return }
        let startDayString = dateformatter.string(from: startDay)
        let endDayString = dateformatter.string(from: endDay)
        let subStartDays = startDayString.split(separator: "-")
        let subEndDay = endDayString.split(separator: "-")
//        for s in subStartDays {
//            if s[0] == "0" {
//                s.removeFirst()
//            }
//        }
        dateLabel.text = "\(subStartDays[1])월 \(subStartDays[2])일 ~ \(subEndDay[1])월 \(subEndDay[2])일"
        titleLabel.text = data.title
        descriptionLabel.text = data.content
        
    }
    
    func setLayout(){
        self.view.layer.cornerRadius = 3
    }

}
