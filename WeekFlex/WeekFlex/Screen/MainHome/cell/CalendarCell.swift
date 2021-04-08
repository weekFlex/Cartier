//
//  CalendarItemCollectionViewCell.swift
//  WeekFlex
//
//  Created by dohan on 2021/04/09.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    //MARK: Variable
    
    
    //MARK: IBOutlet
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var star: UIImageView!
    @IBOutlet weak var date: UILabel!
    
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with viewModel: CalendarItemPresentable) {
        date.text = viewModel.date.components(separatedBy: "-")[1]
        star.image = UIImage(named: viewModel.representCategory ?? "icon24starDisabled")
        
    }

}
