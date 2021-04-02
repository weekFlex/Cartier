//
//  ToDoListCollectionViewCellViewModel.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/03/22.
//

import Foundation

protocol ToDoListItemPresentable {
    var category: String? { get }
    var listName: String? { get }
    var listTime: String? { get }
    var bookmarkCheck: Bool? { get }
}

struct ToDoListCellItemViewModel: ToDoListItemPresentable {
    var category: String?
    var listName: String?
    var listTime: String?
    var bookmarkCheck: Bool?
}

struct ToDoListCollectionViewCellViewModel {
    
    var items: [ToDoListItemPresentable] = []
    
    init () {
        let item1 = ToDoListCellItemViewModel(category: "운동", listName: "윗몸일으키기", listTime: "월, 수 10:00am-11:00am", bookmarkCheck: true)
        let item2 = ToDoListCellItemViewModel(category: "운동", listName: "스쿼트 10번", listTime: "화, 목 10:00am-1:00pm", bookmarkCheck: true)
        let item3 = ToDoListCellItemViewModel(category: "운동", listName: "스트레칭", listTime: "월, 수, 금", bookmarkCheck: false)
        
        let item4 = ToDoListCellItemViewModel(category: "공부", listName: "원서 읽기", listTime: "월, 수 10:00am-11:00am", bookmarkCheck: true)
        let item5 = ToDoListCellItemViewModel(category: "공부", listName: "스피킹", listTime: "화, 목 10:00am-1:00pm", bookmarkCheck: true)
        let item6 = ToDoListCellItemViewModel(category: "공부", listName: "문제집 풀기", listTime: "월, 수, 금", bookmarkCheck: false)
        
        let item7 = ToDoListCellItemViewModel(category: "개발", listName: "위플렉스 이슈 만들기", listTime: "화, 수, 일", bookmarkCheck: true)
        let item8 = ToDoListCellItemViewModel(category: "개발", listName: "swift 문법 정리하기", listTime: "월 1:00pm-3:00pm", bookmarkCheck: false)
        
        items.append(contentsOf: [item1, item2, item3, item4, item5, item6, item7, item8])
    }
    
}
