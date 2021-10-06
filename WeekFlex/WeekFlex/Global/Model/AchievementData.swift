//
//  AchievementData.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/10/06.
//

import Foundation

struct AchievementData: Codable {
    let achievementRate: Int
    let category: [DoneCategory]
    let routine: [DoneRoutine]
}

// MARK: - DoneCategory
struct DoneCategory: Codable {
    let categoryID: Int
    let categoryName: String
    let categoryColor, total, done, doneRate: Int

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case categoryName, categoryColor, total, done, doneRate
    }
}

// MARK: - DoneRoutine
struct DoneRoutine: Codable {
    let routineName: String
    let doneRate: Int
}
