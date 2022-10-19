//
//  ReviewEmptyView.swift
//  WeekFlex
//
//  Created by 미니 on 2022/10/18.
//

import UIKit
import SnapKit

class ReviewEmptyView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "위플과 일주일을 함께하면\n회고를 작성할 수 있어요.", color: .gray3, font: .appleRegular(size: 16), letterSpacing: -0.16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let emptyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Character/character-96-empty")
        return imageView
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .center
        stack.axis = .vertical
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    init(frame: CGRect, emptyImage: String, title: String) {
        super.init(frame: frame)
        setupLayout()
        setupEmptyInfo(image: emptyImage, title: title)
    }
    
    func setupLayout() {
        backgroundColor = .clear
        addSubview(stackView)
        stackView.addArrangedSubview(emptyImage)
        stackView.addArrangedSubview(titleLabel)
        emptyImage.snp.makeConstraints {
            $0.height.width.equalTo(132)
        }
        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func setupEmptyInfo(image: String, title: String) {
        titleLabel.text = title
        emptyImage.image = UIImage(named: image)
    }
}
