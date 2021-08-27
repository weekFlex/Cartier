//
//  CategoryStarCell.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/08/28.
//

import UIKit

class CategoryStarCell: UICollectionViewCell {
    
    // MARK: Variable Part
    
    static let identifier = "CategoryStarCell"
    
    lazy var starImage: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1).isActive = true // 1:1 비율 설정
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        return imageView
    }()
    
    lazy var categoryLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setLabel(text: "", color: .gray5, font: .appleMedium(size: 15))
        return label
        
    }()
    
    lazy var percentLabel: UILabel = {
        
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setLabel(text: "%", color: .black, font: .metroSemiBold(size: 16))
        return label
        
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadView()
    }
    
    // MARK: Object Insert Function
    
    private func loadView() {
        
        addSubview(starImage)
        addSubview(categoryLabel)
        addSubview(percentLabel)
        
        starImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        starImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        
        categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: starImage.trailingAnchor, constant: 6).isActive = true
        
        percentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        percentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true

    }
    
    func configure(image: String, category: String, percent: Int) {
        starImage.image = UIImage(named: image)
        categoryLabel.text = category
        percentLabel.text = "\(percent)%"
    }

    
}
