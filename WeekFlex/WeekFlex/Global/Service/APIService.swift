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
    
    func getTask(_ token: String, completion: @escaping (NetworkResult<[CategoryListItemPresentable]>)->(Void)) {
        
    }

}
