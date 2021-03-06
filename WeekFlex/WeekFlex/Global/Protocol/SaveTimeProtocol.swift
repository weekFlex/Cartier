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
protocol HideViewProtocol { func hideViewProtocol() }
