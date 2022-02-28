//
//  CreateCategoryVC.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/07/21.
//

import UIKit

class CreateCategoryVC: UIViewController {
    
    // MARK: - Variables
    
    let didDismissCreateCategoryVC: Notification.Name = Notification.Name("DidDismissCreateCategoryVC")
    var hideViewDelegate: HideViewProtocol?
    var saveCategoryDelegate: SaveCategoryProtocol?
    var didViewDidLoad: Bool = false
    var isEditingMode: Bool = false // 카테고리편집 모드인지 확인
    var categoryName: String? // 편집으로 넘어왔을 때 필요
    var checkedID: Int? {
        didSet {
            if didViewDidLoad {
                if let ID = checkedID {
                    setCategoryImage(num: ID)
                }
                categoryCollectionView.reloadData()
                if categoryTitle.text?.count != 0 || categoryTitle.text != nil {
                    completeButton.isEnabled = true
                }
            }
        }
    }
    var checkedColor: Int?
    var categoryID: Int? // 편집을 하러 오면 ID 값이 있음, 편집 API 에서 필요함
    
    // View Model
    private var categoryListViewModel : CategoryListViewModel?
    
    // alert
    let alert = UIAlertController(title: "존재하는 카테고리", message: "이미 존재하는 카테고리 이름입니다.\n다른 이름을 입력해주세요.", preferredStyle: .alert)
    let cancel = UIAlertAction(title: "확인", style: .default, handler : nil)
    
    // MARK: IBOutlet
    
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var modalBackgroundView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var completeButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var categoryColorView: UIView!
    @IBOutlet var categoryTitle: UITextField!
    @IBOutlet var categoryColorImage: UIImageView!
    @IBOutlet var categoryColorImageLength: NSLayoutConstraint!
    @IBOutlet var categoryCollectionView: UICollectionView!
    @IBOutlet var deleteCateogyButton: UIButton!
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        if let token = UserDefaults.standard.string(forKey: "UserToken") ,
           let categoryID = categoryID {
                APIService.shared.deleteCategory(token, categoryID: categoryID){ result in
                    switch result {
                        
                    case .success(_):
                        print("삭제완료")
                        NotificationCenter.default.post(name: self.didDismissCreateCategoryVC, object: nil, userInfo: nil) // 전 뷰에서 데이터 로드를 다시 하게 만들기 위해 Notofication post!
                        self.dismiss(animated: true, completion: .none)
                        
                    case .failure(let error):
                        print("에러?", error)
                        self.present(self.alert,animated: false, completion: nil)
                    }
                }
            
        }
    }
    @IBAction func addCompleteButtonPressed(_ sender: Any) {
        if let colorID = checkedColor,
           let categoryTitle = categoryTitle.text {
            if let token = UserDefaults.standard.string(forKey: "UserToken") {
                if isEditingMode { // 편집 API
                    if let categoryID = categoryID {
                        APIService.shared.updateCategory(token, color: colorID, name: categoryTitle, categoryID: categoryID){ result in
                            switch result {
                                
                            case .success(_):
                                print("수정완료")
                                NotificationCenter.default.post(name: self.didDismissCreateCategoryVC, object: nil, userInfo: nil) // 전 뷰에서 데이터 로드를 다시 하게 만들기 위해 Notofication post!
                                self.dismiss(animated: true, completion: .none)
                                
                            case .failure(let error):
                                print("에러?", error)
                                self.present(self.alert,animated: false, completion: nil)
                            }
                        }
                    }
                    
                    
                } else { // 생성 API
                    APIService.shared.createCategory(token, color: colorID, name: categoryTitle){ result in
                        switch result {
                            
                        case .success(_):
                            NotificationCenter.default.post(name: self.didDismissCreateCategoryVC, object: nil, userInfo: nil) // 전 뷰에서 데이터 로드를 다시 하게 만들기 위해 Notofication post!
                            self.dismiss(animated: true, completion: .none)
                            
                        case .failure(_):
                            self.present(self.alert,animated: false, completion: nil)
                        }
                    }
                    
                }
                
            }
        }
    }
    @IBAction func cancleBtnDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldStartEditingBtnTapped(_ sender: Any) {
        self.categoryTitle.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isEditingMode { setEditingModeLayout() }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        didViewDidLoad = true
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
    
    func setEditingModeLayout() {
        let selectedIndexPath = IndexPath(row: checkedID! < 10 ? checkedID! - 1 : checkedID! - 4 , section: checkedID!/10)
        categoryCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: [])
        categoryCollectionView.delegate?.collectionView?(categoryCollectionView, didSelectItemAt: selectedIndexPath)
        //        print("select", checkedID! ,selectedIndexPath)
        headerLabel.setLabel(text: "카테고리 편집", color: .black, font: .appleMedium(size: 18))
        if let categoryName = categoryName {
            categoryTitle.text = categoryName
        }
        deleteCateogyButton.isHidden = false
    }
    
    func setLayout() {
        // alert
        alert.addAction(cancel)
        // background
        modalBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
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
        categoryTitle.font = .appleBold(size: 24)
        categoryTitle.adjustsFontSizeToFitWidth = true
        categoryTitle.minimumFontSize = 24
        categoryTitle.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        categoryTitle.delegate = self
        categoryColorImageLength.constant = 20/896*self.view.bounds.height
        // collectionView
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        // 카테고리 삭제 버튼은 일단 hidden
        deleteCateogyButton.isHidden = true
        deleteCateogyButton.backgroundColor = .black
        deleteCateogyButton.setButton(text: "카테고리 삭제하기", color: .white, font: .appleBold(size: 16), backgroundColor: .black)
        deleteCateogyButton.setRounded(radius: 3)
    }
    
    func setCategoryImage(num: Int) {
        switch num<10 {
        case true:
            checkedColor = num+1
            categoryColorImage.image = UIImage(named: "icon-24-star-n\(num+1)")
        case false:
            checkedColor = num-6
            categoryColorImage.image = UIImage(named: "icon-24-star-n\(num-6)")
        }
    }
}

// MARK: Method

extension CreateCategoryVC {
    
    @objc func backgroundTapped(sender: UITapGestureRecognizer) {
        self.hideViewDelegate?.hideViewProtocol()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let _ = checkedID {
            if textField.text?.count == 0 || textField.text == nil {
                // Text가 존재하지 않을 때 버튼 비활성화
                completeButton.isEnabled = false
            } else {
                completeButton.isEnabled = true
            }
        } else {
            completeButton.isEnabled = false
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

extension CreateCategoryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                        indexPath: IndexPath) -> CGSize {
        let sideLength = 40/896*self.view.bounds.height
        return CGSize(width: sideLength, height:sideLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: 0, height: 0)
        case 1:
            return CGSize(width: view.bounds.width, height: 1)
        default:
            assert(false)
        }
    }
    
}

extension CreateCategoryVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "reusableView", for: indexPath)
            headerView.backgroundColor = .gray1
            return headerView
        default:
            assert(false)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 12
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCategoryCollectionViewCell.identifier, for: indexPath) as? ColorCategoryCollectionViewCell else { return UICollectionViewCell() }
        let firstSectionColorList: [UIColor] = [.color1, .color2, .color3]
        let secondSectionColorList: [UIColor] = [.color04, .color05, .color06, .color07, .color08, .color09, .color10, .color11, .color12, .color13, .color14, .color15]
        switch indexPath.section {
        case 0:
            cell.backgroundColor = firstSectionColorList[indexPath.row]
        case 1:
            cell.backgroundColor = secondSectionColorList[indexPath.row]
        default:
            assert(true)
        }
        cell.setRounded(radius: nil)
        
        if let checkedID = checkedID {
            if checkedID < 10 { // section 1
                if  indexPath.section == 0 &&
                        indexPath.row == checkedID {
                    cell.checkImage.isHidden = false
                } else {
                    cell.checkImage.isHidden = true
                }
            } else { // section 2
                if  indexPath.section == 1 &&
                        indexPath.row == checkedID-10 {
                    cell.checkImage.isHidden = false
                } else {
                    cell.checkImage.isHidden = true
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // vm의 didset trigger
        // vm.checkedID = indexPath.row
        // vm.checkedID = indexPath.row + 10
        //        print("selected!! - delegate", indexPath)
        switch indexPath.section {
        case 0:
            checkedID = indexPath.row
        case 1:
            checkedID = indexPath.row+10
        default:
            return
        }
    }
}
