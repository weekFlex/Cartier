//
//  ReviewVC.swift
//  WeekFlex
//
//  Created by dohan on 2021/06/06.
//

import UIKit
import SnapKit

class ReviewHomeVC: UIViewController {
    
    // MARK: Variable Part
    var retrospectionData: [RetrospectionData] = []
    var monthlyData: [[RetrospectionData]] = []
    var currentMonth: Int = Calendar.current.component(.month, from: Date())
    var currentYear: Int = Calendar.current.component(.year, from: Date())
    var currentIndex: Int = 0
    lazy var emptyView: UIView = {
        let view = ReviewEmptyView(frame: .zero)
        return view
    }()
    
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
        } else {
            currentMonth -= 1
        }
        currentIndex -= 1
        setLayout()
        reviewList.reloadData()
    }
    @IBAction func showNext(_ sender: Any) {
        if currentMonth == 12 {
            currentYear += 1
            currentMonth = 1
        } else {
            currentMonth += 1
        }
        currentIndex += 1
        setLayout()
        reviewList.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getRetrospection()
        setEmptyView()
        reviewList.register(UINib(nibName: "ReviewCell", bundle: nil),
                            forCellWithReuseIdentifier: "reviewCell")
    }
    func setEmptyView() {
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints {
            $0.top.equalTo(month.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - CollectionViewDelegate
extension ReviewHomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        reviewList.isHidden = monthlyData.isEmpty
        return monthlyData.isEmpty ? 0 : monthlyData[currentIndex].count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = reviewList.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ReviewCell
        let data = monthlyData[currentIndex]
        let item = data[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = reviewList.frame.width
        return CGSize(width: width, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dayStoryboard = UIStoryboard.init(name: "Retrospection_m", bundle: nil)
        guard let popupVC = dayStoryboard.instantiateViewController(withIdentifier: "DayRetrospectionVC") as? DayRetrospectionVC else { return }
        let data = monthlyData[currentIndex][indexPath.row]
        popupVC.startDate = data.startDate
        
        if data.emotionMascot != 0 { popupVC.emotionMascot = data.emotionMascot }
        if !data.content.isEmpty { popupVC.lookBackContents = data.content }
        
        popupVC.lookBackTitle = data.title
        self.present(popupVC, animated: true, completion: nil)
    }
}

// MARK: - Server
extension ReviewHomeVC {
    //회고 데이터 가져오기
    func getRetrospection() {
        if NetworkState.isConnected() {
            // 네트워크 연결 시
            if let token = UserDefaults.standard.string(forKey: "UserToken") {
                APIService.shared.getRetrospection(token) { [self] result in
                    switch result {
                    case .success(let data):
                        retrospectionData = data
                        saveMonthly(data: data)
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
        // 보여주고있는 년도.달
        if(monthlyData.isEmpty){
            month.text = "\(currentYear).\(currentMonth)"
        }else{
            let arr = monthlyData[currentIndex][0].startDate.components(separatedBy: "-")
            month.text = "\(arr[0]).\(arr[1])";
        }
        
        
        //데이터 없는 경우 버튼 비활성화
        nextButton.isEnabled = currentIndex == monthlyData.count - 1 ? false : true
        prevButton.isEnabled = currentIndex == 0 ? false : true
        
    }
    
    func saveMonthly(data: [RetrospectionData]) {
        var temp: [RetrospectionData] = []
        guard data.count > 0,
              data[0].startDate.count >= 2 else { return }
        var standardMonth = String(data[0].startDate.dropLast(2))
        for day in data {
            let dayMonth = String(day.startDate.dropLast(2))
            if dayMonth == standardMonth {
                temp.append(day)
            } else {
                monthlyData.append(temp)
                temp = [day]
                standardMonth = String(day.startDate.dropLast(2))
            }
        }
        
        
        monthlyData.append(temp)
        currentIndex = monthlyData.count - 1
    }
}
