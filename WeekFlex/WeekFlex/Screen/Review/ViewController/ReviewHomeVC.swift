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
    
    
    // MARK: IBOutlet
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var reviewList: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        reviewList.register(UINib(nibName: "ReviewCell", bundle: nil), forCellWithReuseIdentifier: "reviewCell")
        
    }
    
    func setLayout(){
        
    }
}

extension ReviewHomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewViewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = reviewList.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ReviewCell
        let reviewItemViewModel = reviewViewModel.items[indexPath.row]
        cell.configure(with: reviewItemViewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = reviewList.frame.width
        
        return CGSize(width: width, height: 160)
    }
    
    
}
