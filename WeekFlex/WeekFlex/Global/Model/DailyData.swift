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
    let routineID: Int
    let routineName: String
    let todos: [TodoData]
}

// MARK: - Todo
struct TodoData: Codable {
    let id: Int
    let categoryColor: Int
    let categoryId: Int
    let date: String
    let done: Bool
    let startTime: String
    let endTime: String
    let name: String
    let routineId: Int
    let routineName: String
    let userId: Int
}

