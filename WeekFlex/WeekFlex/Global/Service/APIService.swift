//
//  APIService.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/06/25.
//

import Foundation
import Moya
import Alamofire

struct APIService {
    
    static let shared = APIService()
    // 싱글톤객체로 생성

    let provider = MoyaProvider<APITarget>()
    // MoyaProvider(->요청 보내는 클래스) 인스턴스 생성
    
    func getTask(_ token: String, completion: @escaping (NetworkResult<[TaskData]>)->(Void)) {
        
        let target: APITarget = .getTask(token: token)
        judgeObject(target, completion: completion)
        
    }
    
    func getCategory(_ token: String, completion: @escaping (NetworkResult<[CategoryData]>)->(Void)) {
        
        let target: APITarget = .getCategory(token: token)
        judgeObject(target, completion: completion)
        
    }
    
    func getWeekly(_ token: String, date: String,  completion: @escaping (NetworkResult<[DailyData]>)->(Void)){
        let target: APITarget = .getWeekly(token: token, date: date)
        judgeObject(target, completion: completion)
    }

    func getRoutine(_ token: String,  completion: @escaping (NetworkResult<[Routine]>)->(Void)){
        let target: APITarget = .getRoutine(token: token)
        judgeObject(target, completion: completion)
    }
}

extension APIService {
    
    func judgeObject<T: Codable>(_ target: APITarget, completion: @escaping (NetworkResult<T>) -> Void) {
        provider.request(target) { response in
            switch response {
            case .success(let result):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(GenericResponse<T>.self, from: result.data)
                    if let data = body.data {
                        completion(.success(data))
                    }
                } catch {
                    print("구조체를 확인해보세요")
                }
            case .failure(let error):
                completion(.failure(error.response?.statusCode ?? 100))
            }
        }
    }
    
    func judgeSimpleObject(_ target: APITarget, completion: @escaping (NetworkResult<Any>) -> Void) {
        // data 구조체로 받아오지 않을 때 사용
        
        provider.request(target) { response in
            switch response {
            case .success(let result):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(SimpleResponse.self, from: result.data)
                    completion(.success(body))
                } catch {
                    print("구조체를 확인해보세요")
                }
            case .failure(let error):
                completion(.failure(error.response!.statusCode))
            }
        }
    }
}


class NetworkState {
    class func isConnected() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
