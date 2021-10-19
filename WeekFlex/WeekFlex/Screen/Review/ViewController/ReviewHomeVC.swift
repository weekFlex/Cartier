//
//  ReviewVC.swift
//  WeekFlex
//
//  Created by dohan on 2021/06/06.
//

import Foundation
import UIKit

class ReviewHomeVC: UIViewController {
    
    // MARK: Variable Part
    
    var reviewViewModel: ReviewCollectionViewCellViewModel = ReviewCollectionViewCellViewModel()
    var retrospectionData: [RetrospectionData] = []
    var currentMonth: Int = Calendar.current.component(.month, from: Date())
    var currentYear: Int = Calendar.current.component(.year, from: Date())
    var currentIndex: Int = 0
    var nextIndex: Int = 0
    var currentCell: Int = 0
    
    // MARK: IBOutlet
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var reviewList: UICollectionView!
    
    // MARK: IBAction
    @IBAction func showPrev(_ sender: Any) {
        if currentMonth == 1 {
            currentYear -= 1
            currentMonth = 12
        }else{
            currentMonth -= 1
        }
        nextIndex = currentIndex - 1
        
        setLayout()
        reviewList.reloadData()
    }
    @IBAction func showNext(_ sender: Any) {
        if currentMonth == 12 {
            currentYear += 1
            currentMonth = 1
        }else{
            currentMonth += 1
        }
        print(currentYear,",", currentMonth,",", nextIndex,",", currentIndex)
        nextIndex = currentIndex + currentCell
        setLayout()
        reviewList.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJpZFwiOjgsXCJlbWFpbFwiOlwicmV0cm9AYWFhLmNvbVwifSJ9.5uH2ZI5K6CKNE9OdEQl_M2e1aflgRgDV24_UkOjnwbw", forKey: "UserToken")
        getRetrospection()
        reviewList.register(UINib(nibName: "ReviewCell", bundle: nil), forCellWithReuseIdentifier: "reviewCell")
    }
    
    
}

extension ReviewHomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = reviewList.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ReviewCell
        let data = Array(retrospectionData[currentIndex..<currentIndex + currentCell])
        let item = data[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = reviewList.frame.width
        
        return CGSize(width: width, height: 160)
    }
    
    
}

extension ReviewHomeVC {
    
    
    //회고 데이터 가져오기
    func getRetrospection(){
        if NetworkState.isConnected() {
            // 네트워크 연결 시
            if let token = UserDefaults.standard.string(forKey: "UserToken") {
                APIService.shared.getRetrospection(token) { [self] result in
                    switch result {
                    case .success(let data):
                        retrospectionData = data
//                        for i in 0..<7 {
//                            for j in 0..<weeklyData[i].items.count {
//                                var data = weeklyData[i].items[j].todos
//                                for k in 0..<data.count {
//                                    weeklyData[i].items[j].todos[k].startTime = data[k].startTime?.changeTime()
//                                    weeklyData[i].items[j].todos[k].endTime = data[k].endTime?.changeTime()
//                                }
//                            }
//                        }
                        print(retrospectionData)
                        nextIndex = retrospectionData.count - 1
                        setLayout()
                        reviewList.reloadData()
                    // 데이터 전달 후 다시 로드
                    case .failure(let error):
                        print(error)
                        print("오류!!")
                    }
                }
            }
        } else {
            // 네트워크 미연결 팝업 띄우기
            print("네트워크 미연결")
        }
    }
    
    func setLayout(){
        month.text = "\(currentYear)" + "." + "\(currentMonth)"
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        currentCell = 0
        for i in stride(from:nextIndex,to: 0, by: -1){
            print("nextIndex", nextIndex)
            let date = retrospectionData[i].startDate.split(separator:"-")
            if date[0] == "\(currentYear)" && date[1] < "\(currentMonth)" {
                currentIndex = i + 1
                nextIndex = i + 1
                break
            }else if date[0] == "\(currentYear)" && date[1] == "\(currentMonth)"{
                currentCell += 1
            }
        }
        
        
        print("currentCell: ", currentCell)
        print("currentIndex: ", currentIndex)
    }
    
}
