//
//  TableViewCell.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/07/21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    // MARK: Variable Part
    
    static let identifier = "CategoryTableViewCell"
    
    @IBOutlet var categoryColor: UIImageView!
    @IBOutlet var categoryTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLayout()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setLayout() {
        categoryTitle.setLabel(text: "loading..", color: .black, font: .appleMedium(size: 16), letterSpacing: -0.16)
        
    }
}
