//
//  EditRoutineVM.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/04/23.
//

import Foundation

struct EditRoutineViewModel {
    var todo: Todo
    var daySelected: Bool = false
    var days: [String:Int] {
        didSet {
            if days.map({$0.value}).contains(1) {
                daySelected = true
            } else {
                daySelected = false
            }
        }
    }
}

extension EditRoutineViewModel {
    init(_ todo: Todo, days: [String:Int]) {
        self.todo = todo
        self.days = days
    }
}

extension EditRoutineViewModel {
    var title: String {
        return self.todo.name
    }
    
    var hasTimeSetting: Bool {
        if let _ = self.todo.endTime,
           let _ = self.todo.startTime {
            return true
        } else {
            return false
        }
    }
    
    var startTimeHour: String {
        let hour = Int(self.todo.startTime!.split(separator: ":")[0])!
        switch hour {
        case 0, 12:
            return "12"
        default:
            return String(hour%12)
        }
    }

    var startTimeMin: String {
        return String(self.todo.startTime!.split(separator: ":")[1])
    }
    
    var startTimeMeridiem: String {
        //0시~11시 AM
        //12시~23시 PM
        if Int(self.todo.startTime!.split(separator: ":")[0])! < 12 {
            return "오전"
        } else {
            return "오후"
        }
    }
    
    var endTimeHour: String {
        let hour = Int(self.todo.endTime!.split(separator: ":")[0])!
        switch hour {
        case 0, 12:
            return "12"
        default:
            return String(hour%12)
        }
    }
    
    var endTimeMin: String {
        return String(self.todo.endTime!.split(separator: ":")[1])
    }
    
    var endTimeMeridiem: String {
        if Int(self.todo.endTime!.split(separator: ":")[0])! < 12 {
            return "오전"
        } else {
            return "오후"
        }
    }
    
    mutating func updateDays(day: String, isChecked: Int) {
        days[day] = isChecked
    }
    
    mutating func updateStartTime(startTime: String) {
        self.todo.startTime = startTime
    }
    
    mutating func updateEndTime(endTime: String) {
        self.todo.endTime = endTime
    }
    
    mutating func updateName(name: String) {
        self.todo.name = name
    }
    
    mutating func updateCategory(ID: Int) {
        self.todo.categoryID = ID
    }
    
    // picker에서 나온 시간, AM/PM, 분이 계산되어 합쳐진 startTime(17:00)
    // 오전 12 00 , 오후 12 00 으로 picker 로 값이 들어오면 다른 시간과는 다르게 +12를 한 후 처리해줘야함.
    func mergePickerIntoTime(mer: String, hour: String, min: String) -> String {
        var hourInt: Int
        switch mer {
        case "오전":
            hourInt = Int(hour)!
            if hourInt == 12 { return "00:\(min)" } //오전 12+0 = 00:00
        case "오후":
            hourInt = Int(hour)!+12
            if hourInt == 24 { return "12:\(min)" } //오후 12+12 = 12:00
        default:
            return ""
        }
        return "\(String(hourInt)):\(min)"
    }
    
    func compareStartEndTime(startTimeAsString: String, endTimeAsString: String) -> Bool {
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:mm:"
        let startTime = timeFormat.date(from: startTimeAsString)
        let endTime = timeFormat.date(from: endTimeAsString)
        if startTime! <= endTime! {
            return true
        } else {
            return false
        }
    }
    
    func addOneHour(timeAsString: String) -> String {
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:mm:"
        let oneHourAddedTime = timeFormat.date(from: timeAsString)!.addingTimeInterval(60*60)
        return timeFormat.string(from: oneHourAddedTime)
    }
}

// picker view 관련 메소드
extension EditRoutineViewModel {
    
    var startHourRow: Int {
        let hour = Int(self.todo.startTime!.split(separator: ":")[0])!
        switch hour {
        case 0: // 00:00 은 12
            return 11
        case 12: // 12:00 은 12
            return 11
        default: // 나머지는 %12 - 1 처리 해주면 됨
            return hour%12-1
        }
    }
    
    var startMinRow: Int {
        let min = Int(self.todo.startTime!.split(separator: ":")[1])!
        return min
    }
    
    var endHourRow: Int {
        let hour = Int(self.todo.endTime!.split(separator: ":")[0])!
        switch hour {
        case 0, 12:
            return 11
        default:
            return hour%12-1
        }
    }
    
    var endMinRow: Int {
        let min = Int(self.todo.endTime!.split(separator: ":")[1])!
        return min
    }
    
    // Meridiem : < 12 면 오전 == 0 , else 면 오후 == 1
    var startTimeMerRow: Int {
        if Int(self.todo.startTime!.split(separator: ":")[0])! < 12 {
            return 0
        } else {
            return 1
        }
    }
    
    var endTimeMerRow: Int {
        if Int(self.todo.endTime!.split(separator: ":")[0])! < 12 {
            return 0
        } else {
            return 1
        }
    }
}

extension EditRoutineViewModel {
    func renderDaysStructListIntoDictionary(daysStructList: [Day]) -> [String:Int]? {
        let dayNameList = daysStructList.map({$0.name})
        let dayList = ["월", "화", "수", "목", "금", "토", "일"]
        let dayDict = dayList.reduce(into: [String:Int](), { dict, day in
            dict[day] = 0 // 모두 0으로 초기화
            for dayName in dayNameList {
                if day == dayName {
                    dict[dayName] = 1
                }
            }
        })
        return dayDict
    }
}
