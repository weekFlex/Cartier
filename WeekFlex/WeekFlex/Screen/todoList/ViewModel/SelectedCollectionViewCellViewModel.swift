//
//  SelectedCollectionViewCellViewModel.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/03/23.
//

import Foundation

protocol SelectedItemPresentable {
    var listName: String? { get }
}

protocol SelectedItemViewDelegate {
    func listItemAdded(value: String)
    func listItemRemoved(value: Int)
}

struct SelectedCellItemViewModel: SelectedItemPresentable {
    var listName: String?
}

struct SelectedCollectionViewCellViewModel {
    
    var items: [SelectedItemPresentable] = []
    init () {
        items = []
    }
}
