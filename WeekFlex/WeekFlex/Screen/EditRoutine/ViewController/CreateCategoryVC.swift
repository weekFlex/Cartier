//
//  CreateCategoryVC.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/07/21.
//

import UIKit

class CreateCategoryVC: UIViewController {
    // MARK: - Variables

    var hideViewDelegate: HideViewProtocol?
    var saveCategoryDelegate: SaveCategoryProtocol?
    
    // View Model
    private var categoryListViewModel : CategoryListViewModel?
    
    // MARK: IBOutlet

    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var modalBackgroundView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var completeButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var categoryColorView: UIView!
    @IBOutlet var categoryTitle: UITextField!
    
    @IBOutlet var categoryCollectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        categoryColorView.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 이 뷰에 들어오자 마자 바로 키보드 띄우고 cursor 포커스 주기
        self.categoryTitle.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 뷰 클릭 시 키보드 내리기
        view.endEditing(true)
    }

}

extension CreateCategoryVC {
    func setLayout() {
        // background
        modalBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.0)
        view.backgroundColor = UIColor(white: 0, alpha: 0.0)
        modalBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped)))
        categoryColorView.backgroundColor = .white
        // header
        backButton.setImage(UIImage(named: "icon32CancleBlack"), for: .normal)
        completeButton.setImage(UIImage(named: "icon32CheckBlack"), for: .normal)
        completeButton.isEnabled = false
        headerLabel.setLabel(text: "카테고리 추가", color: .black, font: .appleMedium(size: 18))
        topConstraint.constant = 40/896*self.view.bounds.height
        
        // text field
        categoryTitle.borderStyle = .none
        categoryTitle.textAlignment = .center
        categoryTitle.font = .metroBold(size: 24)
        categoryTitle.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        categoryTitle.delegate = self
        
        // collectionView
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
}

// MARK: Method

extension CreateCategoryVC {
    
    @objc func backgroundTapped(sender: UITapGestureRecognizer) {
        self.hideViewDelegate?.hideViewProtocol()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.count == 0 || textField.text == nil {
            // Text가 존재하지 않을 때 버튼 비활성화
            completeButton.isEnabled = false
        } else {
            completeButton.isEnabled = true
            
        }
    }
    
}

// MARK: UITextFieldDelegate

extension CreateCategoryVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 리턴 키 클릭 시
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // textField 클릭하면 무조건 키보드 올라오게
        textField.becomeFirstResponder()
    }
}

extension CreateCategoryVC: UICollectionViewDelegate {
    
}

extension CreateCategoryVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCategoryCollectionViewCell.identifier, for: indexPath) as? ColorCategoryCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .blue
        cell.setRounded(radius: nil)
        
        return cell
    }
    
    
}
