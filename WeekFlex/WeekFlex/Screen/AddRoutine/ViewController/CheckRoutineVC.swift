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
    
    
    // 루틴 수정 뷰에서 왔는지 알 수 있는 변수
    var routineEditEnable: Bool = false
    
    // MARK: IBOutlet
    
    @IBOutlet weak var routineNameTextField: UITextField!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    // MARK: IBAction
    
    
    @IBAction func saveButtonDidTap(_ sender: UIButton) {
        // 저장하기 버튼 클릭 Event
        
        /*
         경우에 따라
         1. 루틴 생성 api
         2. 루틴 수정 api
         로 구분해줘야함
         */
        
        if !routineEditEnable {
            // 새로운 루틴 만들기라면?
            
            var routineTask: [RoutineTaskSaveRequest] = []
            
            if let routineList = routineList {
                for i in 0...routineList.count - 1 {
                    routineTask.append(RoutineTaskSaveRequest(routineList[i].days!, routineList[i].id))
                }
                
            }
            var newRoutine = MakeRoutineData(routineNameTextField.text!,routineTask)
            
        }
        
       
        
    }
    
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
        
        if routineEditEnable {
            // 루틴 수정하기 일 때
            
            explainLabel.setLabel(text: "루틴을 수정하기 전 마지막으로 확인해 주세요!", color: .gray4, font: .appleMedium(size: 16), letterSpacing: -0.16)
            routineNameTextField.isEnabled = true
            
            
        } else {
            // 루틴 생성하기 일 때
            
            explainLabel.setLabel(text: "짜잔! 마지막으로 루틴을 확인해 주세요:)", color: .gray4, font: .appleMedium(size: 16), letterSpacing: -0.16)
            routineNameTextField.isEnabled = false
            
        }
        
        routineNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        // routineNameTextField가 수정될 때 마다 실행

        saveButton.setButton(text: "저장하기", color: .white, font: .appleBold(size: 16), backgroundColor: .black)
        saveButton.setRounded(radius: 3)
        
        if routineList != nil {
            taskTableView.reloadData()
        }
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.separatorStyle = .none
        
        
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

// MARK: UITableViewDelegate

extension CheckRoutineVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    
}


// MARK: UITableViewDataSource

extension CheckRoutineVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let data = routineList {
            return data.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckRoutineCell.identifier, for: indexPath) as? CheckRoutineCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        if let data = routineList {
            
            cell.configure(data: data[indexPath.row])
            
            if indexPath.row == (data.count-1) {
                cell.lineView.isHidden = true
            } else {
                cell.lineView.isHidden = false
            }
            
        }
        
        return cell
        
    }
    
    
}
