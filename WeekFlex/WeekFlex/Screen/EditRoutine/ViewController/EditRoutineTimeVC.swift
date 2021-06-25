//
//  EditRoutineTimeVC.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/04/30.
//

import UIKit

class EditRoutineTimeVC: UIViewController {

    // 이전 뷰에서 시작, 끝 시간이 있었다면 이 데이터로 시작 끝 시간 세팅
    var startTime: String?
    var endTime: String?
    
    var hours: [String] = []
    var minutes: [String] = []
    var meridiem: [String] = ["오전", "오후"]
    var startTimeEditing: Bool = true
    
    @IBOutlet var editUIView: UIView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var startTimeHeaderLabel: UILabel!
    @IBOutlet var startTimeMeridiemLabel: UILabel!
    @IBOutlet var startTimeHourLabel: UILabel!
    @IBOutlet var startTimeMiddleLabel: UILabel!
    @IBOutlet var startTimeMinuteLabel: UILabel!

    @IBOutlet var endTimeHeaderLabel: UILabel!
    @IBOutlet var endTimeHourLabel: UILabel!
    @IBOutlet var endTimeMiddleLabel: UILabel!
    @IBOutlet var endTimeMinuteLabel: UILabel!
    @IBOutlet var endTimeMeridiemLabel: UILabel!
    @IBOutlet var timePicker: UIPickerView!
    @IBOutlet var cancleButton: UIButton!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var startTimeHuggingView: UIView!
    @IBOutlet var endTimeHuggingView: UIView!
    
    @IBAction func cancleButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("arrived")
        setLayout()
        presetTimeData() // 전 뷰에서 시간이 넘어온 경우에 시간을 입력해준다
        setDatePickerData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        editUIView.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
    }
    
}

extension EditRoutineTimeVC {
    
    // MARK: function
    
    func setLayout() {
        let startTimeEditingTapGesture = UITapGestureRecognizer(target: self, action: #selector(startEditingTap))
        startTimeHuggingView.addGestureRecognizer(startTimeEditingTapGesture)
        let endTimeEditingTapGesture = UITapGestureRecognizer(target: self, action: #selector(startEditingTap))
        endTimeHuggingView.addGestureRecognizer(endTimeEditingTapGesture)
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        editUIView.backgroundColor = .white
        
        topConstraint.constant = 454/896*self.view.bounds.height
        
        startTimeHeaderLabel.setLabel(text: "시작", color: .gray5, font: .appleMedium(size: 14))
        endTimeHeaderLabel.setLabel(text: "종료", color: .gray5, font: .appleMedium(size: 14))
        startTimeHourLabel.setLabel(text: "5", color: .black, font: .metroBold(size: 20))
        startTimeMinuteLabel.setLabel(text: "00", color: .black, font: .metroBold(size: 20))
        startTimeMiddleLabel.setLabel(text: ":", color: .black, font: .metroBold(size: 20))
        startTimeMeridiemLabel.setLabel(text: "오후", color: .black, font: .appleBold(size: 20))
        
        
        endTimeMeridiemLabel.setLabel(text: "오후", color: .black, font: .appleBold(size: 20))
        endTimeHourLabel.setLabel(text: "6", color: .black, font: .metroBold(size: 20))
        endTimeMiddleLabel.setLabel(text: ":", color: .black, font: .metroBold(size: 20))
        endTimeMinuteLabel.setLabel(text: "00", color: .black, font: .metroBold(size: 20))
        
        timePicker.delegate = self
        timePicker.dataSource = self
        
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.titleLabel?.font = .appleSemiBold(size: 16)
        confirmButton.tintColor = .black
        
        cancleButton.setTitle("취소", for: .normal)
        cancleButton.titleLabel?.font = .appleSemiBold(size: 16)
        cancleButton.tintColor = .gray4
        
    }
    
    // set DatePickerData
    
    func setDatePickerData() {
        
        hours = Array(1...12).compactMap {
            if $0 < 10 { // 한자리수는 앞에 0을 붙여줌 (1시->01시)
                return "0\($0)"
            }
            else {
                return "\($0)"
            }
        }
        
        for i in 0...60 {
            if (i < 10) {
                minutes.append("0\(String(i))")
            } else {
                minutes.append(String(i))
            }
        }
        
    }
    
    // 시작 시간 preselect
    func presetTimeData() {
        if let startTime = startTime,
           let endTime = endTime {
            startTimeHourLabel.setLabel(text: String(startTime.split(separator: ":")[0]), color: .black, font: .metroBold(size: 20))
            startTimeMinuteLabel.setLabel(text: String(startTime.split(separator: ":")[1]), color: .black, font: .metroBold(size: 20))
            startTimeMiddleLabel.setLabel(text: ":", color: .black, font: .metroBold(size: 20))
            endTimeHourLabel.setLabel(text: String(endTime.split(separator: ":")[0]), color: .black, font: .metroBold(size: 20))
            endTimeMiddleLabel.setLabel(text: ":", color: .black, font: .metroBold(size: 20))
            endTimeMinuteLabel.setLabel(text: String(endTime.split(separator: ":")[1]), color: .black, font: .metroBold(size: 20))
        } else {
            
        }
//        timePicker.selectRow(0, inComponent: 0, animated: true)
//        timePicker.selectRow(0, inComponent: 1, animated: true)
//        timePicker.selectRow(0, inComponent: 2, animated: true)
    }
    
    func disableStartTimeView() {
        startTimeMeridiemLabel.textColor = .gray2
        startTimeHeaderLabel.textColor = .gray2
        startTimeMiddleLabel.textColor = .gray2
        startTimeMinuteLabel.textColor = .gray2
        startTimeHourLabel.textColor = .gray2
    }
    
    func enableStartTimeView() {
        startTimeMeridiemLabel.textColor = .black
        startTimeHeaderLabel.textColor = .black
        startTimeMiddleLabel.textColor = .black
        startTimeMinuteLabel.textColor = .black
        startTimeHourLabel.textColor = .black
    }
    
    func disableEndTimeView() {
        endTimeMeridiemLabel.textColor = .gray2
        endTimeHeaderLabel.textColor = .gray2
        endTimeMiddleLabel.textColor = .gray2
        endTimeMinuteLabel.textColor = .gray2
        endTimeHourLabel.textColor = .gray2
    }
    
    func enableEndTimeView() {
        endTimeMeridiemLabel.textColor = .black
        endTimeHeaderLabel.textColor = .black
        endTimeMiddleLabel.textColor = .black
        endTimeMinuteLabel.textColor = .black
        endTimeHourLabel.textColor = .black
    }
    
    // MARK: Method
    
    @objc func startEditingTap(sender: UITapGestureRecognizer) {
        
        if startTimeEditing {
            print("disable start time")
            enableEndTimeView()
            disableStartTimeView()
            startTimeEditing = false
            
        } else {
            print("disable end time")
            disableEndTimeView()
            enableStartTimeView()
            startTimeEditing = true
        }
    }
}

extension EditRoutineTimeVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0: // 시간
            return hours[row]
        case 1: // 분
            return minutes[row]
        case 2: // AM, PM
            return meridiem[row]
        default:
            return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0: // 시간
            startTimeHourLabel.text = hours[row]
            break
        case 1: // 분
            startTimeMinuteLabel.text = minutes[row]

            break
        case 2: // AM, PM
            startTimeMeridiemLabel.text = meridiem[row]
            break
        default:
            break
        }
    }
}

extension EditRoutineTimeVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        // 각자 갯수만큼 Componet를 표시한다
        switch component {
        case 0: // 요일
            return hours.count
        case 1: // 시간
            return minutes.count
        case 2: // 분
            return meridiem.count
        default:
            return 0
        }
        
    }
    
}
