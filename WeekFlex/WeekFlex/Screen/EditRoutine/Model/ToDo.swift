//
//  ToDo.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/07/10.
//

import Foundation

// MARK: - Todo
struct Todo: Codable {
    let categoryColor, categoryID: Int
    let date: String
    let done: Bool
    var endTime: String?
    let id: Int
    let name: String
    let routineID: Int
    let routineName: String
    var startTime: String?
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case categoryColor
        case categoryID = "categoryId"
        case date, done, endTime, id, name
        case routineID = "routineId"
        case routineName, startTime
        case userID = "userId"
    }
}
