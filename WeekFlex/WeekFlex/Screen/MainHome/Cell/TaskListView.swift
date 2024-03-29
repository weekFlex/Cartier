//
//  TaskListView.swift
//  WeekFlex
//
//  Created by dohan on 2021/03/17.
//

import UIKit
import Foundation
import RxCocoa
import RxSwift


protocol TaskListCellDelegate: AnyObject {
    func didTabStar(cellIndex: Int, viewIndex: Int, isDone:Bool)
    func didTabMeatBall(cellIndex: Int, viewIndex:Int, todoId: Int)
}

class TaskListView: UIView {
    
    //MARK: Variable
    
    private let xibName = "TaskListView"
    weak var delegate: TaskListCellDelegate?
    let bag = DisposeBag()
    var todoId = 0      // todoId
    var cellIndex = 0   //이 view가 속한 cell의 index (routine)
    var viewIndex = 0   //이 view의 index (todos)
    var category = 0
    var isDone: Bool = false {
        didSet{
            if(isDone){
                star.setImage(UIImage(named: "icon-24-star-n" + String(category)),for: .normal)
            }else{
                star.setImage(UIImage(named: "icon-24-star-n"),for: .normal)
            }
        }
    }
    
    //MARK: IBOutlet
    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var star: UIButton!
    @IBOutlet weak var meatBalls: UIButton!
    
    
    
    
    //MARK: IBAction
    @IBAction func starTabbed(_ sender: Any) {
        print("별눌림")
        isDone = !isDone
        self.delegate?.didTabStar(cellIndex: cellIndex, viewIndex: viewIndex, isDone: isDone)
        
    }
    
    @IBAction func meatBallTabbed(_ sender: Any) {
        print("미트볼눌림?")
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
        starTapped()
        taskTitle.text = viewModel.name
        isDone = viewModel.done
        category = viewModel.categoryColor
        if(isDone){
            star.setImage(UIImage(named:"icon-24-star-n" + String(category) ), for: .normal)
        }else{
            star.setImage(UIImage(named: "icon-24-star-n"), for: .normal)
        }

        guard let startTime = viewModel.startTime, let endTime = viewModel.endTime else{return}
        
        let timeLabel = UILabel()
        timeLabel.text = "\(startTime) - \(endTime)"
        timeLabel.font = UIFont.appleRegular(size: 13)
        timeLabel.textColor = UIColor.gray3
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        taskTitle.addSubview(timeLabel)
        timeLabel.leadingAnchor.constraint(equalTo: taskTitle.leadingAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: taskTitle.bottomAnchor, constant: 2).isActive = true
        
    }
    
    func starTapped(){
        star.rx.tap.asDriver().debounce(.seconds(1)).drive(onNext: { [self] in
            if let token = UserDefaults.standard.string(forKey: "UserToken") {
                APIService.shared.checkTodo(token, todoId: todoId, done: isDone){ result in
                    switch result {
                        
                    case .success(_):
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
        }).disposed(by: bag)
    }
}
