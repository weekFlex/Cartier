//
//  LookBackData.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/10/12.
//

import Foundation

// MARK: - DataClass
struct RetrospectionData: Codable {
    let content: String
    let emotionMascot: Int
    let stars: [Star]
    let startDate, title: String
}

// MARK: - Star
struct Star: Codable {
    let available: Bool
    let hexaCode: String
    let id: Int
}
