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
    @IBOutlet weak var warningIcon: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var warningConstraint: NSLayoutConstraint!
    
    
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
        let myDelegate = UIApplication.shared.delegate as? AppDelegate
        
        dateLabel.text = "\(startDayString.changeDay()) ~ \(endDayString.changeDay())"
        titleLabel.text = data.title
        if(data.content != "" ){
            warningIcon.isHidden = true
            warningConstraint.constant = 5
            descriptionLabel.text = data.content
            
        }else{
            warningIcon.isHidden = false
            warningConstraint.constant = 22
            descriptionLabel.text = "회고가 비어있어요"
        }
        
        if let arr = myDelegate?.emotionMascot {
            //0일경우 기본
            reviewCharacter.image = UIImage(named: "Character/character-96-\(arr[data.emotionMascot].0)")
        }
        if !data.stars.isEmpty {
            for i in categories.indices {
                categories[i].image = UIImage(named: "icon-24-star-n\(data.stars[i].id)")
            }
        }else {
            for i in categories.indices {
                categories[i].image = UIImage(named: "icon-24-star-n0")
            }
        }
        
        
    }
    
    func setLayout(){
        self.view.layer.cornerRadius = 3
    }

}
