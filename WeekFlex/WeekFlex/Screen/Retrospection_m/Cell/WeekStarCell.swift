//
//  WeekStarCell.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/08/26.
//

import UIKit

class WeekStarCell: UICollectionViewCell {
    
    // MARK: Variable Part
    
    static let identifier = "WeekStarCell"
    
    lazy var stackView: UIStackView = {
        
        let stack = UIStackView()
        stack.spacing = 6
        stack.distribution = .fill
        stack.alignment = .center
        stack.axis = .vertical
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    lazy var starImage: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1).isActive = true // 1:1 비율 설정
        
        return imageView
    }()
    
    lazy var dayLabel: UILabel = {
        
        let label = UILabel()
        label.setLabel(text: "", color: .gray4, font: .appleMedium(size: 10))
        return label
        
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadView()
        contentView.backgroundColor = .bgSelected
    }
    
    // MARK: Object Insert Function
    
    private func loadView() {
        
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(starImage)
        // 스택안에 Object 삽입
        
        addSubview(stackView)
        
        stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 22/46*contentView.frame.width).isActive = true
        
    }
    
}
