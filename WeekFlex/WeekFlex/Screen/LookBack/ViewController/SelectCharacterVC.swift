//
//  SelectCharacterVC.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/10/09.
//

import UIKit

class SelectCharacterVC: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var iconCollectionView: UICollectionView!
    
    // MARK: - IBAction
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
    
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()

    }
    

}

// MARK: - Extension

extension SelectCharacterVC {
    
    // MARK: - Set Style Function
    
    func setView() {
        iconCollectionView.delegate = self
        iconCollectionView.dataSource = self
        
        nextButton.setButton(text: "다음", color: .gray3, font: .appleMedium(size: 16))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SelectCharacterVC: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - UICollectionViewDataSource

extension SelectCharacterVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
    
}
