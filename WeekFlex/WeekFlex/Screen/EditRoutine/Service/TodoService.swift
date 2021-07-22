//
//  CreateTodoService.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/07/23.
//

import Foundation

class TodoService {
    func createTodo(token: String, categoryId: Int, date: String, endTime: String?, startTime: String?, name: String, completion: @escaping (Bool) -> ()) {
        APIService.shared.createTodo(token, categoryId: categoryId, date: date, endTime: endTime, startTime: startTime, name: name) { result in
            switch result {
            case .success(_):
                completion(true)
                            
            case .failure(let error):
                print(error)
                completion(false) // 에러난다면 category can be nil
            }
        }
    }
    
    func createTask(token: String, categoryId: Int, name: String, completion: @escaping (Bool) -> ()) {
        APIService.shared.createTask(token: token, categoryId: categoryId, name: name) { result in
            switch result {
            case .success(_):
                completion(true)
                            
            case .failure(let error):
                print(error)
                completion(false) // 에러난다면 category can be nil
            }
        }
    }
}
