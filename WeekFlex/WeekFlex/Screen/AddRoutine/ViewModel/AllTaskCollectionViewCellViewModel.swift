//
//  AllTaskCollectionViewCellViewModel.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/06/25.
//

import Foundation

protocol AllTaskItemPresentable: Codable {
    
    var category: GetCategoryCellItemViewModel? { get }
    var tasks: [GetTaskCellItemViewModel]? { get }
    
}

struct AllTaskCellItemViewModel: AllTaskItemPresentable {
    var category: GetCategoryCellItemViewModel?
    var tasks: [GetTaskCellItemViewModel]?
    
    
}

protocol GetTaskItemPresentable: Codable {
    
    var id: Int? { get }
    var category: String? { get }
    var name: String? { get }
    var isBookmarked: Bool? { get }
    var days: [GetDaysCellItemViewModel]? { get }
}

struct GetTaskCellItemViewModel: GetTaskItemPresentable {
    
    var id: Int?
    var category, name: String?
    var isBookmarked: Bool?
    var days: [GetDaysCellItemViewModel]?
}

protocol GetCategoryItemPresentable: Codable {
    
    var id: Int? { get }
    var name: String? { get }
    var color: Int? { get }
}

struct GetCategoryCellItemViewModel: GetCategoryItemPresentable {
    
    var id: Int?
    var name: String?
    var color: Int?
}

protocol GetDaysItemPresentable: Codable {
    
    var name: String? { get }
    var startTime: String? { get }
    var endTime: String? { get }
}

struct GetDaysCellItemViewModel: GetDaysItemPresentable {
    
    var name: String?
    var startTime: String?
    var endTime: String?
}



struct AllTaskCollectionViewCellViewModel {
    
    var items: [AllTaskCellItemViewModel]
    
    init () {
         //서버 연결..?
        
        self.items = []
        
//        APIService.shared.getTask("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJpZFwiOjEsXCJlbWFpbFwiOlwibWluaUBrYWthby5jb21cIn0ifQ.8_T1pNCV9fDU00u7tdWNhe6VUh-G2HgkgYE3IOeXByI") { [self] result in
//
//            switch result {
//
//            case .success(let data):
//               data = items
//
//            case .failure(let error):
//                print(error)
//
//            }
//
//        }
    }
    
}
