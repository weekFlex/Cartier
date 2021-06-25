//
//  EditRoutineVC.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/04/23.
//

import UIKit

class EditRoutineVC: UIViewController {
    
    private let spacing:CGFloat = 8.0
    private var listName: String? // 이전 뷰에서 값 받아오기, 예: 원서읽기
    var todolistViewModel : ToDoListCollectionViewCellViewModel = ToDoListCollectionViewCellViewModel()
    private let days = ["월", "화", "수", "목", "금", "토", "일"]
    private var dayChecked = ["월":0, "화":0, "수":0, "목":0, "금":0, "토":0, "일":0] // 월 화 수 목 금 토 일 모두 0 으로 초기화
    private var timeRange: [String] = []
    private var startTime: String?
    private var startTimeMeridiem: Bool? // AM: True PM: False
    private var endTimeMeridiem: Bool? // AM: True PM: False
    private var endTime: String?

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
    
    @IBAction func timeSwitchValueChanged(_ sender: Any) {
        
        if timeSwitch.isOn {
            print("on")
            guard let editRoutineTimeVC = self.storyboard?.instantiateViewController(identifier: "EditRoutineTimeVC") as? EditRoutineTimeVC else { return }
            editRoutineTimeVC.modalTransitionStyle = .crossDissolve
            editRoutineTimeVC.modalPresentationStyle = .custom
            
            // 시간이 정해졌던게 있다면 해당 데이터로 띄우기
            if let startTime = startTime,
               let endTime = endTime {
                editRoutineTimeVC.startTime = startTime
                editRoutineTimeVC.endTime = endTime
                print("yes data")

            } else {
                print("no")
            }
            self.present(editRoutineTimeVC, animated: true, completion: .none)
        } else {
            print("off")
            hideTimeLabel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        fetchListData()
        setDelegate()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        editUIView.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
    }
    
}

extension EditRoutineVC {
    
    // MARK: function
    
    func setLayout() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        editUIView.backgroundColor = .white
        topConstraint.constant = 330/896*self.view.bounds.height
        // 헤더
        backButton.setImage(UIImage(named: "icon32CancleBlack"), for: .normal)
        completeButton.setImage(UIImage(named: "icon32CheckBlack"), for: .normal)
        headerLabel.setLabel(text: "할 일 수정하기", color: .black, font: .appleMedium(size: 18))
        // 이 부분은 선택하고 넘어오면서 받아오기
        listName = "윗몸일으키기"
        if let listName = listName {
            routineTitleLabel.setLabel(text: listName, color: .black, font: .appleBold(size: 22))
        } else{
            routineTitleLabel.setLabel(text: "", color: .black, font: .appleBold(size: 22))
        }
        
        collectionviewHeight.constant = 41/375*view.bounds.width
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 41/375*view.bounds.width, height: 41/375*view.bounds.width)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 2
        weekCollectionView.collectionViewLayout = layout
        
        timeHeaderLabel.setLabel(text: "시간 설정", color: .black, font: .appleBold(size: 16))
        timeSwitch.transform = CGAffineTransform(scaleX: 0.83, y: 0.83)
        
        startTimeSubLabel.setLabel(text: "시작", color: .gray4, font: .appleRegular(size: 14))
        endTimeSubLabel.setLabel(text: "종료", color: .gray4, font: .appleRegular(size: 14))
        startTimeLabel.setLabel(text: "오후 5:00", color: .gray4, font: .appleRegular(size: 14))
        endTimeLabel.setLabel(text: "오후 6:00", color: .gray4, font: .appleRegular(size: 14))


    }
    
    func setDelegate() {
        weekCollectionView.dataSource = self
        weekCollectionView.delegate = self
    }
    
    // 해당 할일의 데이터를 미리 저장되어있던 todolistViewModel에서 가져온다.
    // 전뷰에서 전달받은 listName을 이용하여 탐색해서 찾아낸다.
    // todolistViewModel에 저장되어있는 값 : ToDoListCellItemViewModel(category: "운동", listName: "윗몸일으키기", listTime: "월, 수 10:00am-11:00am", bookmarkCheck: true)
    func fetchListData() {
        print(todolistViewModel.items)
        for i in 0...todolistViewModel.items.count-1 {
            if todolistViewModel.items[i].listName == listName {
                listTimeDidRefine(listTime: todolistViewModel.items[i].listTime!)
            }
        }
        print(dayChecked)

    }
    
    func listTimeDidRefine(listTime: String){
        // 요일 체크
        let days = Array(dayChecked.keys)
        for i in 0...6 { // 월~일 에 대하여 체크
            print(days[i])
            let curKey = days[i]
            if listTime.contains(curKey) {
                dayChecked[curKey] = 1 // 해당 요일에 대한 숫자를 1로 변경
            }
        }
        
        // 시간 체크
        // am 또는 pm이 없으면 시간이 없는 경우임 -> 시간 체크할 필요 없음
        // am 또는 pm이 있으면 시간이 있는 경우임 -> 뒤에서부터 15까지 잘른 후, "-" 으로 split 하여 파악
        
        if listTime.contains("am") || listTime.contains("pm") {
            
            let timeStartIndex = listTime.index(listTime.endIndex, offsetBy: -15)
            let timeRange = String(listTime[timeStartIndex..<listTime.endIndex])
            
            print(timeRange) // 10:00am-11:00am 획득
            let timeDividedArray = timeRange.split(separator: "-")
            
            timeSwitch.setOn(true, animated: true)
            showTimeLabel()
            print("yes time")
            
            startTimeLabel.setLabel(text: timeConvertedInKorean(time: "start",timeInEnglish: String(timeDividedArray[0])), color: .gray4, font: .appleRegular(size: 14))
            endTimeLabel.setLabel(text: timeConvertedInKorean(time: "end",timeInEnglish: String(timeDividedArray[1])), color: .gray4, font: .appleRegular(size: 14))
            
            startTime = String(timeDividedArray[0])
            endTime = String(timeDividedArray[1])
            
        } else { // 시간 체크할 필요 없음
            timeSwitch.setOn(false, animated: true)
            hideTimeLabel()
            
            print("no time")

        }
    }
    
    func timeConvertedInKorean(time: String, timeInEnglish: String) -> String {
        if timeInEnglish.contains("am") {
            let time = timeInEnglish.split(separator: "a")[0]
            
            return "오전 \(time)"
        } else { // pm
            let time = timeInEnglish.split(separator: "p")[0]
            return "오후 \(time)"
        }
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

extension EditRoutineVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCollectionViewCell.identifier, for: indexPath) as? WeekCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(with: dayChecked, index: indexPath.row, cellWidth: 41/375*view.bounds.width)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let curKey = days[indexPath.row]
        if dayChecked[curKey] == 0 {
            dayChecked[curKey] = 1
        } else {
            dayChecked[curKey] = 0
        }
        weekCollectionView.reloadData()
    }
}


extension EditRoutineVC: UICollectionViewDelegate {
    
}
