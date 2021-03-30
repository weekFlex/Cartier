//
//  MainHomeViewModel.swift
//  WeekFlex
//
//  Created by dohan on 2021/03/31.
//

import Foundation

protocol CalendarItemPresentable {
    var date: String { get }
    var day: Int { get }
    var category: String? { get }
}

struct CalendarItemViewModel: CalendarItemPresentable {
    var date: String
    var day: Int
    var category: String?
}


