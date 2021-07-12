//
//  EditRoutineTimeVC.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/04/30.
//

import UIKit

class EditRoutineTimeVC: UIViewController {
    
    // MARK: - Variables
    
    // sends modified start, end time data from EdiRoutineTimeVC to EditRouineVC
    var saveTimeDelegate: SaveTimeProtocol?
    // View Model
    var editRoutineViewModel : EditRoutineViewModel!
    // Variables for Time Picker
    var hours: [String] = []
    var minutes: [String] = []
    var meridiem: [String] = ["오전", "오후"]
    var startTimeEditing: Bool = false
    
    // MARK: - IBOutlet
    
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
    
    // MARK: - IBAction
    
    // 취소 button
    @IBAction func cancleButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // 확인 button
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        self.saveTimeDelegate?.saveTimeProtocol(savedTimeData: editRoutineViewModel.todo)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        connectTimePicker() // timepicker delegate, data source
        presetTimeData() // preset time data using view model (receives time data from previous view)
        setDatePickerRowData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        editUIView.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
    }
}

// MARK: - Extension for Functions

extension EditRoutineTimeVC {
    func connectTimePicker() {
        timePicker.delegate = self
        timePicker.dataSource = self
    }
    func setLayout() {
        // Layout
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        editUIView.backgroundColor = .white
        topConstraint.constant = 454/896*self.view.bounds.height
        // left side time section
        startTimeHeaderLabel.setLabel(text: "시작", color: .gray5, font: .appleMedium(size: 14))
        endTimeHeaderLabel.setLabel(text: "종료", color: .gray5, font: .appleMedium(size: 14))
        startTimeHourLabel.setLabel(text: "5", color: .black, font: .metroBold(size: 20))
        startTimeMinuteLabel.setLabel(text: "00", color: .black, font: .metroBold(size: 20))
        startTimeMiddleLabel.setLabel(text: ":", color: .black, font: .metroBold(size: 20))
        startTimeMeridiemLabel.setLabel(text: "오후", color: .black, font: .appleBold(size: 20))
        // adds tap gesture to left side time section
        let startTimeEditingTapGesture = UITapGestureRecognizer(target: self, action: #selector(startEditingTap))
        startTimeHuggingView.addGestureRecognizer(startTimeEditingTapGesture)
        // right side time section
        endTimeMeridiemLabel.setLabel(text: "오후", color: .black, font: .appleBold(size: 20))
        endTimeHourLabel.setLabel(text: "6", color: .black, font: .metroBold(size: 20))
        endTimeMiddleLabel.setLabel(text: ":", color: .black, font: .metroBold(size: 20))
        endTimeMinuteLabel.setLabel(text: "00", color: .black, font: .metroBold(size: 20))
        // adds tap gesture to right side time section
        let endTimeEditingTapGesture = UITapGestureRecognizer(target: self, action: #selector(startEditingTap))
        endTimeHuggingView.addGestureRecognizer(endTimeEditingTapGesture)
        // trigger left section tap gesture
        endTimeEditingTapGesture.state = .ended
        //buttons
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.titleLabel?.font = .appleSemiBold(size: 16)
        confirmButton.tintColor = .black
        cancleButton.setTitle("취소", for: .normal)
        cancleButton.titleLabel?.font = .appleSemiBold(size: 16)
        cancleButton.tintColor = .gray4
    }
    // set DatePickerRowData - hours:1~23, minutes:0~59
    func setDatePickerRowData() {
        hours = Array(1...12).compactMap {
            if $0 < 10 {
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
    // preselect start time, end time - gets time data from previous view using vm
    func presetTimeData() {
        startTimeMeridiemLabel.setLabel(text: editRoutineViewModel.startTimeMeridiem, color: .black, font: .appleBold(size: 20))
        startTimeHourLabel.setLabel(text: editRoutineViewModel.startTimeHour, color: .black, font: .metroBold(size: 20))
        startTimeMinuteLabel.setLabel(text: editRoutineViewModel.startTimeMin, color: .black, font: .metroBold(size: 20))
        startTimeMiddleLabel.setLabel(text: ":", color: .black, font: .metroBold(size: 20))
        endTimeMeridiemLabel.setLabel(text: editRoutineViewModel.endTimeMeridiem, color: .black, font: .appleBold(size: 20))
        endTimeHourLabel.setLabel(text: editRoutineViewModel.endTimeHour, color: .black, font: .metroBold(size: 20))
        endTimeMiddleLabel.setLabel(text: ":", color: .black, font: .metroBold(size: 20))
        endTimeMinuteLabel.setLabel(text: editRoutineViewModel.endTimeMin, color: .black, font: .metroBold(size: 20))
    }
    
    // changes label color at each state : disabled state & enabled state
    
    // disabled state for start time section
    func disableStartTimeView() {
        startTimeMeridiemLabel.textColor = .gray2
        startTimeHeaderLabel.textColor = .gray2
        startTimeMiddleLabel.textColor = .gray2
        startTimeMinuteLabel.textColor = .gray2
        startTimeHourLabel.textColor = .gray2
    }
    // enabled state for start tiem view
    func enableStartTimeView() {
        startTimeMeridiemLabel.textColor = .black
        startTimeHeaderLabel.textColor = .black
        startTimeMiddleLabel.textColor = .black
        startTimeMinuteLabel.textColor = .black
        startTimeHourLabel.textColor = .black
    }
    // disabled state for end tiem view
    func disableEndTimeView() {
        endTimeMeridiemLabel.textColor = .gray2
        endTimeHeaderLabel.textColor = .gray2
        endTimeMiddleLabel.textColor = .gray2
        endTimeMinuteLabel.textColor = .gray2
        endTimeHourLabel.textColor = .gray2
    }
    // enabled state for end tiem view
    func enableEndTimeView() {
        endTimeMeridiemLabel.textColor = .black
        endTimeHeaderLabel.textColor = .black
        endTimeMiddleLabel.textColor = .black
        endTimeMinuteLabel.textColor = .black
        endTimeHourLabel.textColor = .black
    }
    
    // MARK: - Method
    
    @objc func startEditingTap(sender: UITapGestureRecognizer) {
        // startTimeEditing Boolean 값으로 분기 처리
        if startTimeEditing { // start time 을 수정하고 있었다면,
            enableEndTimeView()
            disableStartTimeView()
            startTimeEditing = false // ends editing start time
            // set time picker data as end time data
            timePicker.selectRow(editRoutineViewModel.endHourRow, inComponent: 0, animated: true)
            timePicker.selectRow(editRoutineViewModel.endMinRow, inComponent: 1, animated: true)
            timePicker.selectRow(editRoutineViewModel.endTimeMerRow, inComponent: 2, animated: true)
        } else { // end time 을 수정하고 있었다면,
            disableEndTimeView()
            enableStartTimeView()
            startTimeEditing = true // starts editing start time
            // set time picker data as start time data
            timePicker.selectRow(editRoutineViewModel.startHourRow, inComponent: 0, animated: true)
            timePicker.selectRow(editRoutineViewModel.startMinRow, inComponent: 1, animated: true)
            timePicker.selectRow(editRoutineViewModel.startTimeMerRow, inComponent: 2, animated: true)
        }
    }
}

// MARK: - UIPickerViewDelegate

extension EditRoutineTimeVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: // hour
            return hours[row]
        case 1: // minutes
            return minutes[row]
        case 2: // AM, PM
            return meridiem[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var hourLabel, minLabel, meridiemLabel: UILabel
        var hour, min, mer: String
        // startTimeEditing == true(user is editing start time) : picker view should show start time data
        // startTimeEditing == false(user is NOT editing start time, is editing end time!) : picker view should show end time data
        switch startTimeEditing {
        case true: // edit start time relevant labels
            hourLabel = startTimeHourLabel
            minLabel = startTimeMinuteLabel
            meridiemLabel = startTimeMeridiemLabel
            hour = editRoutineViewModel.startTimeHour
            min = editRoutineViewModel.startTimeMin
            mer = editRoutineViewModel.startTimeMeridiem
        case false: // edit end time relevant labels
            hourLabel = endTimeHourLabel
            minLabel = endTimeMinuteLabel
            meridiemLabel = endTimeMeridiemLabel
            hour = editRoutineViewModel.endTimeHour
            min = editRoutineViewModel.endTimeMin
            mer = editRoutineViewModel.endTimeMeridiem
        }
        switch component {
        case 0: // 시간
            hourLabel.text = hours[row]
            hour = hours[row] // saves hour data
            break
        case 1: // 분
            minLabel.text = minutes[row]
            min = minutes[row] // saves hour data
            break
        case 2: // AM, PM
            meridiemLabel.text = meridiem[row]
            mer = meridiem[row] // saves hour data
            break
        default:
            break
        }
        switch startTimeEditing {
        case true:
            // update START time vm with newly saved time data
            editRoutineViewModel.updateStartTime(startTime: editRoutineViewModel.mergePickerIntoTime(mer: mer, hour: hour, min: min))
        case false:
            // update END time vm with newly saved time data
            editRoutineViewModel.updateEndTime(endTime: editRoutineViewModel.mergePickerIntoTime(mer: mer, hour: hour, min: min))
        }
    }
}

extension EditRoutineTimeVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: // hours
            return hours.count
        case 1: // minutes
            return minutes.count
        case 2: // AM, PM
            return meridiem.count
        default:
            return 0
        }
    }
}
