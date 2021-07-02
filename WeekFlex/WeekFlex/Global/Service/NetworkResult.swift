//
//  NetworkResult.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/06/25.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case failure(Int)
}
