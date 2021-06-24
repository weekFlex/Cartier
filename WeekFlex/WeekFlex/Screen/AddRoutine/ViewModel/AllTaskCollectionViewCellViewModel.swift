//
//  AllTaskCollectionViewCellViewModel.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/06/25.
//

import Foundation

protocol AllTaskItemPresentable {
    
    var category: GetCategoryItemPresentable? { get }
    var tasks: [GetTaskCellItemViewModel]? { get }
}

struct AllTaskCellItemViewModel: AllTaskItemPresentable {
    var category: GetCategoryItemPresentable?
    var tasks: [GetTaskCellItemViewModel]?
}

protocol GetTaskItemPresentable {
    
    var id: Int? { get }
    var category: String? { get }
    var name: String? { get }
    var isBookmarked: Bool? { get }
    var days: [GetDaysItemPresentable]? { get }
}

struct GetTaskCellItemViewModel: GetTaskItemPresentable {
    
    var id: Int?
    var category, name: String?
    var isBookmarked: Bool?
    var days: [GetDaysItemPresentable]?
}

protocol GetCategoryItemPresentable {
    
    var id: Int? { get }
    var name: String? { get }
    var color: Int? { get }
}

struct GetCategoryCellItemViewModel: GetCategoryItemPresentable {
    
    var id: Int?
    var name: String?
    var color: Int?
}

protocol GetDaysItemPresentable {
    
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
    
    var items: [AllTaskItemPresentable] = []
    
    init () {
        // 서버 연결..?
        
    }
    
}
