//
//  MakeRoutineData.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/07/23.
//

import Foundation

struct MakeRoutineData: Codable {
    let name: String
    let routineTaskSaveRequests: [RoutineTaskSaveRequest]
}

// MARK: - RoutineTaskSaveRequest
struct RoutineTaskSaveRequest: Codable {
    let days: [Day]
    let taskID: Int

    enum CodingKeys: String, CodingKey {
        case days
        case taskID = "taskId"
    }
}
