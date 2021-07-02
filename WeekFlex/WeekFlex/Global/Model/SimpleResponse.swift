//
//  SimpleResponse.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/06/25.
//

import Foundation

struct SimpleResponse: Codable {
    var data: String
    var status: String
    var statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case status = "status"
        case statusCode = "statusCode"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = (try? values.decode(String.self, forKey: .data)) ?? ""
        status = (try? values.decode(String.self, forKey: .status)) ?? ""
        statusCode = (try? values.decode(Int.self, forKey: .statusCode)) ?? -1
        
    }
}
