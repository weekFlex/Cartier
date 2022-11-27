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
    
    let provider = MoyaProvider<APITarget>(plugins: [MoyaLoggingPlugin()])
    // MoyaProvider(->요청 보내는 클래스) 인스턴스 생성
    
    func getTask(_ token: String, completion: @escaping (NetworkResult<[TaskData]>)->(Void)) {
        let target: APITarget = .getTask(token: token)
        judgeObject(target, completion: completion)
    }
    
    func createTask(token: String, categoryId: Int, name: String, completion: @escaping (NetworkResult<[TaskListData]>)->(Void)) {
        let target: APITarget = .createTask(token: token, categoryId: categoryId, name: name)
        judgeObject(target, completion: completion)
    }

    func updateTask(token: String, categoryId: Int, name: String, taskId: Int, completion: @escaping (NetworkResult<TaskListData>)->(Void)) {
        let target: APITarget = .updateTask(token: token, categoryId: categoryId, name: name, taskId: taskId)
        judgeObject(target, completion: completion)
    }
    
    func bookmarkTask(token: String, taskId: Int, completion: @escaping (NetworkResult<BookmarkData>)->(Void)) {
        let target: APITarget = .bookmarkTask(token: token, taskId: taskId)
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
    
    func checkTodo(_ token: String, todoId: Int, done: Bool, completion: @escaping (NetworkResult<SimpleData>)->(Void)){
        let target: APITarget = .checkTodo(token: token, todoId: todoId, done: done)
        judgeObject(target, completion: completion)
    }
    


    func createCategory(_ token: String, color: Int, name: String, completion: @escaping (NetworkResult<CategoryData>)->(Void)) {
        let target: APITarget = .createCategory(token: token, color: color, name: name)
        judgeObject(target, completion: completion)
    }
    
    func updateCategory(_ token: String, color: Int, id: Int, name: String?, completion: @escaping (NetworkResult<CategoryData>)->(Void)) {
        let target: APITarget = .updateCategory(token: token, color: color, id: id, name: name)
        judgeObject(target, completion: completion)
    }

    func deleteCategory(_ token: String, id: Int, completion: @escaping (NetworkResult<DeleteData>)->(Void)) {
        let target: APITarget = .deleteCategory(token: token, id: id)
        judgeObject(target, completion: completion)
    }
    
    func createTodo(_ token: String, categoryId: Int, date: String, endTime: String?, startTime: String?, name: String, completion: @escaping (NetworkResult<CreateTodoResponseData>)->(Void)) {
        let target: APITarget = .createTodo(token: token, categoryId: categoryId, date: date, endTime: endTime, name: name, startTime: startTime)
        judgeObject(target, completion: completion)
    }
    
    func deleteTodoRoutine(_ token: String, routineId: Int, completion: @escaping (NetworkResult<SimpleData>)-> (Void)){
        let target:  APITarget = .deleteTodoRoutine(token: token, routineId: routineId)
        judgeObject(target, completion: completion)
    }
    

    func updateTodo(_ token: String, days: [String], endTime: String?, startTime: String?, name: String, todoId: Int, completion: @escaping (NetworkResult<Int>)-> (Void)) {
        let target:  APITarget = .updateTodo(token: token, days: days, endTime: endTime, startTime: startTime, name: name, todoId: todoId)
        judgeObject(target, completion: completion)
    }
    
    func deleteTodo(_ token: String, todoId: Int, completion: @escaping ((NetworkResult<SimpleData>) ->(Void))) {

        let target: APITarget = .deleteTodo(token: token, todoId: todoId)
        judgeObject(target, completion: completion)
    }

    func deleteTask(_ token: String, taskId: Int, completion: @escaping ((NetworkResult<SimpleData>) ->(Void))) {

        let target: APITarget = .deleteTask(token: token, taskId: taskId)
        judgeObject(target, completion: completion)
    }

    func deleteRoutine(_ token: String, routineID: Int, completion: @escaping ((NetworkResult<SimpleData>) ->(Void))) {
        let target: APITarget = .deleteRoutine(token: token, routineID: routineID)
        judgeObject(target, completion: completion)
    }

    func getRoutine(_ token: String,  completion: @escaping (NetworkResult<[Routine]>)->(Void)){
        let target: APITarget = .getRoutine(token: token)
        judgeObject(target, completion: completion)
    }
    
    func makeRoutine(_ token: String, _ name: String, _ routineTaskSaveRequests: [RoutineTaskSaveRequest], completion: @escaping (NetworkResult<Routine>)->(Void)){
        let target: APITarget = .makeRoutine(token: token, name: name, routineTaskSaveRequests: routineTaskSaveRequests)
        judgeObject(target, completion: completion)
    }
    
    func editRoutine(_ token: String, _ routineId: Int, _ name: String, _ routineTaskSaveRequests: [RoutineTaskSaveRequest], completion: @escaping (NetworkResult<Routine>)->(Void)) {
        let target: APITarget = .editRoutine(token: token,
                                             routineId: routineId,
                                             name: name,
                                             routineTaskSaveRequests: routineTaskSaveRequests)
        judgeObject(target, completion: completion)
    }

    func registerRoutine(_ token: String, routineID: Int, completion: @escaping ((NetworkResult<SimpleData>) ->(Void))) {
        let target: APITarget = .registerRoutine(token: token, routineID: routineID)
        judgeObject(target, completion: completion)
    }
    
    func getUserProfile(_ token: String, completion: @escaping ((NetworkResult<ProfileData>)->(Void))){
        let target: APITarget = .getUserProfile(token: token)
        judgeObject(target, completion: completion)
    }
    
    func getRetrospection( _ token: String, completion: @escaping ((NetworkResult<[RetrospectionData]>)-> (Void))){
        let target: APITarget = .getRetrospection(token: token)
        judgeObject(target, completion: completion)
    }
    func getStatistics(_ token: String, _ date: String, completion: @escaping (NetworkResult<AchievementData>)->(Void)){
        let target: APITarget = .statistics(token: token, date: date)
        miniJudgeObject(target, completion: completion)
    }
    
    func writeRetrospection(_ token: String, _ content: String, _ emotionMascot: Int, _ startDate: String, _ title: String, completion: @escaping (NetworkResult<RetrospectionData>)->(Void)){
        let target: APITarget = .writeRetrospection(token: token, content: content, emotionMascot: emotionMascot, startDate: startDate, title: title)
        judgeObject(target, completion: completion)
    }
    
    func createLastStars(_ token:String, _ stars: [Int], _ weekStartDate: String, completion: @escaping (NetworkResult<SimpleData>) -> (Void)) {
        let target: APITarget = .createLastStars(token: token, stars: stars, weekStartDate: weekStartDate)
        judgeObject(target, completion: completion)
        
    }
    
    func deleteAccount(_ token:String, _ code:String?, _ details: String, _ withdrawalType: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let target: APITarget = .deleteAccount(token: token, code: code, details: details, withdrawalType: withdrawalType)
        judgeSimpleObject(target, completion: completion)
    }

    func socialLogin(_ token:String, _ code:String, _ email: String, _ name: String, _ signupType: String , completion: @escaping (NetworkResult<TokenData>) -> (Void)) {
        let target: APITarget = .socialLogin(token: token, code: code, email: email, name: name, signupType: signupType)
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
    
    func miniJudgeObject<T: Codable>(_ target: APITarget, completion: @escaping (NetworkResult<T>) -> Void) {
        provider.request(target) { response in
            switch response {
            case .success(let result):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(SecondeGenericResponse<T>.self, from: result.data)
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
