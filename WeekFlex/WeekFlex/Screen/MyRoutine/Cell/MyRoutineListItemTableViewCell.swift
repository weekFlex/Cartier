//
//  MyRoutineListItemTableViewCell.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/03/22.
//

import UIKit

class MyRoutineListItemTableViewCell: UITableViewCell {

    // MARK: Variable

    var routineImageArray = ["icon24StarN1", "icon24StarN3", "icon24StarN8"]

    // MARK: IBOutlet

    @IBOutlet var routineImage: UIImageView!
    @IBOutlet var routineTitleLabel: UILabel!
    @IBOutlet var routineElementsLabel: UILabel!
    
    
    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let bottomSpace: CGFloat = 8
//        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: bottomSpace, right: 0))
//    }
    
    // MARK: Function

    /// configure cell using view model
    /// - Returns: void
    func configure(withViewModel viewModel: MyRoutineListItemPresentable, index: Int) -> (Void) {
        routineImage.image = UIImage(named: routineImageArray[index%3])
        routineTitleLabel.setLabel(text: viewModel.routineTitle!, color: .white, font: .metroBold(size: 20), letterSpacing: -0.2)
        routineElementsLabel.setLabel(text: viewModel.routineElements!, color: .gray2, font: .appleRegular(size: 13), letterSpacing: -0.13)
    }
    
    func setLayout() {
        contentView.backgroundColor = .black
        contentView.setRounded(radius: 3)
    }
    
    
}
