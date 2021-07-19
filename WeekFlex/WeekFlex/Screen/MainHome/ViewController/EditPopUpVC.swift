//
//  EditPopUpVC.swift
//  WeekFlex
//
//  Created by dohan on 2021/04/14.
//

import Foundation
import UIKit

protocol EditPopUpDelegate: AnyObject {
    func didTabEdit(cellIndex: Int, viewIndex:Int)
    func didTabDelete(cellIndex: Int, viewIndex:Int, todoId:Int)
}
class EditPopUpVC: UIViewController {
    
    //MARK: Variable
    
    var todoId: Int = 0
    
    var taskTitle: String = ""
    weak var delegate: EditPopUpDelegate?
    
    //MARK: IBOutlet
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var taskLabel: UILabel!
    
    
    //MARK: IBAction
    
    @IBAction func editButton(_ sender: Any) {
        //        delegate?.didTabEdit(cellIndex: cellIndex, viewIndex: viewIndex)
    }
    @IBAction func deleteButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "해당 할일이 삭제됩니다.", message: "이대로 삭제를 진행할까요?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "그만두기", style: .default, handler : nil)
        let delete = UIAlertAction(title: "삭제하기", style: .cancel) { (action) in
            
            if NetworkState.isConnected() {
                // 네트워크 연결 시
                if let token = UserDefaults.standard.string(forKey: "UserToken") {
                    print("network연결")
                    
                    APIService.shared.deleteTodo(token, todoId: self.todoId){ result in
                        switch result {
                        
                        case .success(let data):
                            print("삭제완료: ", data)
                            
                        // 데이터 전달 후 다시 로드
                        
                        case .failure(let error):
                            print(error)
                            print("오류!!")
                        }
                    }
                }
            } else {
                // 네트워크 미연결 팝업 띄우기
                print("네트워크 미연결")
            }
            
            
            self.dismiss(animated: true, completion: nil)
            
            
        }
        
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert,animated: false, completion: nil)
        
        
        //        delegate?.didTabDelete(cellIndex: cellIndex, viewIndex: viewIndex)
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { super.touchesBegan(touches, with: event)
        if let touch = touches.first , touch.view == self.view { self.dismiss(animated: true, completion: nil) } }
    
}

extension EditPopUpVC {
    
    func setLayout(){
        self.popupView.layer.cornerRadius = 20
        self.taskLabel.text = taskTitle
    }
}
