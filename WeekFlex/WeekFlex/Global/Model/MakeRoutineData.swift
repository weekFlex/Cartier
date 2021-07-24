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
}

struct EditRoutineData: Codable {
    let name: String
    let routineTaskUpdateRequests: [RoutineTaskUpdateRequests]
    
    init(_ name: String, _ routineTaskUpdateRequests: [RoutineTaskUpdateRequests]) {
        self.name = name
        self.routineTaskUpdateRequests = routineTaskUpdateRequests
    }
}

struct RoutineTaskUpdateRequests: Codable {
    let days: [Day]
    let taskId: Int
}
