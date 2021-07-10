//
//  TaskData.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/07/10.
//

import Foundation

struct TaskData: Codable {
    let category: CategoryData
    let tasks: [TaskListData]
}

// MARK: - Task
struct TaskListData: Codable {
    let category: String
    let days: [Day]
    let id: Int
    let isBookmarked: Bool
    let name: String
}

// MARK: - Day
struct Day: Codable {
    let endTime, name, startTime: String
}