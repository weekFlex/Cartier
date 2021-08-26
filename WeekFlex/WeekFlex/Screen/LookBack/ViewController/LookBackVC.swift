//
//  LookBackVC.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/08/26.
//

import UIKit

class LookBackVC: UIViewController {
    
    var week = ["월", "화", "수", "목", "금", "토", "일"]

    @IBOutlet weak var goalPercentLabel: UILabel!
    @IBOutlet weak var writeLookBackButton: UIButton!
    @IBOutlet weak var routineDateLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    
    @IBOutlet weak var weekStartCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        weekStartCollectionView.delegate = self
        weekStartCollectionView.dataSource = self
        
        // Do any additional setup after loading the view.
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
