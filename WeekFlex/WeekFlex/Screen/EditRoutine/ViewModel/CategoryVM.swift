//
//  CategoryVM.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/07/21.
//

import Foundation
struct CategoryListViewModel {
    let categories: [CategoryDataWithoutID]
    
    var numberOfCategories: Int {
        return categories.count
    }
    
    func categoryAtIndex(_ index: Int) -> CategoryViewModel {
        let category = self.categories[index]
        return CategoryViewModel(category)
    }
}


struct CategoryViewModel {
    private let category: CategoryDataWithoutID
    
    init(_ category: CategoryDataWithoutID) {
        self.category = category
    }
    
    var title: String? {
        return category.name
    }
    
    var categoryColorImageName: String {
        return "icon-24-star-n\(category.color)"
    }
}


