//
//  RoutineData.swift
//  WeekFlex
//
//  Created by dohan on 2021/07/10.
//

import Foundation


struct DailyData: Codable {
    let date: String
    let items: [RoutineData]
}

// MARK: - Routine
struct RoutineData: Codable {
    let routineId: Int
    let routineName: String
    let todos: [TodoData]
}

// MARK: - Todo
struct TodoData: Codable {
    let categoryColor, categoryId: Int
    let date: String
    let done: Bool
    let endTime: String
    let id: Int
    let name: String
    let routineId: Int
    let routineName, startTime: String
    let userId: Int
}

