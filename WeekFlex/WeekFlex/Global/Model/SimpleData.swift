//
//  SimpleData.swift
//  WeekFlex
//
//  Created by jj-sh on 2021/07/21.
//

import Foundation


struct SimpleData: Codable {
    let data: DataClass
    let status: String
    let statusCode: Int
}

// MARK: - DataClass
struct DataClass: Codable {
    
    let isSuccess: Bool
}
