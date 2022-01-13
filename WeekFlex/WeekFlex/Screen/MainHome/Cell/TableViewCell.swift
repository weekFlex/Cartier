//
//  TableViewCell.swift
//  WeekFlex
//
//  Created by dohan on 2021/03/10.
//

import UIKit


class TableViewCell: UITableViewCell {
    
    //MARK: Variable
    var titleString: String = ""
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var title: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLayout()
//        self.view.layer.cornerRadius = 5
//        self.view.layer.masksToBounds = false
//        self.view.layer.borderWidth = 0.5
//        self.view.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
//        self.view.layer.shadowPath = nil
//        self.view.layer.shadowColor = UIColor.black.cgColor
//        self.view.layer.shadowRadius = 2
//        self.view.layer.shadowOpacity = 0.2
//        self.view.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for subview in stackView.subviews {
                stackView.removeArrangedSubview(subview)
                NSLayoutConstraint.deactivate(subview.constraints)
                subview.removeFromSuperview()
            }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    func setLayout(){
        contentView.setRounded(radius: 5)
        contentView.layer.borderColor = UIColor.gray1.cgColor
        contentView.layer.masksToBounds = false
        contentView.layer.borderWidth = 1
//        self.contentView.layer.borderColor = UIColor.gray1.cgColor
//        self.layer.shadowColor = UIColor.gray4.cgColor
//        self.layer.shadowRadius = 10
//        self.layer.shadowOpacity = 0.2
//        self.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.layer.shadowColor = UIColor.black.cgColor
        
        
        
//        self.layer.masksToBounds = false
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.contentView.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    
    
    
}
