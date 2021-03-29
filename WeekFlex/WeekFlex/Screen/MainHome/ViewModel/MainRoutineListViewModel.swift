//
//  MainRoutineListVM.swift
//  WeekFlex
//
//  Created by dohan on 2021/03/28.
//

import Foundation


//task 구조체
protocol TaskItemPresentable {
    var taskTitle: String { get }
    var category: String { get }
    var startTime: String? { get }
    var endTime: String? { get }
    var done: Bool? { get }
}

struct TaskItemViewModel: TaskItemPresentable {
    var taskTitle: String
    var category: String
    var startTime: String?
    var endTime: String?
    var done: Bool?
}


//routine 구조체
protocol MainRoutineItemPresentable {
    var routineName: String { get }
    var tasks: [TaskItemViewModel] { get }
}

struct MainRoutineItemViewModel: MainRoutineItemPresentable {
    var routineName: String
    var tasks: [TaskItemViewModel]
}


//list 구조체


struct MainRoutineListViewModel {
    var lists: [MainRoutineItemViewModel] = []
    
    init() {
        let routine1 = MainRoutineItemViewModel(routineName: "영어마스터", tasks:[
            TaskItemViewModel(taskTitle: "영어원서 읽기", category: "icon12StarN1", startTime: "9:00", endTime: "10:00" ),
            TaskItemViewModel(taskTitle: "영드보기", category: "icon12StarN3", startTime: "10:20", endTime: "11:00" ),
            TaskItemViewModel(taskTitle: "단어외우기", category: "icon12StarN3" , startTime: "10:20", endTime: "11:00" )
        ])
        
        let routine2 = MainRoutineItemViewModel(routineName: "시험공부", tasks:[
            TaskItemViewModel(taskTitle: "전공1", category: "icon12StarN3", startTime: "9:00", endTime: "10:00" ),
            TaskItemViewModel(taskTitle: "교양", category: "icon12StarN8", startTime: "10:20", endTime: "11:00" )
        ])
        
        lists.append(contentsOf: [routine1, routine2])
    }
}
