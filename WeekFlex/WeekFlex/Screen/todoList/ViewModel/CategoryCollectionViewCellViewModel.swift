//
//  CategoryCollectionViewCellViewModel.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/03/22.
//

import Foundation

protocol CategoryListItemPresentable {
    var categoryName: String? { get }
    var categoryColor: String? { get }
}

struct CategoryCellItemViewModel: CategoryListItemPresentable {
    var categoryName: String?
    var categoryColor: String?
}

struct CategoryCollectionViewCellViewModel {
    
    var items: [CategoryListItemPresentable] = []
    
    init () {
        
        let item1 = CategoryCellItemViewModel(categoryName: "운동", categoryColor: "icon12StarN3")
        let item2 = CategoryCellItemViewModel(categoryName: "공부", categoryColor: "icon12StarN3")
        let item3 = CategoryCellItemViewModel(categoryName: "개발", categoryColor: "icon12StarN3")
        
        items.append(contentsOf: [item1, item2, item3])
    }
    
}
