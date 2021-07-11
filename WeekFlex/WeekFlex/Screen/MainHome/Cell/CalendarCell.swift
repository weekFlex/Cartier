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
        date.text = viewModel.date.components(separatedBy: "-")[1]
        countCategory(data: viewModel)
        star.image = UIImage(named: representCategory )
        
    }
    
    //대표 카테고리 계산
    func countCategory(data: DailyData){
        var categoryCounter = [Int](repeating: 0, count: 16)

        
        for index in 0 ..< data.items.count {
            for todo in data.items[index].todos {
                if todo.done == true {
                    categoryCounter[todo.categoryColor] += 1
                }
            }
            
        }
        
        
        if let max = categoryCounter.max(),let maxIdx = categoryCounter.firstIndex(of: max) {
            if(max != 0){
                representCategory += String(maxIdx)
            }
        }
        
    }

}
