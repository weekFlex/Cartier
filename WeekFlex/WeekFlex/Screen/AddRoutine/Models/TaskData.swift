//
//  Task.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/06/29.
//

import Foundation

// MARK: - TaskData
//struct TaskData: Codable {
//    let data: [Datum]
//    let message, status: String
//    let statusCode: Int
//}

// MARK: - TaskData
struct TaskData: Codable {
    let category: Category
    let tasks: [TaskItem]
}

// MARK: - Category
struct Category: Codable {
    let color, id: Int
    let name: String
}

// MARK: - Task
struct TaskItem: Codable {
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
