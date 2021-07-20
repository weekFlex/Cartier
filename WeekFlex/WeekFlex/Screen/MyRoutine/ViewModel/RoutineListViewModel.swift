//
//  MyRoutineListViewModel.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/03/21.
//

struct RoutineListViewModel {
    let routines: [Routine]
}

extension RoutineListViewModel {
    var numberOfRoutines: Int {
        return routines.count
    }
    
    func routineAtIndex(_ index: Int) -> RoutineViewModel {
        let routine = self.routines[index]
        return RoutineViewModel(routine)
    }
    
    func routineNameArray() -> [String] {
        
        
        let result: [String] = routines.map { $0.name }
        return result
    }

}

struct RoutineViewModel {
    private let routine: Routine
}

extension RoutineViewModel {
    init(_ routine: Routine) {
        self.routine = routine
    }
}

extension RoutineViewModel {
    // 루틴 이름
    var title: String {
        return self.routine.name
    }
    
    // 12개의 할 일 을 보여줄 때 사용
    var numberOfTasks: Int {
        return self.routine.tasks.count
    }
    
    var categoryColorImageName: String {
        if numberOfTasks != 0 {
            let categoryColorArr = self.routine.tasks.map({ String($0.categoryColor) })
            let dict = Dictionary(grouping: categoryColorArr, by: {$0})
            let newDict = dict.mapValues({$0.count})
            let mostCommonCategoryNumber = newDict.sorted(by: { $0.value > $1.value}).first?.key ?? ""
            return "icon-24-star-n\(mostCommonCategoryNumber)"
        } else {
            return "icon-24-star-n0"
        }
    }
    
    // 루틴 안에 있는 task를 넘겨줄 때 사용
    var rountineTaskList: [TaskListData] {
        return self.routine.tasks
    }
}
