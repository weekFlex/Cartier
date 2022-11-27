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

    func updateTask(token: String, categoryId: Int, name: String, taskId: Int,
                    completion: @escaping (Bool) -> ()) {
        APIService.shared.updateTask(token: token,
                                     categoryId: categoryId,
                                     name: name,
                                     taskId: taskId) { result in
            switch result {
            case .success(let data):
                print("결과 \(data)")
                completion(true)
            case .failure(_):
                completion(false)
            }
        }

    }
    
    func updateTodo(token: String, days: [String], endTime: String?, startTime: String?, name: String, todoId: Int, completion: @escaping (Bool) -> ()) {
        APIService.shared.updateTodo(token, days: days, endTime: endTime, startTime: startTime, name: name, todoId: todoId) { result in
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
