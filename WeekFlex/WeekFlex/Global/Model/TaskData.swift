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
    let category: String?
    let categoryColor: Int
    var days: [Day]? // 처음에는 없지만, 이후 수정뷰에서 추가됨
    let id: Int
    let isBookmarked: Bool?
    let name: String
}

// MARK: - Day
struct Day: Codable {
    var endTime, startTime: String?
    let name: String
}
