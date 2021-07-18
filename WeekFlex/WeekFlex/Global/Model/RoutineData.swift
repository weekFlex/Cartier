//
//  RoutineData.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/07/18.
//

import Foundation

// MARK: - Routine
struct Routine: Codable {
    let id: Int
    let name: String
    let tasks: [RoutineTask]
}

// MARK: - Task
struct RoutineTask: Codable {
    let categoryColor: Int
    let days: [Day]
    let id: Int
    let name: String
}
