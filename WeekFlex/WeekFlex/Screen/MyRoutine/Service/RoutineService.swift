//
//  RoutineService.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/07/18.
//

import Foundation

class RoutineService {
    func getRoutines(token: String, completion: @escaping ([Routine]?) -> ()) {
        APIService.shared.getRoutine(token) { result in
            switch result {
            case .success(let data):
                completion(data)
                            
            case .failure(let error):
                print(error)
                completion(nil) // 에러난다면 routine can be nil
            }
        }
    }
}
