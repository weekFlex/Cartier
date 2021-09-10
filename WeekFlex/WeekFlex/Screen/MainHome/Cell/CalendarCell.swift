//
//  CalendarItemCollectionViewCell.swift
//  WeekFlex
//
//  Created by dohan on 2021/04/09.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    //MARK: Variable
    
    var category = -1
    
    
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
        
        
    }
    
    //대표 카테고리 계산
    func countCategory(data: DailyData){
        
        var categoryCounter = [Int](repeating: 0, count: 16)
        
        for routine in data.items{
            for todo in routine.todos{
                if todo.done {
                    categoryCounter[todo.categoryColor] += 1
                }
            }
        }
        if data.items.count == 0 {
            star.image = UIImage(named: "no")
        }else { 
            guard let categoryIndex = categoryCounter.firstIndex(of: categoryCounter.max() ?? -1) else { return  }
            star.image = UIImage(named: "icon-24-star-n" + String(categoryIndex))
        }
        
        
        

    }

}
