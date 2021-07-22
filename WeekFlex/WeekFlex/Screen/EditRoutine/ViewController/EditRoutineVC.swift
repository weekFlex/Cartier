//
//  EditRoutineVC.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/04/23.
//

import UIKit

class EditRoutineVC: UIViewController {
    
    // MARK: - Variables
    
    private let days = ["월", "화", "수", "목", "금", "토", "일"]
    var saveTaskListDataDelegate: SaveTaskListProtocol?
    var saveTodoDataDelegate: SaveTodoProtocol?
    var hideViewDelegate: HideViewProtocol?
    var todo: Todo?
    var taskListData: TaskListData?
    var daysStructList: [Day]?
    var entryNumber: Int?
    var dayDict: [String:Int]?
    var date: String? // 홈에서 할일을 추가하는 경우 필요
    var todoData: TodoData?
    var cellIndex: Int?
    var viewIndex: Int?
    
    // View Model
    private var editRouineViewModel : EditRoutineViewModel!
    private var categoryViewModel: CategoryViewModel?
    
    // noti
    let didDismissCreateTodoVC: Notification.Name = Notification.Name("didDismissCreateTodoVC")
    
    // MARK: - IBOutlet
    
    // constraints
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var routineTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet var categoryTopConstraint: NSLayoutConstraint!
    @IBOutlet var daysHeaderLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet var weekCollectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var timeSettingHeaderLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet var switchTopConstraint: NSLayoutConstraint!
    
    // category
    @IBOutlet var categoryUIView: UIView!
    @IBOutlet var categoryHeaderLabel: UILabel!
    @IBOutlet var categoryTapEnabledUIView: UIView!
    @IBOutlet var categoryRightArrow: UIImageView!
    @IBOutlet var categoryTitle: UILabel!
    @IBOutlet var categoryColor: UIImageView!
    // daysHeaderLabel - 요일
    @IBOutlet var daysHeaderLabel: UILabel!
    
    @IBOutlet var editUIView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var completeButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var routineTitle: UITextField!
    @IBOutlet var weekCollectionView: UICollectionView!
    @IBOutlet var collectionviewHeight: NSLayoutConstraint!
    @IBOutlet var timeHeaderLabel: UILabel!
    @IBOutlet var timeSwitch: UISwitch!
    @IBOutlet var startTimeSubLabel: UILabel!
    @IBOutlet var endTimeSubLabel: UILabel!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    @IBOutlet var topLayerUIView: UIView!
    
    // MARK: - IBAction
    
    // switch
    @IBAction func timeSwitchValueChanged(_ sender: Any) {
        if timeSwitch.isOn { // switch on
            // show time labels
            showTimeLabel()
            topLayerUIView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            view.bringSubviewToFront(topLayerUIView)
            // move to editRoutinTimeVC
            guard let editRoutineTimeVC = self.storyboard?.instantiateViewController(identifier: "EditRoutineTimeVC") as? EditRoutineTimeVC else { return }
            editRoutineTimeVC.modalTransitionStyle = .coverVertical
            editRoutineTimeVC.modalPresentationStyle = .custom
            // pass time data
            // if there's no time data in routine, give dummy data
            if !editRouineViewModel.hasTimeSetting {
                editRouineViewModel.updateStartTime(startTime: "10:00")
                editRouineViewModel.updateEndTime(endTime: "11:00")
            }
            editRoutineTimeVC.editRoutineViewModel = EditRoutineViewModel(self.editRouineViewModel.todo, days: self.editRouineViewModel.days)
            // connect delegate
            editRoutineTimeVC.saveTimeDelegate = self
            editRoutineTimeVC.hideViewDelegate = self
            self.present(editRoutineTimeVC, animated: true, completion: .none)
        } else { // switch off
            editRouineViewModel.updateStartTime(startTime: nil)
            editRouineViewModel.updateEndTime(endTime: nil)
            hideTimeLabel()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.hideViewDelegate?.hideViewProtocol()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeButtonPressed(_ sender: Any) {
        
        switch entryNumber {
        case 1:
            // Days 구조체로 넣어주기
            let dict = editRouineViewModel.days
            let newData = dict.reduce(into: [Day]()) { dayStruct, dayDict in
                if dayDict.value == 1 {
                    dayStruct.append(Day(endTime: editRouineViewModel.todo.endTime, startTime: editRouineViewModel.todo.startTime, name: dayDict.key))
                }
            }.sorted { first, second in
                let day = ["월":0, "화":1, "수":2, "목":3, "금":4, "토":5, "일":6]
                return day[first.name]! < day[second.name]!
            }
            taskListData?.days = newData
            // 이전 뷰로 데이터 넘겨주기
            
            if let taskListData = taskListData {
                self.saveTaskListDataDelegate?.saveDaysProtocol(savedTaskListData: taskListData)
            }
        case 2: // task 등록 - categoryId, name
            editRouineViewModel.updateName(name: routineTitle.text!)
            if let token = UserDefaults.standard.string(forKey: "UserToken") {
                TodoService().createTask(token: token, categoryId: editRouineViewModel.todo.categoryID!, name: editRouineViewModel.todo.name) { result in
                    switch result {
                    case true:
                        NotificationCenter.default.post(name: self.didDismissCreateTodoVC, object: nil, userInfo: nil) // 전 뷰에서 데이터 로드를 다시 하게 만들기 위해 Notofication post!
                        self.dismiss(animated: true, completion: nil)
                    case false:
                        print("실패")
                    }
                }
            }
            
        case 3:
            // 전 홈뷰에서 date 값을 가져왔어야함!
            if let date = date {
                editRouineViewModel.todo.date = date
                editRouineViewModel.todo.name = routineTitle.text!
            }
            if let token = UserDefaults.standard.string(forKey: "UserToken") {
                TodoService().createTodo(
                    token: token, categoryId: editRouineViewModel.todo.categoryID!, date: editRouineViewModel.todo.date!, endTime: editRouineViewModel.todo.endTime, startTime: editRouineViewModel.todo.startTime, name: editRouineViewModel.todo.name) { result in
                    switch result {
                    case true:
                        NotificationCenter.default.post(name: self.didDismissCreateTodoVC, object: nil, userInfo: nil) // 전 뷰에서 데이터 로드를 다시 하게 만들기 위해 Notofication post!
                    case false:
                        print("실패")
                    }
                }
            }
        case 4:
            let dict = editRouineViewModel.days
            let newData = dict.reduce(into: [String]()) { dayNameList, dayDict in
                if dayDict.value == 1 {
                    dayNameList.append(dayDict.key)
                }
            }.sorted { first, second in
                let day = ["월":0, "화":1, "수":2, "목":3, "금":4, "토":5, "일":6]
                return day[first]! < day[second]!
            }
            todoData?.days = newData
            todoData?.startTime = editRouineViewModel.todo.startTime
            todoData?.endTime = editRouineViewModel.todo.endTime
            todoData?.name = editRouineViewModel.todo.name
            if let todoData = todoData,
               let cellIndex = cellIndex,
               let viewIndex = viewIndex {
                self.saveTodoDataDelegate?.saveTodoProtocol(savedTodoData: todoData, cellIndex: cellIndex, viewIndex: viewIndex)
            }
            // 수정 api 통신
            if let token = UserDefaults.standard.string(forKey: "UserToken") {
                TodoService().updateTodo(token: token, days: (todoData?.days!)!, endTime: todoData?.endTime ?? nil, startTime: todoData?.startTime ?? nil, name: todoData!.name, todoId: todoData!.id) { result in
                    switch result {
                    case true:
                        print("성공")
                    case false:
                        print("실패")
                    }
                }
            }
            
        default:
            return
            
        }
        self.hideViewDelegate?.hideViewProtocol()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchListData() // fetch data using vm
        setLayout()
        setCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        editUIView.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 이 뷰에 들어오자 마자 바로 키보드 띄우고 cursor 포커스 주기
        self.routineTitle.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 뷰 클릭 시 키보드 내리기
        view.endEditing(true)
    }
    
}

// MARK: - Extension for Protocol

extension EditRoutineVC: SaveTimeProtocol, HideViewProtocol, SaveCategoryProtocol {
    
    // receive newly saved category data from CategoryViewVC
    func saveCategoryProtocol(savedCategory: CategoryData) {
        categoryViewModel = CategoryViewModel(savedCategory)
        editRouineViewModel.updateCategory(ID: categoryViewModel?.ID ?? 0)
        setCategoryData()
        if routineTitle.text?.count == 0 || routineTitle.text == nil {
            completeButton.isEnabled = false
        } else {
            completeButton.isEnabled = true
        }
    }
    
    func hideViewProtocol() {
        view.sendSubviewToBack(topLayerUIView)
        topLayerUIView.backgroundColor = UIColor(white: 0, alpha: 0.0)
    }
    
    // receive newly saved time data from EditRoutineTimeVC
    func saveTimeProtocol(savedTimeData: Todo) {
        editRouineViewModel = EditRoutineViewModel(savedTimeData, days: editRouineViewModel.days)
        setTimeLabel() //reset time label
    }
    
    // MARK: Method
    
    @objc func backgroundTapped(sender: UITapGestureRecognizer) {
        self.hideViewDelegate?.hideViewProtocol()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let _ = editRouineViewModel.todo.categoryID { //카테고리 설정 되어있어야지만 텍스트 확인, 안되어있으면 계속 비활성화!
            if textField.text?.count == 0 || textField.text == nil {
                // Text가 존재하지 않을 때 버튼 비활성화
                completeButton.isEnabled = false
            } else {
                completeButton.isEnabled = true
            }
        } else {
            completeButton.isEnabled = false
        }
    }
    
    @objc func categoryViewTapped(sender: UITapGestureRecognizer) {
        topLayerUIView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.bringSubviewToFront(topLayerUIView)
        guard let viewCategoryVC = self.storyboard?.instantiateViewController(identifier: "ViewCategoryVC") as? ViewCategoryVC else { return }
        viewCategoryVC.modalTransitionStyle = .coverVertical
        viewCategoryVC.modalPresentationStyle = .custom
        viewCategoryVC.hideViewDelegate = self
        viewCategoryVC.saveCategoryDelegate = self
        self.present(viewCategoryVC, animated: true, completion: .none)
    }
    
    // MARK: - function
    
    func setLayout() {
        // background
        topLayerUIView.backgroundColor = UIColor(white: 0, alpha: 0.0)
        view.backgroundColor = UIColor(white: 0, alpha: 0.0)
        topLayerUIView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped)))
        editUIView.backgroundColor = .white
        // header
        backButton.setImage(UIImage(named: "icon32CancleBlack"), for: .normal)
        completeButton.setImage(UIImage(named: "icon32CheckBlack"), for: .normal)
        completeButton.isEnabled = false
        // set routine name
        routineTitle.borderStyle = .none
        routineTitle.placeholder = "할 일을 적어주세요"
        routineTitle.font = .metroBold(size: 22)
        routineTitle.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        // routineTitle이 수정될 때 마다 실행
        routineTitle.delegate = self
        
        // category
        categoryHeaderLabel.setLabel(text: "카테고리", color: .black, font: .appleBold(size: 16))
        setCategoryData()
        categoryRightArrow.image = UIImage(named: "icon16Right")
        categoryUIView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(categoryViewTapped)))
        // days header
        daysHeaderLabel.setLabel(text: "요일", color: .black, font: .appleBold(size: 16))
        // collection view
        collectionviewHeight.constant = 41/375*view.bounds.width
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 41/375*view.bounds.width, height: 41/375*view.bounds.width)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 2
        weekCollectionView.collectionViewLayout = layout
        // time section
        timeHeaderLabel.setLabel(text: "시간 설정", color: .black, font: .appleBold(size: 16), letterSpacing: -0.16)
        timeSwitch.transform = CGAffineTransform(scaleX: 0.83, y: 0.83)
        startTimeSubLabel.setLabel(text: "시작", color: .gray4, font: .appleRegular(size: 14), letterSpacing: -0.14)
        endTimeSubLabel.setLabel(text: "종료", color: .gray4, font: .appleRegular(size: 14), letterSpacing: -0.14)
        startTimeLabel.setLabel(text: "오전 10:00", color: .gray4, font: .appleRegular(size: 14), letterSpacing: -0.14)
        endTimeLabel.setLabel(text: "오전 11:00", color: .gray4, font: .appleRegular(size: 14), letterSpacing: -0.14)
    }
    
    func setCategoryData() {
        if let categoryVM = categoryViewModel {
            categoryTitle.setLabel(text: categoryVM.title, color: .black, font: .appleMedium(size: 16), letterSpacing: -0.16)
            categoryColor.image = UIImage(named: categoryVM.categoryColorImageName)
            categoryColor.isHidden = false
        } else {
            categoryTitle.setLabel(text: "카테고리를 생성해주세요", color: .gray3, font: .appleMedium(size: 16), letterSpacing: -0.16)
            categoryColor.isHidden = true
        }
    }
    
    func setCollectionView() {
        weekCollectionView.dataSource = self
        weekCollectionView.delegate = self
    }
    
    func fetchListData() {
        switch entryNumber {
        // 루틴 설정 뷰에서 넘어올 때
        case 1:
            // layout
            headerLabel.setLabel(text: "할 일 수정하기", color: .black, font: .appleMedium(size: 18))
            topConstraint.constant = 330/896*self.view.bounds.height
            weekCollectionViewTopConstraint.constant = 24
            routineTitle.isEnabled = false
            routineTitleTopConstraint.constant = 32
            
            categoryTopConstraint.isActive = false
            daysHeaderLabelTopConstraint.isActive = false
            categoryUIView.isHidden = true
            daysHeaderLabel.isHidden = true
            timeSettingHeaderLabelTopConstraint.constant = 100
            switchTopConstraint.constant = 96
            
            // data
            todo = Todo(categoryID: nil, date: nil, endTime: taskListData?.days?.first?.endTime, name: taskListData!.name, startTime: taskListData?.days?.first?.startTime)
            
            daysStructList = taskListData?.days
            
            if let daysStructList = daysStructList { // 요일, 시간 설정을 해놨을 때
                dayDict = editRouineViewModel.renderDaysStructListIntoDictionary(daysStructList: daysStructList)
            } else { // 안해놓았을 때
                dayDict = ["월":0, "화":0, "수":0, "목":0, "금":0, "토":0, "일":0]
            }
        case 2: // 할일 선택 에서 들어오는 경우,요일 입력란 O 카테고리 O 시간설정 O
            headerLabel.setLabel(text: "할 일 추가하기", color: .black, font: .appleMedium(size: 18))
            topConstraint.constant = 40/896*self.view.bounds.height
            routineTitleTopConstraint.constant = 48
        case 3: //  main Home 에서 들어오는 경우, date 입력받아야함, 요일 입력란 X 카테고리 O 시간설정 O
            // layout
            headerLabel.setLabel(text: "할 일 추가하기", color: .black, font: .appleMedium(size: 18))
            topConstraint.constant = 40/896*self.view.bounds.height
            routineTitleTopConstraint.constant = 48
            daysHeaderLabel.isHidden = true
            daysHeaderLabelTopConstraint.isActive = false
            weekCollectionView.isHidden = true
            weekCollectionViewTopConstraint.isActive = false
            switchTopConstraint.constant = 99
            timeSettingHeaderLabelTopConstraint.constant = 103
        case 4:
            // layout
            headerLabel.setLabel(text: "할 일 수정하기", color: .black, font: .appleMedium(size: 18))
            topConstraint.constant = 330/896*self.view.bounds.height
            weekCollectionViewTopConstraint.constant = 24
            routineTitle.isEnabled = false
            routineTitleTopConstraint.constant = 32
            
            categoryTopConstraint.isActive = false
            daysHeaderLabelTopConstraint.isActive = false
            categoryUIView.isHidden = true
            daysHeaderLabel.isHidden = true
            timeSettingHeaderLabelTopConstraint.constant = 100
            switchTopConstraint.constant = 96
            
            // data
            todo = Todo(categoryID: todoData?.id, date: nil, endTime: todoData?.endTime, name: todoData!.name, startTime: todoData?.startTime)
            // 여기에서는 categoryID = todo.id
            
            if let dayNameList = todoData?.days {// 요일, 시간 설정을 해놨을 때
                // 초기화 필요
                editRouineViewModel = EditRoutineViewModel(Todo(categoryID: nil, date: nil, endTime: nil, name: "", startTime: nil), days: ["월":0, "화":0, "수":0, "목":0, "금":0, "토":0, "일":0])
                dayDict = editRouineViewModel.renderDaysListIntoDictionary(dayNameList: dayNameList)
            } else { // 안해놓았을 때
                dayDict = ["월":0, "화":0, "수":0, "목":0, "금":0, "토":0, "일":0]
            }
            
        default:
            return
        }
        if let todo = todo,
           let dayDict = dayDict { // 원래는 이렇게 전 뷰에서 todo 구조체 데이터를 받아서 뿌려줌
            editRouineViewModel = EditRoutineViewModel(todo, days: dayDict)
            routineTitle.text = editRouineViewModel.title
        } else { // 할일 추가의 경우 
            editRouineViewModel = EditRoutineViewModel(Todo(categoryID: nil, date: nil, endTime: nil, name: "", startTime: nil), days: ["월":0, "화":0, "수":0, "목":0, "금":0, "토":0, "일":0])
        }
        
        // 해당 데이터가 time 있는 루틴이면 뷰 띄워지자마자 switch on 처리, 아니라면 off
        if editRouineViewModel.hasTimeSetting {
            timeSwitch.setOn(true, animated: true)
            showTimeLabel()
            setTimeLabel()
        } else {
            timeSwitch.setOn(false, animated: true)
            hideTimeLabel()
        }
    }
    // set time data to the labels
    func setTimeLabel() {
        startTimeLabel.text = "\(editRouineViewModel.startTimeMeridiem) \(editRouineViewModel.startTimeHour):\(editRouineViewModel.startTimeMin)"
        endTimeLabel.text = "\(editRouineViewModel.endTimeMeridiem) \(editRouineViewModel.endTimeHour):\(editRouineViewModel.endTimeMin)"
    }
    
    func hideTimeLabel() {
        endTimeLabel.isHidden = true
        startTimeLabel.isHidden = true
        endTimeSubLabel.isHidden = true
        startTimeSubLabel.isHidden = true
    }
    
    func showTimeLabel() {
        endTimeLabel.isHidden = false
        startTimeLabel.isHidden = false
        endTimeSubLabel.isHidden = false
        startTimeSubLabel.isHidden = false
    }
}

// MARK: - CollectionView

extension EditRoutineVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCollectionViewCell.identifier, for: indexPath) as? WeekCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(with: editRouineViewModel.days, index: indexPath.row, cellWidth: 41/375*view.bounds.width)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let curKey = days[indexPath.row]
        if editRouineViewModel.days[curKey] == 0 {
            editRouineViewModel.updateDays(day: curKey, isChecked: 1)
        } else {
            editRouineViewModel.updateDays(day: curKey, isChecked: 0)
        }
        if editRouineViewModel.daySelected {
            completeButton.isEnabled = true
        } else {
            completeButton.isEnabled = false
        }
        weekCollectionView.reloadData()
    }
}

extension EditRoutineVC: UICollectionViewDelegate {
    
}

// MARK: UITextFieldDelegate

extension EditRoutineVC: UITextFieldDelegate {
    
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
