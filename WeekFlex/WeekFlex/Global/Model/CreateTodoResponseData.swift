//
//  CreateTodoResponseData.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/07/23.
//

import Foundation

struct CreateTodoResponseData: Codable {
    let id: Int
    let name, date: String
    let startTime, endTime: String?
    let done: Bool
}
