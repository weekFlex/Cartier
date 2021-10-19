//
//  RetrospectionData.swift
//  WeekFlex
//
//  Created by dohan on 2021/10/11.


import Foundation

// MARK: - DataClass
struct RetrospectionData: Codable {
    let content: String
    let emotionMascot: Int
    let stars: [RetroStarData]
    let startDate, title: String
}

//회고의 일주일 별 색 정보
struct RetroStarData: Codable {
    let available: Bool
    let hexaCode: String
    let id: Int
}
