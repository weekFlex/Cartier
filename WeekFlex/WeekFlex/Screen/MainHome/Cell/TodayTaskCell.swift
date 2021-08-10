//
//  TodayTaskCell.swift
//  WeekFlex
//
//  Created by dohan on 2021/08/10.
//

import UIKit

class TodayTaskCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.view.layer.cornerRadius = 5
        self.view.layer.masksToBounds = false
        self.view.layer.borderWidth = 0.5
        self.view.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        
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

        // Configure the view for the selected state
    }
    
}
