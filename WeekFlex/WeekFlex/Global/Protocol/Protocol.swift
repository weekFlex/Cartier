//
//  SavedTimeProtocol.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/07/11.
//

import Foundation

// EditRoutine 에서
protocol SaveTimeProtocol { func saveTimeProtocol(savedTimeData: Todo) }
protocol SaveTaskListProtocol { func saveDaysProtocol(savedTaskListData: TaskListData)} //EditRoutineVC -> SelectToDoVC
protocol SaveTodoProtocol { func saveTodoProtocol(savedTodoData: TodoData, cellIndex: Int, viewIndex: Int)}
protocol HideViewProtocol { func hideViewProtocol() }
protocol SaveCategoryProtocol { func saveCategoryProtocol(savedCategory: CategoryData)} // ViewCategoryVC -> EditRoutineVC

