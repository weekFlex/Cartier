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
    var time: String? { get }
    var done: Bool? { get }
}

struct TaskItemViewModel: TaskItemPresentable {
    var taskTitle: String
    var category: String
    var time: String?
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
            TaskItemViewModel(taskTitle: "영어원서 읽기", category: "icon24StarN1", time: "9:00am - 10:00am" ),
            TaskItemViewModel(taskTitle: "영드보기", category: "icon24StarN3", time: "10:20am - 11:00am" ),
            TaskItemViewModel(taskTitle: "단어외우기", category: "icon24StarN3" , time: "10:00am - 11:00am")
        ])
        
        let routine2 = MainRoutineItemViewModel(routineName: "시험공부", tasks:[
            TaskItemViewModel(taskTitle: "전공1", category: "icon24StarN3", time: "2:00pm - 3:00pm" ),
            TaskItemViewModel(taskTitle: "교양", category: "icon24StarN8", time: nil )
        ])
        
        lists.append(contentsOf: [routine1, routine2])
    }
}
