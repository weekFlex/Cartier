//
//  TaskListView.swift
//  WeekFlex
//
//  Created by dohan on 2021/03/17.
//

import UIKit

//MARK: Protocol
protocol TaskListViewDelegate: AnyObject {
    func didTabbedStar(cellIndex: Int, viewIndex:Int, isDone:Bool)
    func didTabbedMeatballs(cellIndex: Int, viewIndex:Int)
}


class TaskListView: UIView {
    
    //MARK: Variable
    
    private let xibName = "TaskListView"
    var cellIndex = 0   //이 view가 속한 cell의 index
    var viewIndex = 0   //이 view의 index
    var delegate: TaskListViewDelegate?
    var category = ""
    var isDone: Bool = false {
        didSet{
            if(isDone){
                star.setImage(UIImage(named: category),for: .normal)
            }else{
                star.setImage(UIImage(named: "icon24StarDisabled"),for: .normal)
            }
        }
    }
    
    //MARK: IBOutlet
    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var star: UIButton!
    @IBOutlet weak var meatBalls: UIButton!
    
    
    
    
    //MARK: IBAction
    @IBAction func starTabbed(_ sender: Any) {
        isDone = !isDone
        print(isDone)
        self.delegate?.didTabbedStar(cellIndex: cellIndex, viewIndex: viewIndex, isDone: isDone)
    }
    
    @IBAction func meatBallTabbed(_ sender: Any) {
        
        self.delegate?.didTabbedMeatballs(cellIndex: cellIndex, viewIndex: viewIndex)
    }
    
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with viewModel: TaskItemPresentable) {
        taskTitle.text = viewModel.taskTitle
        time.text = viewModel.time
        isDone = viewModel.done
        category = viewModel.category
        if(isDone){
            star.setImage(UIImage(named:category ), for: .normal)
        }else{
            star.setImage(UIImage(named: "icon24StarDisabled"), for: .normal)
        }
        
    }
    
}
