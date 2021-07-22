//
//  RoutineData.swift
//  WeekFlex
//
//  Created by dohan on 2021/07/10.
//

import Foundation


struct DailyData: Codable {
    let date: String
    var items: [RoutineData]
}

// MARK: - Routine
struct RoutineData: Codable {
    let routineId: Int
    let routineName: String
    var todos: [TodoData]
}

// MARK: - Todo
struct TodoData: Codable {
    var categoryColor, categoryId: Int
    let date: String
    var done: Bool
    var days: [String]?
    var endTime: String?
    let id: Int
    var name: String
    let routineId: Int?
    let routineName:String?
    var startTime: String?
    let userId: Int
}

