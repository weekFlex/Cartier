//
//  TaskListView.swift
//  WeekFlex
//
//  Created by dohan on 2021/03/17.
//

import UIKit
import Foundation


protocol TaskListCellDelegate: class {
    func didTabStar(cellIndex: Int, viewIndex: Int, isDone:Bool)
    func didTabMeatBall(cellIndex: Int, viewIndex:Int, todoId: Int)
}


class TaskListView: UIView {
    
    //MARK: Variable
    
    private let xibName = "TaskListView"
    var todoId = 0
    var cellIndex = 0//이 view가 속한 cell의 index
    var viewIndex = 0   //이 view의 index
    weak var delegate: TaskListCellDelegate?
    var category = 0
    var isDone: Bool = false {
        didSet{
            if(isDone){
                star.setImage(UIImage(named: "icon-24-star-n" + String(category)),for: .normal)
            }else{
                star.setImage(UIImage(named: "icon-24-star-n0"),for: .normal)
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
        if let token = UserDefaults.standard.string(forKey: "UserToken") {
            
            APIService.shared.checkTodo(token, todoId: todoId){ [self] result in
                switch result {
                
                case .success(let data):
                    print("체크완료")
                // 데이터 전달 후 다시 로드
                
                case .failure(let error):
                    print(error)
                    print("오류!!")
                }
            
        }
    } else {
        // 네트워크 미연결 팝업 띄우기
        print("네트워크 미연결")
    }
        
        
        isDone = !isDone
//        self.delegate?.didTabStar(cellIndex: cellIndex, viewIndex: viewIndex, isDone: isDone)
    }
    
    @IBAction func meatBallTabbed(_ sender: Any) {
        self.delegate?.didTabMeatBall(cellIndex: self.cellIndex, viewIndex: self.viewIndex, todoId: self.todoId )
    }
    
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with viewModel: TodoData) {
        
        taskTitle.text = viewModel.name
        time.text = viewModel.startTime + " - " + viewModel.endTime
        isDone = viewModel.done
        category = viewModel.categoryColor
        if(isDone){
            star.setImage(UIImage(named:"icon-24-star-n" + String(category) ), for: .normal)
        }else{
            star.setImage(UIImage(named: "icon-24-star-n0"), for: .normal)
        }
        
    }
    
}
