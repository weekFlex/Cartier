//
//  CreateCategoryVC.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/07/21.
//

import UIKit
import SnapKit

class CreateCategoryVC: UIViewController {

    // MARK: Enum
    enum CategoryState {
        case making
        case editing(CategoryData)
    }
    
    // MARK: Variables
    let didDismissCreateCategoryVC: Notification.Name = Notification.Name("DidDismissCreateCategoryVC")
    var hideViewDelegate: HideViewProtocol?
    var saveCategoryDelegate: SaveCategoryProtocol?
    var checkedColor: Int?
    var state: CategoryState = .making
    private var categoryViewModel: CategoryViewModel?
    var dismissAction : (() -> Void)?
    var checkCategory: IndexPath? {
        didSet {
            categoryCollectionView.reloadData()
            checkEnableComplete()
        }
    }
    private var categoryListViewModel : CategoryListViewModel?

    
    // MARK: - @IBOutlet
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

    // MARK: @IBAction
    @IBAction func addCompleteButtonPressed(_ sender: Any) {
        
        guard let categoryTitle = categoryTitle.text,
              let token = UserDefaults.standard.string(forKey: "UserToken") else {
            return
        }
        
        switch state {
        case .making:
            guard let colorID = checkedColor else { return }
            APIService.shared.createCategory(token, color: colorID, name: categoryTitle) { result in
                switch result {

                case .success(_):
                    NotificationCenter.default.post(name: self.didDismissCreateCategoryVC, object: nil, userInfo: nil) // 전 뷰에서 데이터 로드를 다시 하게 만들기 위해 Notofication post!
                    self.dismiss(animated: true, completion: .none)
                    
                case .failure(_):
                    self.showDupleAlert()
                }
            }
            
        case .editing(_):
            guard let categoryViewModel = categoryViewModel,
                 let dismissAction = self.dismissAction else { return }

            let title = categoryTitle == categoryViewModel.title ? nil : categoryTitle

            APIService.shared.updateCategory(token,
                                             color: checkedColor ?? 0,
                                             id: categoryViewModel.ID,
                                             name: title) { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                    }
                    dismissAction()
                case .failure(_):
                    self.showDupleAlert()
                }
            }
        }
        
    }
    @IBAction func cancleBtnDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldStartEditingBtnTapped(_ sender: Any) {
        categoryTitle.becomeFirstResponder()
    }

    // MARK: - Override Function
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        categoryColorView.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        categoryTitle.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 뷰 클릭 시 키보드 내리기
        view.endEditing(true)
    }
    
}

extension CreateCategoryVC {
    func setLayout() {
        
        // background
        view.backgroundColor = UIColor(white: 0, alpha: 0.0)
        modalBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                        action: #selector(backgroundTapped)))
        categoryColorView.backgroundColor = .white

        // header
        backButton.setImage(UIImage(named: "icon32CancleBlack"), for: .normal)
        backButton.setTitle("", for: .normal)
        completeButton.setImage(UIImage(named: "icon32CheckBlack"), for: .normal)
        completeButton.setTitle("", for: .normal)
        completeButton.isEnabled = false

        switch state {
        case .making:
            headerLabel.setLabel(text: "카테고리 추가", color: .black, font: .appleMedium(size: 18))
            modalBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.0)
        case .editing(let category):
            categoryViewModel = CategoryViewModel(category)
            headerLabel.setLabel(text: "카테고리 편집", color: .black, font: .appleMedium(size: 18))
            categoryTitle.text = categoryViewModel?.title
            categoryColorImage.image = UIImage(named: categoryViewModel?.categoryColorImageName ?? "icon-24-star-n")
            modalBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            guard let color = categoryViewModel?.categoryColor else { return }
            if color < 4 {
                checkCategory = IndexPath(row: color-1, section: 0)
            } else {
                checkCategory = IndexPath(row: color-4, section: 1)
            }
            removeButton()
        }
        topConstraint.constant = 40/896 * view.bounds.height
        
        // text field
        categoryTitle.borderStyle = .none
        categoryTitle.textAlignment = .center
        categoryTitle.font = .appleBold(size: 24)
        categoryTitle.adjustsFontSizeToFitWidth = true
        categoryTitle.minimumFontSize = 24
        categoryTitle.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                for: .editingChanged)
        categoryTitle.delegate = self
        categoryColorImageLength.constant = 20/896 * self.view.bounds.height

        // collectionView
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
}

// MARK: Method
extension CreateCategoryVC {

    func checkEnableComplete() {

        guard let title = categoryTitle.text,
                  title.count != 0 else {
            completeButton.isEnabled = false
            return
        }

        switch state {
        case .making:
            guard let checkCategory = checkCategory else {
                completeButton.isEnabled = false
                return
            }

            if checkCategory.section == 0 {
                checkedColor = checkCategory.row + 1
            } else {
                checkedColor = checkCategory.row + 4
            }

            completeButton.isEnabled = true

        case .editing(_):
            guard let checkCategory = checkCategory else {
                completeButton.isEnabled = false
                return
            }

            if checkCategory.section == 0 {
                checkedColor = checkCategory.row + 1
            } else {
                checkedColor = checkCategory.row + 4
            }

            guard let categoryViewModel = categoryViewModel else {
                return
            }
            if categoryViewModel.title == title &&
                categoryViewModel.categoryColor == checkedColor {
                completeButton.isEnabled = false
            } else {
                completeButton.isEnabled = true
            }
        }
    }
    
    @objc func backgroundTapped(sender: UITapGestureRecognizer) {
        self.hideViewDelegate?.hideViewProtocol()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkEnableComplete()
    }

    func showDupleAlert() {
        // alert
        let alert = UIAlertController(title: "존재하는 카테고리",
                                      message: "이미 존재하는 카테고리 이름입니다.\n다른 이름을 입력해주세요.",
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인",
                                   style: .default,
                                   handler : nil)

        alert.addAction(cancel)
        present(alert, animated: true)
    }

    @objc func showRemoveAlert() {
        guard let categoryViewModel = categoryViewModel else { return }
        // alert
        let alert = UIAlertController(title: nil,
                                      message: "카테고리에 포함된 \(categoryViewModel.title)이 모두 삭제됩니다.\n이대로 삭제를 진행할까요?",
                                      preferredStyle: .actionSheet)
        let remove = UIAlertAction(title: "삭제",
                                   style: .destructive) { (action) in
            self.removeButtonDidTap()
        }
        let cancel = UIAlertAction(title: "취소",
                                   style: .cancel,
                                   handler : nil)

        
        alert.addAction(remove)
        alert.addAction(cancel)
        present(alert, animated: true)
    }

    func removeButton() {
        let removeButton = UIButton()
        view.addSubview(removeButton)
        removeButton.setButton(text: "카테고리 삭제하기",
                               color: .white,
                               font: .appleBold(size: 16),
                               backgroundColor: .black)
        removeButton.setRounded(radius: 8)

        removeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.snp.bottom).offset(-33)
            $0.left.equalTo(self.view.snp.left).offset(24)
            $0.width.equalTo(self.view.snp.width).offset(-48)
            $0.height.equalTo(52)
        }
        removeButton.addTarget(self, action: #selector(showRemoveAlert), for: .touchUpInside)
    }

    func removeButtonDidTap() {
        guard let token = UserDefaults.standard.string(forKey: "UserToken"),
              let categoryViewModel = categoryViewModel,
              let dismissAction = dismissAction else { return }
        APIService.shared.deleteCategory(token,
                                         id: categoryViewModel.ID) { result in
            switch result {

            case .success(_):
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
                dismissAction()
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}


// MARK: UITextFieldDelegate
extension CreateCategoryVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CreateCategoryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideLength = 40/896 * self.view.bounds.height
        return CGSize(width: sideLength,
                      height:sideLength)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24,
                            left: 20,
                            bottom: 24,
                            right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: 0,
                          height: 0)
        case 1:
            return CGSize(width: view.bounds.width,
                          height: 1)
        default:
            assert(false)
        }
    }
    
}

// MARK: UICollectionViewDataSource
extension CreateCategoryVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "reusableView",
                                                                             for: indexPath)
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
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ColorCategoryCollectionViewCell.identifier,
            for: indexPath) as? ColorCategoryCollectionViewCell else {
            return UICollectionViewCell() }
        let firstSectionColorList: [UIColor] = [.color1, .color2, .color3]
        let secondSectionColorList: [UIColor] = [.color04, .color05, .color06, .color07, .color08, .color09,
                                                 .color10, .color11, .color12, .color13, .color14, .color15]

        cell.backgroundColor = (indexPath.section == 0) ? firstSectionColorList[indexPath.row] : secondSectionColorList[indexPath.row]
        cell.setRounded(radius: nil)
        
        guard let checkCategory = checkCategory else { return cell }
        cell.checkImage.isHidden = indexPath == checkCategory ? false : true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        checkCategory = indexPath
        switch indexPath.section {
        case 0:
            categoryColorImage.image = UIImage(named: "icon-24-star-n\(indexPath.row+1)")
        case 1:
            categoryColorImage.image = UIImage(named: "icon-24-star-n\(indexPath.row+4 )")
        default:
            break
        }

    }
}
