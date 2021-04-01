//
//  MainHomeViewModel.swift
//  WeekFlex
//
//  Created by dohan on 2021/03/31.
//

import Foundation

protocol CalendarItemPresentable {
    var date: String { get }
    var day: Int { get }
    var representCategory: String? { get }
    var routines: [MainRoutineItemViewModel] { get }
}

struct CalendarItemViewModel: CalendarItemPresentable {
    var date: String
    var day: Int
    var representCategory: String?
    var routines: [MainRoutineItemViewModel]
}

struct MainHomeViewModel {
    var lists: [CalendarItemViewModel] = []
    init(){
        let routineList = MainRoutineListViewModel()
        let day1 = CalendarItemViewModel(date: "Mar-29-Monday", day: 2, representCategory: "icon12StarN1", routines: routineList.lists)
        let day2 = CalendarItemViewModel(date: "Mar-30-Tuesday", day: 3, representCategory: "icon12StarN3", routines: routineList.lists)
        let day3 = CalendarItemViewModel(date: "Mar-31-Wednesday", day: 4, representCategory: "icon12StarN8", routines: routineList.lists)
        let day4 = CalendarItemViewModel(date: "Apr-01-Thursday", day: 5, representCategory: nil, routines: routineList.lists)
        let day5 = CalendarItemViewModel(date: "Apr-02-Friday", day: 6, representCategory: nil, routines: routineList.lists)
        let day6 = CalendarItemViewModel(date: "Apr-03-Saturday", day: 7, representCategory: nil, routines: routineList.lists)
        let day7 = CalendarItemViewModel(date: "Apr-04-Sunday", day: 1, representCategory: nil, routines: routineList.lists)
        
        lists.append(contentsOf: [day1,day2,day3,day4,day5,day6,day7])
    }
}




