//
//  CategoryCollectionViewCellViewModel.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/03/22.
//

import Foundation

//struct CategoryCellItemViewModel {
//    var categoryName: String?
//    var categoryColor: String?
//}
//
//struct CategoryCollectionViewCellViewModel {
//
//    var items: [CategoryListItemPresentable] = []
//
//    init () {
//
//        let item0 = CategoryCellItemViewModel(categoryName: "전체", categoryColor: "icon12StarN3")
//        let item1 = CategoryCellItemViewModel(categoryName: "운동", categoryColor: "icon12StarN3")
//        let item2 = CategoryCellItemViewModel(categoryName: "공부", categoryColor: "icon12StarN3")
//        let item3 = CategoryCellItemViewModel(categoryName: "개발", categoryColor: "icon12StarN3")
//
//        items.append(contentsOf: [item0, item1, item2, item3])
//    }
//
//}

struct CategoryListViewModel {
    let categories: [Category]
}

extension CategoryListViewModel {
    // 해당 index 의 category 반환
    func categoryAtIndex(_ index: Int) -> CategoryViewModel {
        let category = self.categories[index]
        return CategoryViewModel(category)
    }
}

struct CategoryViewModel {
    let category: Category
}

extension CategoryViewModel {
    init (_ category: Category) {
        self.category = category
    }
}

extension CategoryViewModel {
    var name: String? {
        return self.category.name
    }
    
    var color: String? {
        let colorList = ["icon12StarN3", "icon12StarN3", "icon12StarN3", "icon12StarN3"]
        return colorList[self.category.id]
    }
}

struct TaskListViewModel {
    let tasks: [TaskItem]
}

extension TaskListViewModel {
    
    // task 의 개수 반환
    func numberOfTasks() -> Int {
        return self.tasks.count
    }
    
    // 해당 index 의 task 반환
    func taskAtIndex(_ index: Int) -> TaskViewModel {
        let task = self.tasks[index]
        return TaskViewModel(task)
    }
    
}


struct TaskViewModel {
    private let task: TaskItem
}

extension TaskViewModel {
    init(_ task: TaskItem) {
        self.task = task
    }
}

extension TaskViewModel {
    var name: String? {
        return self.task.name
    }
    var catgory: String? {
        return self.task.category
    }
    var time: String? {
        return "time"
    }
    var bookmarkCheck: Bool? {
        return self.task.isBookmarked
    }
}

