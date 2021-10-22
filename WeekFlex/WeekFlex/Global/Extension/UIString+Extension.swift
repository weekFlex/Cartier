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
    
    func changeHour() -> String {
        // 한자리 시간일 때 앞에 0 붙여주는 함수
        // "9:00" -> "09:00"
        
        var hour: String = self
        
        if self.count == 4 {
            // 한자리 숫자라면
            hour = "0\(self)"
        }
        
        return hour
    }
    
    func changeDay() -> String {
        //"2021-10-01" -> "10월 1일"
        var arr: [String] = []
        var result: String = ""
        if self != "" {
            arr = self.components(separatedBy: "-")
            arr = Array(arr[1...2]) //년도 제거
            if arr[0][arr[0].startIndex] == "0" {
                arr[0].removeFirst()
            }
            if arr[1][arr[1].startIndex] == "0" {
                arr[1].removeFirst()
            }
            
            result = "\(arr[0])월 \(arr[1])일"
        }
        
        return result
    }
    
    
}

