//
//  LookBackVC.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/08/26.
//

import UIKit

class LookBackVC: UIViewController {
    
    // MARK: Variable Part
    
    var week = ["월", "화", "수", "목", "금", "토", "일"]
    var goalPercent: Int = 10   // 이번주 목표 달성률

    // MARK: IBOutlet
    
    @IBOutlet weak var goalPercentLabel: UILabel!
    @IBOutlet weak var writeLookBackButton: UIButton!
    @IBOutlet weak var routineDateLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var weekStartCollectionView: UICollectionView!
    
    // MARK: Life Cycle Part
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setViewStyle()
    }


}

// MARK: Extension

extension LookBackVC {
    
    func setViewStyle() {
        
        weekStartCollectionView.delegate = self
        weekStartCollectionView.dataSource = self
        
        routineDateLabel.setLabel(text: "11월 30일~12월 6일", color: .gray3, font: .appleMedium(size: 12))
        
        goalPercentLabel.text = "목표 달성률 \(goalPercent)%\n이번 주는 어땠나요?"
        
        let attrString = NSMutableAttributedString(string: goalPercentLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        goalPercentLabel.attributedText = attrString
        
        goalPercentLabel.font = .metroBold(size: 20)
        
        writeLookBackButton.setButton(text: "회고 작성하기 >", color: .gray4, font: .appleMedium(size: 10), backgroundColor: UIColor(red: 246.0 / 255.0, green: 247.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0))
        writeLookBackButton.setRounded(radius: 6)
        
    }
}


// MARK: UICollectionViewDelegateFlowLayout

extension LookBackVC: UICollectionViewDelegateFlowLayout {
    // CollectionView 크기 잡기
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 한 아이템의 크기
        
        return CGSize(width: collectionView.frame.width/7, height: 74/327 * collectionView.frame.width)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // 아이템간의 간격
        
        return 0
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // collectionView와 View 간의 간격
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
}

// MARK: UICollectionViewDataSource

extension LookBackVC: UICollectionViewDataSource {
    // CollectionView 데이터 넣기
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 7
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekStarCell.identifier, for: indexPath) as? WeekStarCell else {
            return UICollectionViewCell()
        }
        
        cell.dayLabel.text = week[indexPath.row]
        cell.starImage.image = UIImage(named: "icon-24-star-n\(indexPath.row)")
        
        return cell
        
        
    }
    
    
}
