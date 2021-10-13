//
//  RoutineStarCell.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/08/28.
//

import UIKit

class RoutineStarCell: UICollectionViewCell {
    
    // MARK: Variable Part
    
    static let identifier = "RoutineStarCell"
    
    lazy var starImage: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1).isActive = true // 1:1 비율 설정
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        return imageView
    }()
    
    lazy var routineLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setLabel(text: "", color: .gray5, font: .metroSemiBold(size: 16))
        return label
        
    }()
    
    lazy var percentLabel: UILabel = {
        
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setLabel(text: "%", color: .gray3, font: .metroSemiBold(size: 16))
        return label
        
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadView()
    }
    
    // MARK: Object Insert Function
    
    private func loadView() {
        
        
        contentView.setRounded(radius: 4)
        addSubview(starImage)
        addSubview(routineLabel)
        addSubview(percentLabel)
        
        starImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        starImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        
        routineLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        routineLabel.leadingAnchor.constraint(equalTo: starImage.trailingAnchor, constant: 6).isActive = true
        
        percentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        percentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true

    }
    
    func configure(image: String, routine: String, percent: Int) {
        starImage.image = UIImage(named: image)
        routineLabel.text = routine
        
        if percent == 100 {
            percentLabel.text = "🔥\(percent)%"
            percentLabel.textColor = .white
            routineLabel.textColor = .white
            contentView.backgroundColor = .black
        } else {
            contentView.backgroundColor = .bgSelected
            percentLabel.textColor = .gray3
            routineLabel.textColor = .gray5
            percentLabel.text = "\(percent)%"
        }
        
//        routineLabel.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: 6).isActive = true
        
    }
}
