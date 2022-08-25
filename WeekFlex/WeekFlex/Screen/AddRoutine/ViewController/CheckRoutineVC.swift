//
//  CheckRoutineVC.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/07/18.
//

import UIKit
import SnapKit

class CheckRoutineVC: UIViewController {

    // MARK: - Variable Part
    var routineName: String?
    var routineList: [TaskListData]?
    var routineEditEnable: Bool = false
    private var routineNameEditButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon24Edit"),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(routineNameEditButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: - IBOutlet
    @IBOutlet weak var routineNameTextField: UITextField!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: IBAction
    @IBAction func saveButtonDidTap(_ sender: UIButton) {
        switch routineEditEnable {
        case true:
            break
        case false:
            var routineTask: [RoutineTaskSaveRequest] = []
            
            if let routineList = routineList {
                for i in 0...routineList.count - 1 {
                    if let days = routineList[i].days {
                        routineTask.append(RoutineTaskSaveRequest(days: days, taskId: routineList[i].id))
                    }
                }
            }
            guard NetworkState.isConnected() else {
                // TODO: 네트워크 미연결 팝업 띄우기
                return
            }
            guard let name = routineNameTextField.text,
                  let token = UserDefaults.standard.string(forKey: "UserToken") else { return }
            APIService.shared.makeRoutine(token, name, routineTask) { [self] result in
                switch result {
                case .success(_):
                    //루틴 생성하기 완료
                    self.navigationController?.viewControllers.forEach {
                        if let vc = $0 as? MyRoutineListVC {
                            vc.userType = .newUser(level: 2)
                            self.navigationController?.popToViewController(vc, animated: true)
                            return
                            // 이전으로 돌아감
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func routineNameEditButtonDidTap() {
        routineNameTextField.isEnabled = true
        routineNameTextField.becomeFirstResponder()
        routineNameEditButton.isHidden = true
    }
    
    // MARK: - Life Cycle Part
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupAttributes()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 뷰 클릭 시 키보드 내리기
        routineNameEditButton.isHidden = false
        view.endEditing(true)
    }
}

// MARK: Extension
extension CheckRoutineVC {
    func setupDelegate() {
        routineNameTextField.delegate = self
        taskTableView.delegate = self
        taskTableView.dataSource = self
    }
    func setupAttributes() {
        routineNameTextField.font = .metroBold(size: 24)
        routineNameTextField.minimumFontSize = 24
        routineNameTextField.sizeToFit()
        routineNameTextField.isEnabled = false
        if let routineName = routineName {
            routineNameTextField.text = routineName
        }
        routineNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        let explainLabelText: String = routineEditEnable ? "루틴을 수정하기 전 마지막으로 확인해 주세요!" : "짜잔! 마지막으로 루틴을 확인해 주세요:)"
        explainLabel.setLabel(text: explainLabelText, color: .gray4, font: .appleMedium(size: 16), letterSpacing: -0.16)
        
        taskTableView.separatorStyle = .none
        if routineList != nil {
            taskTableView.reloadData()
        }
        
        saveButton.setButton(text: "저장하기", color: .white, font: .appleBold(size: 16), backgroundColor: .black)
        saveButton.setRounded(radius: 3)
    }
    func setupLayout() {
        view.addSubview(routineNameEditButton)
        routineNameEditButton.snp.makeConstraints {
            $0.left.equalTo(routineNameTextField.snp.right)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
            $0.centerY.equalTo(routineNameTextField.snp.centerY)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let textFieldState: Bool = !(textField.text?.count == 0 || textField.text == nil)
        saveButton.isEnabled = textFieldState
        
        if let count = textField.text?.count,
           count > 25 {
            textField.deleteBackward()
        }
    }
}

// MARK: UITextFieldDelegate
extension CheckRoutineVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        routineNameEditButton.isHidden = false
        return true
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckRoutineCell.identifier, for: indexPath)
                as? CheckRoutineCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        guard let data = routineList else {
            return cell
        }
        cell.configure(data: data[indexPath.row])
        cell.lineView.isHidden = indexPath.row == (data.count-1)
        return cell
    }
}
