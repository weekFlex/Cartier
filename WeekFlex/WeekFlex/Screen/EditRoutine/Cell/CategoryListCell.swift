//
//  CategoryListCell.swift
//  WeekFlex
//
//  Created by Hailey on 2022/05/04.
//

import UIKit

class CategoryListCell: UITableViewCell {

    // MARK: Property
    static let identifier = "CategoryListCell"
    
    // MARK: @IBOutlet
    @IBOutlet weak var categoryColor: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(icon: String, title: String) {
        categoryTitle.text = title
        categoryColor.image = UIImage(named: icon)
    }

}
