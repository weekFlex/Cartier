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
    case createTask(token: String, categoryId: Int, name: String) // task 등록
    case getCategory(token: String) // 카테고리 리스트 API
    case createCategory(token: String, color: Int, name: String)
    case getWeekly(token: String, date: String)   // 캘린더 일주일 할일 불러오기
    case checkTodo(token: String, todoId: Int, done: Bool)   //할일 체크
    case updateTodo(token: String, days: [String], endTime: String?, startTime: String?, name: String, todoId: Int) // todo수정
    case createTodo(token: String, categoryId: Int, date: String, endTime: String?, name: String, startTime: String?)
    case deleteTodoRoutine(token: String, routineId: Int)   //캘린더에서 루틴 전체 삭제
    case deleteRoutine(token: String, routineID: Int)
    case deleteTodo(token: String, todoId: Int) //캘린더 할일삭제
    case getRoutine(token: String) // 루틴 리스트 API
    case makeRoutine(token: String, name: String, routineTaskSaveRequests: [RoutineTaskSaveRequest]) // 루틴 생성하기 API
    case registerRoutine(token: String, routineID: Int) // 루틴 등록
    case getUserProfile(token: String) //유저 프로필 받아오기
    
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
        case .getTask, .createTask:
            return "api/v1/task/"
        case .getCategory, .createCategory:
            return "api/v1/category"
        case .getWeekly:
            return "api/v1/calendar/week"
        case .checkTodo(_, let todoId, _):
            return "api/v1/todo/\(todoId)/done"
        case .deleteTodoRoutine:
            return  "api/v1/todo/routine"
        case .deleteTodo(_,let todoId), .updateTodo(_, _, _, _, _, let todoId):
            return "api/v1/todo/\(todoId)"
        case .getRoutine, .makeRoutine, .deleteRoutine:
            return "api/v1/routine"
        case .createTodo:
            return "api/v1/todo"
        case .registerRoutine(_, let routineID):
            return "api/v1/routine/\(routineID)/register"
        case .getUserProfile:
            return "api/v1/users/profile"
        }
    }
    
    var method: Moya.Method {
        // method - 통신 method (get, post, put, delete ...)
        
        switch self {
        
        case .getTask, .getCategory, .getWeekly, .getRoutine, .getUserProfile:
            return .get
            
        case .checkTodo, .createCategory, .createTodo, .createTask, .registerRoutine, .makeRoutine:
            return .post
            
        case .deleteTodoRoutine, .deleteTodo, .deleteRoutine:
            return .delete
            
        case .updateTodo:
            return .put
        }
    }
    
    var sampleData: Data {
        // sampleDAta - 테스트용 Mock Data
        
        return Data()
    }
    
    var task: Task {
        // task - 리퀘스트에 사용되는 파라미터 설정
        // 파라미터가 없을 때는 - .requestPlain
        // get메소드인데 파라미터 존재시(URL로 전달) -.requestParameters(parameters: ["first_name": firstName, "last_name": lastName], encoding: URLEncoding.default)
        // 파라미터 존재시에는 - .requestParameters(parameters: ["first_name": firstName, "last_name": lastName], encoding: JSONEncoding.default)
        
        switch self {
        
        case .getTask, .getCategory, .getRoutine, .getUserProfile:
            return .requestPlain
        
        case .createTask(_, let categoryId, let name):
            return .requestParameters(parameters: ["categoryId": categoryId, "name": name], encoding: JSONEncoding.default)
            
        case .getWeekly(_, let date):
            return .requestParameters(parameters: ["date": date], encoding: URLEncoding.default)
        
        case .createTodo(_, let categoryId, let date, let endTime, let name, let startTime):
            return .requestParameters(parameters: ["categoryId": categoryId, "date": date, "name": name, "startTime": startTime ?? NSNull(), "endTime": endTime ?? NSNull()], encoding: JSONEncoding.default)
        
        case .createCategory(_, let color, let name):
            return .requestParameters(parameters: ["color": color, "name": name], encoding: JSONEncoding.default)
            
        case .checkTodo(_, _, let done):
            return .requestParameters(parameters: ["done": done], encoding: JSONEncoding.default)
            
        case .deleteTodo(_, let todoId):
            return .requestParameters(parameters: ["todoId":todoId], encoding: JSONEncoding.default)
        
        case .deleteRoutine(_, let routineID):
            return .requestParameters(parameters: ["routineId": routineID], encoding: URLEncoding.default)
            
        case .registerRoutine(_, let routineID):
            return .requestParameters(parameters: ["routineId": routineID], encoding: JSONEncoding.default)
        
        case .updateTodo(_, let days, let endTime, let startTime, let name, let todoId):
            return .requestParameters(parameters: ["todoId": todoId, "days": days, "endTime": endTime ?? NSNull(), "startTime": startTime ?? NSNull(), "name": name] , encoding: JSONEncoding.default)
            
        case .deleteTodoRoutine(_, let routineId):
            return .requestParameters(parameters: ["routineId":routineId], encoding: URLEncoding.default)
            
        case .makeRoutine(_, let name, let routineTaskSaveRequests):
            
            let encoder: JSONEncoder = JSONEncoder()
            let newRoutine = MakeRoutineData(name,routineTaskSaveRequests)
            let jsonData: Data = try! encoder.encode(newRoutine)
            
            return .requestData(jsonData)
        }
    }
    
    var validationType: Moya.ValidationType {
        // validationType - 허용할 response의 타입
        
        return .successAndRedirectCodes
    }
    
    var headers: [String : String]? {
        // headers - HTTP header
        
        switch self {
        
        case .getTask(let token), .getCategory(let token), .checkTodo(token: let token,_,_),.getRoutine(let token), .getWeekly(token: let token, _), .deleteTodoRoutine(token: let token, _), .updateTodo(let token, _, _, _, _, _), .createTodo(let token, _, _, _, _, _), .deleteTodo(token: let token, _), .deleteRoutine(let token, _),.createCategory(let token, _, _), .createTask(let token, _, _), .registerRoutine(let token, _), .makeRoutine(let token, _, _), .getUserProfile(let token):
            return ["Content-Type" : "application/json", "x-access-token" : token]
        }
    }
    
}
