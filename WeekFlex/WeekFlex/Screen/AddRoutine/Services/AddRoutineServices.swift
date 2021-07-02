//
//  AddRoutineServices.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/06/29.
//

import Foundation

var taskData: [TaskData]?

class AddRoutineServices {
    func getTask() -> ([TaskData]?) {
        var serviceResult: [TaskData]?
        
        print("gettingTasks...")
        APIService.shared.getTask("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJpZFwiOjEsXCJlbWFpbFwiOlwibWluaUBrYWthby5jb21cIn0ifQ.8_T1pNCV9fDU00u7tdWNhe6VUh-G2HgkgYE3IOeXByI") { result in
            
            switch result {
            
            case .success(let data):
                print("success")

                print(data)
                taskData = data
                if let data = taskData {
                    print(data)
                    serviceResult = data
                } else {
                    serviceResult = nil
                }
                
            case .failure(let error):
                print("failed")
                print(error)
                
            }
            
        }
        
        return serviceResult
    }
}
