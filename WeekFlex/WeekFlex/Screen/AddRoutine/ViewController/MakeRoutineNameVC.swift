//
//  RoutineNameVC.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/03/29.
//

import UIKit

class MakeRoutineNameVC: UIViewController {

    
    // MARK: Variable Part
    
    var routineNameArray: [String]?
    
    // MARK: IBOutlet
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var routineNameTextField: UITextField!
    
    // MARK: IBAction
    
    
    @IBAction func checkButtonDidTap(_ sender: Any) {
    // check Button 클릭 시 Action
        
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SelectToDoVC") as? SelectToDoVC else {
            return
        }
        
        nextVC.routineName = self.routineNameTextField.text
        // 루틴 이름을 넘겨줌
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        // navigationController를 이용해 다음 뷰로 이동
        
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        // 뒤로가기 버튼 클릭 시 Action
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: Life Cycle Part
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setView()
        setTextField()
        UserDefaults.standard.setValue("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJpZFwiOjMsXCJlbWFpbFwiOlwibWluaUBrYWthby5jb21cIn0ifQ.OR6VUYpvHealBtmiE97xjwT3Z16_TfMfLYiri1j05ek", forKey: "UserToken")
        // Do any additional setup after loading the view.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // 이 뷰에 들어오자 마자 바로 키보드 띄우고 cursor 포커스 주기
        self.routineNameTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 뷰 클릭 시 키보드 내리기
        view.endEditing(true)
    }

    

}

// MARK: Extension

extension MakeRoutineNameVC {
    
    // MARK: Function
    
    func setView() {
        
        titleLabel.setLabel(text: "루틴 추가하기", color: .black, font: .appleMedium(size: 18))
        explainLabel.setLabel(text: "루틴 이름을 입력해주세요", color: .black, font: .appleBold(size: 20))
        
        checkButton.isEnabled = false
    }
    
    func setTextField() {
        
        routineNameTextField.borderStyle = .none
        routineNameTextField.placeholder = "ex. English Master"
        routineNameTextField.font = .metroBold(size: 28)
        
        routineNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        // routineNameTextField가 수정될 때 마다 실행
        
        routineNameTextField.delegate = self
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text?.count == 0 || textField.text == nil {
            // Text가 존재하지 않을 때 버튼 비활성화
            
            explainLabel.text = "ex. English Master"
            checkButton.setImage(UIImage(named: "icon32CheckInactive"), for: .normal)
            checkButton.isEnabled = false
        } else {
            // Text가 존재할 때 버튼 활성화
            if let routineNameArray = routineNameArray {
                if routineNameArray.contains(textField.text!) {
                    // 이미 있는 루틴 이름이라면

                    explainLabel.text = "이미 존재하는 루틴 이름이에요 ;ㅅ;"
                    checkButton.setImage(UIImage(named: "icon32CheckInactive"), for: .normal)
                    checkButton.isEnabled = false
                } else {
                    // 루틴 이름에 존재하지 않는다면
                    
                    explainLabel.text = "멋진 이름이에요! *-*"
                    checkButton.setImage(UIImage(named: "icon32CheckBlack"), for: .normal)
                    checkButton.isEnabled = true
                    
                }
            }
            
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

extension MakeRoutineNameVC: UITextFieldDelegate {
    
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
