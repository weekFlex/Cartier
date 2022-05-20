//
//  ToDoListVC.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/03/21.
//

import UIKit

class SelectToDoVC: UIViewController {
    
    // MARK: Variable Part
    
    var routineName: String?
    var categoryData: [CategoryData] = []
    var taskData: [TaskData] = [] // 서
    var searchTask: [TaskListData] = [] // 검색어에 맞는 task 저장하는 배열
    var allTask: [TaskListData] = [] // 전체 task 저장하는 배열
    
    var selectedViewModel : [TaskListData] = []
    
    // 검색 할 text
    var searchText: String? = nil
    
    // 카테고리의 첫번째가 항상 default로 보여지게 만들기 위한 변수
    var categoryIndex: Int = 0
    
    // 모달 뒤에 뜰 회색 전체 뷰
    var modalBackgroundView: UIView!
    var routineEditEnable: Bool = false
    
    // notification
    let didDismissCreateTodoVC: Notification.Name = Notification.Name("didDismissCreateTodoVC")
    
    // ToolTip
    private lazy var tooltipView = MyTopTipView(
        viewColor: UIColor.black,
        tipStartX: 240.0,
        tipWidth: 14.0,
        tipHeight: 9.0,
        text: "루틴에 추가할 새로운 할 일을 만들어보세요!",
        state: .down(height: 35.0),
        dismissActions: tooltipAction
    )
    
    // MARK: IBOutlet
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var selectRoutineView: UIView!
    @IBOutlet weak var selectedCollectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var selectedRoutineViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var routineNameLabel: UILabel!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var textFieldView: UIView!
    
    @IBOutlet weak var todoCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            // 동적 사이즈를 주기 위해 estimatedItemSize 를 사용했다. 대략적인 셀의 크기를 먼저 조정한 후에 셀이 나중에 AutoLayout 될 때, 셀의 크기가 변경된다면 그 값이 다시 UICollectionViewFlowLayout에 전달되어 최종 사이즈가 결정되게 된다.
        }
    }
    
    @IBOutlet weak var addTaskButton: UIButton!
    
    // MARK: IBAction
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        // 뒤로가기 버튼 클릭 시 Action
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonDidTap(_ sender: UIButton) {
        
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "CheckRoutineVC") as? CheckRoutineVC else {
            return
        }
        
        nextVC.routineName = routineNameLabel.text
        // 루틴 이름을 넘겨줌
        nextVC.routineList = selectedViewModel
        nextVC.routineEditEnable = routineEditEnable
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        // navigationController를 이용해 다음 뷰로 이동
        
    }
    
    @IBAction func addTaskButtonDidTap(_ sender: Any) {
        let editRoutineStoryboard = UIStoryboard.init(name: "EditRoutine", bundle: nil)
        guard let editRoutineVC = editRoutineStoryboard.instantiateViewController(identifier: "EditRoutineVC") as? EditRoutineVC else { return }
        editRoutineVC.modalTransitionStyle = .coverVertical
        editRoutineVC.modalPresentationStyle = .custom
        editRoutineVC.entryNumber = 2
        self.present(editRoutineVC, animated: true, completion: .none)
    }
    
    
    // MARK: Life Cycle Part
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        setLabel()
        setView()
        setDelegate()
        setNotificationCenter()
        getTask()
        addTooltip()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 뷰 클릭 시 키보드 내리기
        view.endEditing(true)
    }
    
}

// MARK: Extension

extension SelectToDoVC {
    
    // MARK: Function
    
    func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissCreateTodoVC(_:)), name: didDismissCreateTodoVC, object: nil)
    }
    
    func setButton() {
        
        backButton.setImage(UIImage(named: "icon32BackWhite"), for: .normal)
        backButton.tintColor = .white
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.titleLabel?.font = UIFont.appleMedium(size: 16)
        nextButton.tintColor = UIColor.gray4
        
        addTaskButton.makeRounded(cornerRadius: nil)
        
    }
    
    func setLabel() {
        
        if let routineName = routineName {
            // 이전뷰에서 루틴 이름을 설정해서 받아 올 예정
            routineNameLabel.setLabel(text: routineName, color: .white, font: .metroBold(size: 24))
        } else {
            routineNameLabel.setLabel(text: "English Master :-)", color: .white, font: .metroBold(size: 24))
        }
        
        searchTextField.placeholder = "원하는 할 일을 찾을 수 있어요"
        searchTextField.returnKeyType = .done
        searchTextField.font = UIFont.appleRegular(size: 14)
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // TextField가 수정될 때 마다 실행
        
        emptyLabel.setLabel(text: "루틴에 추가할 할 일을 선택하세요", color: .gray2, font: .appleRegular(size: 16))
        
    }
    
    func setView() {
        
        self.view.backgroundColor = .white
        headerView.backgroundColor = .black
        
        // category 밑에 그림자 추가
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOffset = CGSize(width: 0,height: 6)
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 0.10
        shadowView.layer.shadowColor = UIColor.gray2.cgColor
        
        textFieldView.backgroundColor = .gray1
        
        selectRoutineView.backgroundColor = .clear
        selectedCollectionView.backgroundColor = .clear
        
        let layout = selectedCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        
    }
    
    func setDelegate() {
        
        searchTextField.delegate = self
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        todoCollectionView.delegate = self
        todoCollectionView.dataSource = self
        
        selectedCollectionView.delegate = self
        selectedCollectionView.dataSource = self
        
        let customLayout = LeftAlignFlowLayout()
        // Cell 왼쪽정렬
        
        customLayout.updateCell = { num in
            // selectedCollectionView 높이 변경
            
            self.selectedRoutineViewHeightConstraint.constant = (num+1) * 32
        }
        
        selectedCollectionView.collectionViewLayout = customLayout
        customLayout.estimatedItemSize = CGSize(width: 41, height: 41)
        
    }
    
    func addTooltip() {
        guard UserDefaults.standard.string(forKey: "Launch_STD") != nil else { return }
        self.view.addSubview(self.tooltipView)
        
        tooltipView.snp.makeConstraints {
            $0.trailing.equalTo(addTaskButton.snp.trailing).inset(+2)
            $0.bottom.equalTo(addTaskButton.snp.top).inset(-17)
            $0.width.equalTo(277.0)
            $0.height.equalTo(35.0)
        }
        
        UserDefaults.standard.removeObject(forKey: "Launch_STD")
    }
    
    func tooltipAction() {
        UIView.transition(with: self.view,
                        duration: 0.25,
                        options: [.transitionCrossDissolve],
                        animations: { self.tooltipView.removeFromSuperview() },
                        completion: nil)
    }
    
    @objc func didDismissCreateTodoVC(_ noti: Notification) {
        getTask()
        // @민희언니
        // 여기에서 noti로 받아서
        // 할일 추가 완료하고 reload 하게 하려고 했는뎅 새로고침이 안되네욥 ...
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // TextField가 수정될 때 마다 실행 될 함수
        
        // 전체 카테고리로 이동
        categoryIndex = 0
        categoryCollectionView.selectItem(at: [0,categoryIndex], animated: false, scrollPosition: .right)
        
        if textField.text == "" {
            // 검색어 비워두기
            searchText = nil
            
        } else {
            searchText = textField.text
        }
        
        todoCollectionView.reloadData()
    }
    
    func getTask() {
        // 서버 연결 후 Task 불러오기
        
        if NetworkState.isConnected() {
            // 네트워크 연결 시
            
            if let token = UserDefaults.standard.string(forKey: "UserToken") {
                
                APIService.shared.getTask(token) { [self] result in
                    switch result {
                    
                    case .success(let data):
                        taskData = data
                        print("추가 완료!")
                        categoryCollectionView.reloadData()
                        todoCollectionView.reloadData()
                        // 데이터 전달 후 다시 로드
                        
                        // 첫번째 카테고리 선택을 default로 만듦
                        categoryCollectionView.selectItem(at: [0,0], animated: true, scrollPosition: .right)
                        
                    case .failure(let error):
                        print(error)
                        
                    }
                }
            }
        } else {
            // 네트워크 미연결 팝업 띄우기
            
        }
    }
    
}

extension SelectToDoVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textFieldView.backgroundColor = .gray1
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldView.backgroundColor = .black
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
        } else {
            textField.placeholder = "원하는 할 일을 찾을 수 있어요"
            textFieldView.backgroundColor = .gray1
        }
        return true
    }
}

extension SelectToDoVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                            indexPath: IndexPath) -> CGSize {
        
        if collectionView == selectedCollectionView {
            return CGSize(width: 300, height: self.selectRoutineView.frame.height)
        }
        else if collectionView == categoryCollectionView {
            return CGSize(width: 50, height: categoryCollectionView.frame.height)
        }
        else {
            return CGSize(width: collectionView.frame.width-32, height: 52)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == selectedCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else if collectionView == categoryCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else {
            return UIEdgeInsets(top: 14, left: 16, bottom: 10, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == selectedCollectionView {
            return 8
        }
        else if collectionView == categoryCollectionView {
            return 0
        }
        else {
            return 9
        }
        
    }
    
}
extension SelectToDoVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == selectedCollectionView {
            // 선택한 Todo
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedRoutineCell.identifier, for: indexPath) as? SelectedRoutineCell else { return UICollectionViewCell() }
            cell.configure(listName: selectedViewModel[indexPath.row].name)
            return cell
        }
        
        else if collectionView == categoryCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
            if indexPath.row == 0 {
                cell.configure(name: "전체", color: 0)
            } else {
                cell.configure(name: taskData[indexPath.row-1].category.name, color: taskData[indexPath.row-1].category.color)
            }
            
            return cell
            
            
            
        }
        else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoutineCell.identifier, for: indexPath) as? RoutineCell else { return UICollectionViewCell() }
            cell.timeLabel.text = ""
            
            if searchText != nil {
                // 검색중이라면?
                
                cell.configure(data: searchTask[indexPath.row])
                
                if selectedViewModel.count > 0 {
                    for i in 0...selectedViewModel.count-1 {
                        if searchTask[indexPath.row].name == selectedViewModel[i].name {
                            // 만약에 내가 선택한 루틴이라면?
                            
                            if let days = selectedViewModel[i].days?.map({ $0.name }).joined(separator: ", ") {
                                if let startTime = selectedViewModel[i].days?[0].startTime?.changeTime(),
                                   let endTime = selectedViewModel[i].days?[0].endTime?.changeTime() {
                                    cell.timeLabel.text = "\(days) \(startTime)-\(endTime)"
                                } else {
                                    cell.timeLabel.text = "\(days)"
                                }
                            }
                            
                            cell.selected()
                            // 배경 컬러 주기
                            break
                        }
                    }
                }
                
            } else {
                // 검색중이 아니라면 ==> 카테고리를 선택해서 보고있다면
                
                if categoryIndex == 0 {
                    // 전체 카테고리라면?
                    
                    cell.configure(data: allTask[indexPath.row])
                    
                    if selectedViewModel.count > 0 {
                        for i in 0...selectedViewModel.count-1 {
                            if allTask[indexPath.row].name == selectedViewModel[i].name {
                                // 만약에 내가 선택한 루틴이라면?
                                
                                if let days = selectedViewModel[i].days?.map({ $0.name }).joined(separator: ", ") {
                                    if let startTime = selectedViewModel[i].days?[0].startTime?.changeTime(),
                                       let endTime = selectedViewModel[i].days?[0].endTime?.changeTime() {
                                        cell.timeLabel.text = "\(days) \(startTime)-\(endTime)"
                                    } else {
                                        cell.timeLabel.text = "\(days)"
                                    }
                                }
                                
                                
                                cell.selected()
                                // 배경 컬러주기
                                break
                            }
                        }
                    }
                    
                } else {
                    // 특정 카테고리를 보고있다면?
                    
                    cell.configure(data: taskData[categoryIndex-1].tasks[indexPath.row])
                    
                    if selectedViewModel.count > 0 {
                        for i in 0...selectedViewModel.count-1 {
                            if taskData[categoryIndex-1].tasks[indexPath.row].name == selectedViewModel[i].name {
                                // 만약에 내가 선택한 루틴이라면?
                                
                                if let days = selectedViewModel[i].days?.map({ $0.name }).joined(separator: ", ") {
                                    if let startTime = selectedViewModel[i].days?[0].startTime?.changeTime(),
                                       let endTime = selectedViewModel[i].days?[0].endTime?.changeTime() {
                                        cell.timeLabel.text = "\(days) \(startTime)-\(endTime)"
                                    } else {
                                        cell.timeLabel.text = "\(days)"
                                    }
                                }
                                
                                cell.selected()
                                // 배경 컬러주기
                                break
                            }
                        }
                    }
                    
                }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if collectionView == selectedCollectionView {
            // 클릭한 루틴 보여주는 CollectionView
            
            if selectedViewModel.count != 0 {
                emptyLabel.isHidden = true
                nextButton.isEnabled = true
                nextButton.tintColor = .white
                // 다음 버튼 활성화
                
            } else {
                
                emptyLabel.isHidden = false
                nextButton.isEnabled = false
                nextButton.tintColor = .gray4
                // 다음버튼 비활성화
                
            }
            return selectedViewModel.count
        }
        
        else if collectionView == categoryCollectionView {
            // 카테고리 CollectionView (사용자 카테고리 + 전체)
            
            return taskData.count+1
        }
        
        else {
            // Task CollectionView
            
            if searchText != nil {
                // 검색중이라면?
                
                searchTask = []
                
                for category in taskData {
                    searchTask += category.tasks.filter { $0.name.contains(searchText!) == true }
                }
                return searchTask.count
                
            } else {
                // 검색중이 아니라면 ==> 카테고리를 선택해서 보고있다면
                
                if categoryIndex == 0 {
                    // 전체 카테고리라면?
                    
                    allTask = []
                    // 전체 Task 갯수
                    
                    for category in taskData {
                        allTask += category.tasks
                    }
                    return allTask.count
                    
                } else {
                    // 특장 카테고리라면?
                    return taskData[categoryIndex-1].tasks.count
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == selectedCollectionView {
            // x 버튼 클릭 시 ( 선택 해제 )
            
            listItemRemoved(value: indexPath.row)
            selectedCollectionView.reloadData()
            todoCollectionView.reloadData()
        }
        
        else if collectionView == categoryCollectionView {
            
            categoryIndex = indexPath.row
            
            // // 검색어가 있는 상태에서 카테고리를 선택했다면? 경우
            
            searchText = nil
            // 검색어 제거
            searchTextField.text = nil
            // 텍스트 필드 비워두기
            textFieldView.backgroundColor = .gray1
            searchTextField.endEditing(false)
            // 키보드 내리기
            todoCollectionView.reloadData()
        }
        
        else {
            // Task CollectionView
            
            let cells = collectionView.cellForItem(at: indexPath) as? RoutineCell
            
            if selectedViewModel.count > 0 {
                // selectedViewModel이 비어있지 않다면?
                var check = false
                for i in 0...selectedViewModel.count-1 {
                    // 이미 추가 된 루틴인지 검사하는 과정이 필요 (중복 추가를 막기 위해)
                    if cells?.routineNameLabel.text == selectedViewModel[i].name {
                        check = true
                        break
                    }
                }
                if check == false {
                    // 추가 안된 루틴이라면 -> 추가
                    
                    if let value = cells?.routine {
                        // move to editRoutinVC
                        initEditRoutineVC(withValue: value)
                    }
                }
            } else {
                // selectedViewModel이 비어있다면? -> 무조건 추가
                
                if let value = cells?.routine {
                    // move to editRoutinVC
                    initEditRoutineVC(withValue: value)
                }
            }
        }
    }
}

extension SelectToDoVC: SaveTaskListProtocol, HideViewProtocol {
    func hideViewProtocol() {
        modalBackgroundView.removeFromSuperview()
    }
    
    func saveDaysProtocol(savedTaskListData :TaskListData) {
        // 시간 넣어주기
        
        listItemAdded(value: savedTaskListData)
        todoCollectionView.reloadData()
        selectedCollectionView.reloadData()
    }
    
    func initEditRoutineVC(withValue: TaskListData) {
        modalAppeared()
        let editRoutineStoryboard = UIStoryboard.init(name: "EditRoutine", bundle: nil)
        guard let editRoutineVC = editRoutineStoryboard.instantiateViewController(identifier: "EditRoutineVC") as? EditRoutineVC else { return }
        editRoutineVC.modalTransitionStyle = .coverVertical
        editRoutineVC.modalPresentationStyle = .custom
        editRoutineVC.entryNumber = 1
        editRoutineVC.taskListData = withValue
        editRoutineVC.saveTaskListDataDelegate = self
        editRoutineVC.hideViewDelegate = self
        // value 자체를 가져가서 업데이트
        self.present(editRoutineVC, animated: true, completion: .none)
    }
    
    func modalAppeared() {
        modalBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: Int(view.bounds.width), height: Int(view.bounds.height)))
        modalBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.addSubview(modalBackgroundView)
    }
}

extension SelectToDoVC: SelectedItemViewDelegate {
    
    func listItemAdded(value: TaskListData) {
        // 리스트에 추가하기
        
        var changeHour: TaskListData = value

        for i in 0...value.days!.count - 1 {
            // 서버에 보낼 형식으로 변경해서 저장
            
            if let startTime = value.days?[i].startTime,
               let endTime = value.days?[i].endTime {
                changeHour.days?[i].startTime = startTime.changeHour()
                changeHour.days?[i].endTime = endTime.changeHour()
            }
        }
        
        selectedViewModel.insert(changeHour, at: 0)
    }
    
    func listItemRemoved(value: Int) {
        // 리스트에서 지우기
        selectedViewModel.remove(at: value)
    }
    
}
