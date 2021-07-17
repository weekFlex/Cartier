//
//  File.swift
//  WeekFlex
//
//  Created by dohan on 2021/07/15.
//

import Foundation

extension Collection {
    
    //index를 Optional 타입으로 반환해주어 안전하게 인덱스 접근할 수 있도록 해줌
    //사용법:  guard let value = arr[safe: index] else { return 0 }
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
