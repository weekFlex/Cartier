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
    
    init(_ name: String, _ routineTaskSaveRequests: [RoutineTaskSaveRequest]) {
        self.name = name
        self.routineTaskSaveRequests = routineTaskSaveRequests
    }
}

// MARK: - RoutineTaskSaveRequest
struct RoutineTaskSaveRequest: Codable {
    let days: [Day]
    let taskId: Int

    
    
    init(_ days: [Day], _ taskId: Int) {
        self.days = days
        self.taskId = taskId
    }
    
    func toParamter() -> [String: Any] {
        return [
            "days": days.map { $0.toParameter() },
            "taskId": taskId
        ]
    }
}

