//
//  SelectCharacterVC.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/10/09.
//

import UIKit

class SelectCharacterVC: UIViewController {

    
    var icon = [("good","꽤 괜찮았어요"),("merong","열심히 놀았어요"),("yaho","뿌듯해요"),("sad","후회해요"),("angry","화가 났어요"),("bad","아쉬웠어요"),("kiki-disable","최고였어요"),("pissed-disable","아찔했어요"),("crazy-disable","정신 없었어요"),("iku-disable","미래의 나에게!"),("sowhat-disable","눈막귀막"),("vomit-disable","너무 힘들었어요")]
    var nextImage: UIImage?
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var iconCollectionView: UICollectionView!
    
    // MARK: - IBAction
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
    
        guard let popUpVC =
                storyboard?.instantiateViewController(identifier: "WriteLookBackVC") as? WriteLookBackVC else {return}
        
        if let nextImage = nextImage {
            popUpVC.titleImage = nextImage
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
        
        cell.configure(image: icon[indexPath.row].0, ment: icon[indexPath.row].1)
        cell.index = indexPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        nextButton.isEnabled = true
        nextButton.setTitleColor(.black, for: .normal)
        nextImage = UIImage(named: "Character/character-80-\(icon[indexPath.row].0)")
    }
    
    
    
}
