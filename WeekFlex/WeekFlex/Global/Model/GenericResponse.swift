//
//  GenericResponse.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/06/25.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
    
    let data: T?
    let status: String
    let statusCode: Int
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case status = "status"
        case statusCode = "statusCode"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
        status = (try? values.decode(String.self, forKey: .status)) ?? ""
        statusCode =  (try? values.decode(Int.self, forKey: .statusCode)) ?? -1
        message = (try? values.decode(String.self, forKey: .status)) ?? ""
    }
    
}


struct SecondeGenericResponse<T: Codable>: Codable {
    
    let data: T?
    let status: String
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case status = "status"
        case statusCode = "statusCode"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
        status = (try? values.decode(String.self, forKey: .status)) ?? ""
        statusCode =  (try? values.decode(Int.self, forKey: .statusCode)) ?? -1
    }
    
}
