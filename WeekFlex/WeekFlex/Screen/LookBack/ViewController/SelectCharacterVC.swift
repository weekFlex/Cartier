//
//  SelectCharacterVC.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/10/09.
//

import UIKit

class SelectCharacterVC: UIViewController {
    
    var nextImage: UIImage?
    var startDate: String?
    let myDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var iconCollectionView: UICollectionView!
    
    // MARK: - IBAction
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
    
        guard let popUpVC =
                storyboard?.instantiateViewController(identifier: "WriteLookBackVC") as? WriteLookBackVC else {return}
        
        if let nextImage = nextImage,
           let startDate = startDate {
            popUpVC.titleImage = nextImage
            popUpVC.startDate = startDate
        }
        
        self.present(popUpVC, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        iconCollectionView.backgroundColor = .white
        iconCollectionView.delegate = self
        iconCollectionView.dataSource = self
        
        closeButton.setTitle("", for: .normal)
        
        nextButton.isEnabled = false
        nextButton.setButton(text: "다음", color: .gray3, font: .appleMedium(size: 16))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SelectCharacterVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width-28
        return CGSize(width: width/3, height: width/3 + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // collectionView와 View 간의 간격
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
}

// MARK: - UICollectionViewDataSource

extension SelectCharacterVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectIconCell.identifier, for: indexPath) as? SelectIconCell else {
            return UICollectionViewCell()
        }
        
        if let array = myDelegate?.emotionMascot {
            cell.configure(image: array[indexPath.row].0, ment: array[indexPath.row].1)
        }
        
        cell.index = indexPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let array = myDelegate?.emotionMascot {
            nextImage = UIImage(named: "Character/character-80-\(array[indexPath.row].0)")
        }
        
        nextButton.isEnabled = true
        nextButton.setTitleColor(.black, for: .normal)
        
    }
    
    
    
}
