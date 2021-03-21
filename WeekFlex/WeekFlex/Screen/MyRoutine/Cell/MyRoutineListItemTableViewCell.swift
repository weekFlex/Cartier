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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: Function

    /// configure cell using view model
    /// - Returns: void
    func configure(withViewModel viewModel: MyRoutineListItemPresentable, index: Int) -> (Void) {
        routineImage.image = UIImage(named: routineImageArray[index%3])
        routineTitleLabel.text = viewModel.routineTitle
        routineElementsLabel.text = viewModel.routineElements
    }
}
