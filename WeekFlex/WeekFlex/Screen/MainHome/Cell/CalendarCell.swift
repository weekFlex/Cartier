//
//  CalendarItemCollectionViewCell.swift
//  WeekFlex
//
//  Created by dohan on 2021/04/09.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    //MARK: Variable
    var representCategory = "icon24Star"
    
    
    //MARK: IBOutlet
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var star: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var bar: UIView!
    
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with viewModel: DailyData) {
        countCategory(data: viewModel)
        star.image = UIImage(named: representCategory )
        
    }
    
    //대표 카테고리 계산
    func countCategory(data: DailyData){
        var categoryCounter = [Int](repeating: 0, count: 16)
        
     
        
        

    }

}
