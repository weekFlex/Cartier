//
//  MainHomeModel.swift
//  WeekFlex
//
//  Created by dohan on 2021/03/10.
//

import Foundation

struct TodoStruct {
    var todoTitle: String
    var category: Int
    var startTime: String?
    var endTime: String?
    
    init(todoTitle: String, category: Int){
        self.todoTitle = todoTitle
        self.category = category
    }
    init(todoTitle: String, category: Int, startTime: String, endTime: String){
        self.todoTitle = todoTitle
        self.category = category
        self.startTime = startTime
        self.endTime = endTime
    }
    
}

struct RoutineStruct {
    var routineName: String
    var todos: [TodoStruct]
    
    init(routineName:String, todos:[TodoStruct]){
        self.routineName = routineName
        self.todos = todos
    }
    
}
