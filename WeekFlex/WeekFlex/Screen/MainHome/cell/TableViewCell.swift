//
//  TableViewCell.swift
//  WeekFlex
//
//  Created by dohan on 2021/03/10.
//

import UIKit


class TableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let a = title.text{
            print(a)
        }
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
