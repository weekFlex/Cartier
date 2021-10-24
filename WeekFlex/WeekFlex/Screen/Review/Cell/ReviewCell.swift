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
        let delegate = UIApplication.shared.delegate as? AppDelegate
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
            descriptionLabel.text = data.content
        }else{
            descriptionLabel.text = "회고가 비어있어요"
            let warningView = UIImageView()
            let icon = UIImage(named: "warning.png")
            warningView.image = icon
            self.view.addSubview(warningView)
            warningView.translatesAutoresizingMaskIntoConstraints = false
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            warningView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            warningView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            warningView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 22).isActive = true
            warningView.topAnchor.constraint(equalTo: descriptionLabel.topAnchor).isActive = true
            warningView.trailingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: 6).isActive = true
            
            descriptionLabel.leadingAnchor.constraint(equalTo: warningView.trailingAnchor, constant: 6).isActive = true
            descriptionLabel.trailingAnchor.constraint(equalTo: warningView.trailingAnchor, constant: 6).isActive = true
            
        }
        
        if let arr = myDelegate?.emotionMascot {
            //
            reviewCharacter.image = UIImage(named: "Character/character-96-\(arr[data.emotionMascot].0)")
        }
        if !data.stars.isEmpty {
            for i in categories.indices {
                categories[i].image = UIImage(named: "icon-24-star-n\(data.stars[i])")
            }
        }
        
        
    }
    
    func setLayout(){
        self.view.layer.cornerRadius = 3
    }

}
