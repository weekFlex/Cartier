//
//  CategoryService.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/07/21.
//

import Foundation

class CategoryService {
    func getCategories(token: String, completion: @escaping ([CategoryData]?) -> ()) {
        APIService.shared.getCategory(token) { result in
            switch result {
            case .success(let data):
                completion(data)
                            
            case .failure(let error):
                print(error)
                completion(nil) // 에러난다면 category can be nil
            }
        }
    }
}
