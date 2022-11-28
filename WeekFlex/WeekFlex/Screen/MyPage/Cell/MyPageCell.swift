//
//  MyPageCell.swift
//  WeekFlex
//
//  Created by 미니 on 2022/11/27.
//

import UIKit
import SnapKit

class MyPageCell: UITableViewCell {

    // MARK: - Property
    static let identifier = "MyPageCell"
    lazy var titleLable: UILabel = {
        let label = UILabel()
        label.setLabel(text: "", color: .black, font: .appleMedium(size: 16))
        return label
    }()
    lazy var clickImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon16Right")
        return imageView
    }()
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "", color: .gray3, font: .appleMedium(size: 16))
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setLayout(title: String, version: String? = nil) {
        addSubview(titleLable)
        titleLable.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(22)
        }
        titleLable.text = title
        if let version = version {
            addSubview(versionLabel)
            versionLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(22)
            }
            versionLabel.text = version
        } else {
            addSubview(clickImage)
            clickImage.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(22)
                $0.width.height.equalTo(16)
            }
        }

    }
    
}
