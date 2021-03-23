//
//  MainHomeVM.swift
//  WeekFlex
//
//  Created by dohan on 2021/03/07.
//

import Foundation

class MainHomeVM {
    
    let data1: RoutineStruct = RoutineStruct(routineName: "영어마스터", todos:[
        TodoStruct(todoTitle: "영어원서 읽기", category: 1, startTime: "9:00", endTime: "10:00" ),
        TodoStruct(todoTitle: "영드보기", category: 3, startTime: "10:20", endTime: "11:00" ),
        TodoStruct(todoTitle: "단어외우기", category: 8 , startTime: "10:20", endTime: "11:00" )
    ])
    
    let data2: RoutineStruct = RoutineStruct(routineName: "시험공부", todos:[
        TodoStruct(todoTitle: "전공1", category: 1 , startTime: "9:00", endTime: "10:00" ),
        TodoStruct(todoTitle: "교양",  category: 3, startTime: "10:20", endTime: "11:00" )
    ] )
    
    lazy var data:[RoutineStruct] = [data1, data2]
    
    
}
