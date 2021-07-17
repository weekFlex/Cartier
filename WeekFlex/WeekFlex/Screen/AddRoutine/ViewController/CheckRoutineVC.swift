//
//  CheckRoutineVC.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/07/18.
//

import UIKit

class CheckRoutineVC: UIViewController {

    
    // MARK: Variable Part
    
    var routineName: String?
    var routineList: [TaskListData]?
    
    // MARK: IBOutlet
    
    @IBOutlet weak var routineNameTextField: UITextField!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    // MARK: IBAction
    
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        // 뒤로가기 버튼 클릭 Event
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Life Cycle Part
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 뷰 클릭 시 키보드 내리기
        
        view.endEditing(true)
    }
    

}

// MARK: Extension

extension CheckRoutineVC {
    
    func setView() {
        
        routineNameTextField.font = .metroBold(size: 24)
        
        if let routineName = routineName {
            routineNameTextField.text = routineName
        }
        
        explainLabel.setLabel(text: "짜잔! 마지막으로 루틴을 확인해 주세요:)", color: .gray4, font: .appleMedium(size: 16), letterSpacing: -0.16)
        
        routineNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        // routineNameTextField가 수정될 때 마다 실행
        
        /*
         루틴 만들기 뷰에서 왔는지, 이미 있는 루틴 수정하기 뷰에서 왔는지를 판단해 루틴 이름을 수정할 수 있을지에 대한 여부를 줘야함
         
         */

        saveButton.setButton(text: "저장하기", color: .white, font: .appleBold(size: 16), backgroundColor: .black)
        saveButton.setRounded(radius: 3)
        
        if let list = routineList {
            print(list)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text?.count == 0 || textField.text == nil {
            // Text가 존재하지 않을 때 저장하기 버튼 비활성화
            
            saveButton.isEnabled = false
            
        } else {
            // Text가 존재할 때 저장하기 버튼 활성화
            
            saveButton.isEnabled = true
            
        }
        
        if let count = textField.text?.count {
            if count > 25 {
                // 루틴 이름이 최대인 25글자를 넘는다면?
                
                textField.deleteBackward()
                // 그 뒤에 글자들은 쳐져도 삭제된다
            }
        }
        
    }
    
}

// MARK: UITextFieldDelegate

extension CheckRoutineVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 리턴 키 클릭 시
        
        textField.endEditing(true)
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // textField 클릭하면 무조건 키보드 올라오게
        textField.becomeFirstResponder()
    }
    
}
