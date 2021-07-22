//
//  UIString+Extension.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/07/22.
//

import UIKit

extension String {
    
    func changeTime() -> String {
        // "10:00:00" -> "10:00 am"
        // 시간 String 변경하는 extension
        
        var arr: [String] = []
        var answer: String = ""
        
        if self != "" {
            
            arr = self.components(separatedBy: ":") // ["시간","분","초"] 로 분해
            arr = Array(arr[0...1]) // 초가 존재한다면 빼기
            
            var time = Int(arr[0])!
            
            if time < 12 {
                // 오전일 때
                
                if time < 10 {
                    // 한자리 숫자면
                    arr[0] = "\(time)"
                }
                
                answer = "\(arr[0]):\(arr[1])am"
                
            } else {
                // 오후일 때
                
                time -= 12
                arr[0] = String(time)
                
                if time < 10 {
                    // 한자리 숫자면
                    arr[0] = "\(time)"
                }
                
                answer = "\(arr[0]):\(arr[1])pm"
            }
        }
        
        
        return answer
        
    }
}

