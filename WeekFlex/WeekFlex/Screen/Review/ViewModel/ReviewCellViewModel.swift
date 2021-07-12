//
//  ReviewCollectionViewModel.swift
//  WeekFlex
//
//  Created by dohan on 2021/06/12.
//

import Foundation

protocol ReviewItemPresentable {
    var date: String { get }
    var title: String { get }
//    var categoryList: [String]? { get }
    var description: String? { get }
}

struct ReviewItemViewModel: ReviewItemPresentable {
    var date: String
    var title: String
    var description: String?
}

struct ReviewCollectionViewCellViewModel {
    
    var items: [ReviewItemPresentable] = []
    
    init() {
        let item1 = ReviewItemViewModel(date: "11월 30일 ~ 12월 6일", title: "룰루랄라", description: "몰라몰라")
        let item2 = ReviewItemViewModel(date: "12월 7일 ~ 12월 13일", title: "12월 둘째주", description: "하하tj설명내용설명회고내용")
        let item3 = ReviewItemViewModel(date: "12월 14일 ~ 12월 20일", title: "와아", description: "하하")
        let item4 = ReviewItemViewModel(date: "12월 21일 ~ 12월 27일", title: "클스마스", description: "great!")
        let item5 = ReviewItemViewModel(date: "12월 28일 ~ 1월 4일", title: "새해첫해", description: "ㅏ아아아아아 ~~~~~!")
        
        
        items.append(contentsOf: [item1, item2, item3, item4, item5])
        
    }
    
}
