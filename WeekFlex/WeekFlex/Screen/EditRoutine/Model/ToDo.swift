//
//  ToDo.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/07/10.
//

import Foundation

// MARK: - Todo
struct Todo: Codable {
    var categoryID: Int?
    var date: String?
    var endTime: String?
    var name: String
    var startTime: String?

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case date, endTime, name
        case startTime
    }
}
