//
//  MyRoutineListViewModel.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/03/21.
//

protocol MyRoutineListItemPresentable {
    var routineImage: String? { get }
    var routineTitle: String? { get }
    var routineElements: String? { get }
}

struct MyRoutineListItemViewModel: MyRoutineListItemPresentable {
    var routineImage: String? = "icon24StarN1"
    var routineTitle: String?
    var routineElements: String?
}

protocol MyRoutineListItemViewDelegate {
    func listItemAdded() -> ()
}

struct MyRoutineListViewModel {
    init () {
        
        let item1 = MyRoutineListItemViewModel(routineImage: nil, routineTitle: "Design Master", routineElements: "12개의 할 일")
        let item2 = MyRoutineListItemViewModel(routineImage: nil, routineTitle: "가나다라마바사아자차카", routineElements: "3개의 할 일")
        
        items.append(contentsOf: [item1, item2])
    }
    
    var newRoutineListItem: String?
    var items: [MyRoutineListItemPresentable] = []
}

extension MyRoutineListViewModel: MyRoutineListItemViewDelegate {
    
    func listItemAdded() {
    }
}
