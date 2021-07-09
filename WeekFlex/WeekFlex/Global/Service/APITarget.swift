//
//  APITarget.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/06/25.
//

import Foundation
import Moya

enum APITarget {
    
    case getTask(token: String) // 전체 Task 불러오기
}

// MARK: TargetType Protocol 구현

extension APITarget: TargetType {
    
    var baseURL: URL {
        // baseURL - 서버의 도메인
        
        return URL(string: "http://dev.weekflex.com/")!
    }
    
    var path: String {
        // path - 서버의 도메인 뒤에 추가 될 경로
        
        switch self {
        case .getTask:
            return "api/v1/task/"
        }
    }
    
    var method: Moya.Method {
        // method - 통신 method (get, post, put, delete ...)
        
        switch self {
        
        case .getTask:
            return .get
            
        }
    }
    
    var sampleData: Data {
        // sampleDAta - 테스트용 Mock Data
        
        return Data()
    }
    
    var task: Task {
        // task - 리퀘스트에 사용되는 파라미터 설정
        // 파라미터가 없을 때는 - .requestPlain
        // 파라미터 존재시에는 - .requestParameters(parameters: ["first_name": firstName, "last_name": lastName], encoding: JSONEncoding.default)
        
        switch self {
        
        case .getTask:
            return .requestPlain
            
        }
        
    }
    
    var validationType: Moya.ValidationType {
        // validationType - 허용할 response의 타입
        
        return .successAndRedirectCodes
    }
    
    var headers: [String : String]? {
        // headers - HTTP header
        
        switch self {
        
        case .getTask(let token):
            return ["Content-Type" : "application/json", "x-access-token" : token]
        }
        
    }
    
}
