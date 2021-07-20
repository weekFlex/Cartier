//
//  EditRoutineVC.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/04/23.
//

import UIKit

class EditRoutineVC: UIViewController {
    
    // MARK: - Variables
    
    private var listName: String?
    private let days = ["월", "화", "수", "목", "금", "토", "일"]
    var saveTaskListDataDelegate: SaveTaskListProtocol?
    var hideViewDelegate: HideViewProtocol?
    var todo: Todo?
    var taskListData: TaskListData?
    var daysStructList: [Day]?
    var entryNumber: Int?
    var dayDict: [String:Int]?
    
    // View Model
    private var editRouineViewModel : EditRoutineViewModel!
    
    // MARK: - IBOutlet
    
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var editUIView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var completeButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var routineTitleLabel: UILabel!
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
            hideTimeLabel()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.hideViewDelegate?.hideViewProtocol()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeButtonPressed(_ sender: Any) {
        let dict = editRouineViewModel.days
        
        // Days 구조체로 넣어주기
        let newData = dict.reduce(into: [Day]()) { dayStruct, dayDict in
            if dayDict.value == 1 {
                dayStruct.append(Day(endTime: editRouineViewModel.todo.endTime ?? "", name: dayDict.key, startTime: editRouineViewModel.todo.startTime ?? ""))
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
}

// MARK: - Extension for Protocol

extension EditRoutineVC: SaveTimeProtocol, HideViewProtocol {
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
    
    // MARK: - function
    
    func setLayout() {
        // background
        topLayerUIView.backgroundColor = UIColor(white: 0, alpha: 0.0)
        view.backgroundColor = UIColor(white: 0, alpha: 0.0)
        topLayerUIView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped)))
        editUIView.backgroundColor = .white
        topConstraint.constant = 330/896*self.view.bounds.height
        // header
        backButton.setImage(UIImage(named: "icon32CancleBlack"), for: .normal)
        completeButton.setImage(UIImage(named: "icon32CheckBlack"), for: .normal)
        completeButton.isEnabled = false
        headerLabel.setLabel(text: "할 일 수정하기", color: .black, font: .appleMedium(size: 18))
        // set routine name
        listName = editRouineViewModel.title
        routineTitleLabel.setLabel(text: listName ?? "", color: .black, font: .appleBold(size: 22))
        // collection view
        collectionviewHeight.constant = 41/375*view.bounds.width
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 41/375*view.bounds.width, height: 41/375*view.bounds.width)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 2
        weekCollectionView.collectionViewLayout = layout
        // time section
        timeHeaderLabel.setLabel(text: "시간 설정", color: .black, font: .appleBold(size: 16))
        timeSwitch.transform = CGAffineTransform(scaleX: 0.83, y: 0.83)
        startTimeSubLabel.setLabel(text: "시작", color: .gray4, font: .appleRegular(size: 14))
        endTimeSubLabel.setLabel(text: "종료", color: .gray4, font: .appleRegular(size: 14))
        startTimeLabel.setLabel(text: "오전 10:00", color: .gray4, font: .appleRegular(size: 14))
        endTimeLabel.setLabel(text: "오전 11:00", color: .gray4, font: .appleRegular(size: 14))
    }
    
    func setCollectionView() {
        weekCollectionView.dataSource = self
        weekCollectionView.delegate = self
    }
    
    func fetchListData() {
        switch entryNumber {
        // 루틴 설정 뷰에서 넘어올 때
        case 1:
            
            todo = Todo(categoryID: nil, date: nil, endTime: taskListData?.days?.first?.endTime, name: taskListData!.name, startTime: taskListData?.days?.first?.startTime)
            
            daysStructList = taskListData?.days
            
            if let daysStructList = daysStructList { // 요일, 시간 설정을 해놨을 때
                dayDict = editRouineViewModel.renderDaysStructListIntoDictionary(daysStructList: daysStructList)
            } else { // 안해놓았을 때
                dayDict = ["월":0, "화":0, "수":0, "목":0, "금":0, "토":0, "일":0]
            }
            
            
        default:
            return
        }
        if let todo = todo,
           let dayDict = dayDict { // 원래는 이렇게 전 뷰에서 todo 구조체 데이터를 받아서 뿌려줌
            editRouineViewModel = EditRoutineViewModel(todo, days: dayDict)
        } else { // 일단 지금은 더미 데이터 입력
            editRouineViewModel = EditRoutineViewModel(Todo(categoryID: 1, date: "2021-04-12", endTime: nil, name: "정원이 형하고 앞구르기 하기", startTime: nil), days: ["월":1, "화":1, "수":1, "목":0, "금":0, "토":0, "일":0])
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
