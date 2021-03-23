//
//  ToDoListVC.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/03/21.
//

import UIKit

class ToDoListVC: UIViewController {
    
    // MARK: Variable Part
    
    var categoryViewModel : CategoryCollectionViewCellViewModel = CategoryCollectionViewCellViewModel()
    var todolistViewModel : ToDoListCollectionViewCellViewModel = ToDoListCollectionViewCellViewModel()
    
    // 검색 할 text
    var searchText: String? = nil
    
    // 카테고리의 첫번째가 항상 default로 보여지게 만들기 위한 변수
    var categoryIndex: Int = 0
    
    // MARK: IBOutlet
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var routineNameLabel: UILabel!
    @IBOutlet weak var explainLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var textFieldView: UIView!
    
    @IBOutlet weak var routineCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    // MARK: IBAction
    
    // MARK: Life Cycle Part
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        setLabel()
        setView()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 뷰 클릭 시 키보드 내리기
        view.endEditing(true)
    }
    
    
}

// MARK: Extension

extension ToDoListVC {
    
    // MARK: Function
    
    func setButton() {
        
        backButton.setImage(UIImage(named: "icon32BackWhite"), for: .normal)
        backButton.tintColor = .white
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.titleLabel?.font = UIFont.appleMedium(size: 16)
        nextButton.tintColor = UIColor.gray4
    }
    
    func setLabel() {
        
        routineNameLabel.setLabel(text: "English Master :-)", color: .white, font: .metroBold(size: 24))
        
        explainLabel.setLabel(text: "루틴에 추가할 할 일을 선택하세요", color: .gray2, font: UIFont.appleRegular(size: 16))
        
        searchTextField.placeholder = "원하는 할 일을 찾을 수 있어요"
        searchTextField.returnKeyType = .done
        searchTextField.font = UIFont.appleRegular(size: 14)
        textFieldView.backgroundColor = .gray1
        searchTextField.delegate = self
    }
    
    func setView() {

        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        // 첫번째 카테고리 선택을 default로 만듦
        categoryCollectionView.selectItem(at: [0,0], animated: false, scrollPosition: .right)
        
        routineCollectionView.delegate = self
        routineCollectionView.dataSource = self
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // TextField가 수정될 때 마다 실행
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // TextField가 수정될 때 마다 실행 될 함수
        
        // 카테고리 선택을 취소
        categoryCollectionView.deselectItem(at: [0,categoryIndex], animated: false)
        
        if textField.text == "" {
            searchText = nil
            categoryCollectionView.selectItem(at: [0,0], animated: false, scrollPosition: .right)
        } else {
            searchText = textField.text
        }
        routineCollectionView.reloadData()
    }
    
}

extension ToDoListVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textFieldView.backgroundColor = .gray1
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldView.backgroundColor = .black
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
        } else {
            textField.placeholder = "원하는 할 일을 찾을 수 있어요"
            textFieldView.backgroundColor = .gray1
        }
        return true
    }
}

extension ToDoListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                            indexPath: IndexPath) -> CGSize {
        
        if collectionView == categoryCollectionView {
            return CGSize(width: 50, height: 50)
        } else {
            return CGSize(width: collectionView.frame.width-32, height: 52)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == categoryCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 24, left: 16, bottom: 10, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == categoryCollectionView {
            return 0
        } else {
            return 9
        }
        
    }
    
}
extension ToDoListVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
            let itemViewModel = categoryViewModel.items[indexPath.row]
            cell.configure(with: itemViewModel)
            return cell
            
        }
        
        else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoutineCell.identifier, for: indexPath) as? RoutineCell else { return UICollectionViewCell() }
            
            if searchText != nil {
                // 검색중이라면?
                
                let itemViewModel = todolistViewModel.items.filter { $0.listName?.contains(searchText!) == true }[indexPath.row]
                // 검색 단어로 필터링
                
                cell.configure(with: itemViewModel)
            } else {
                // 검색중이 아니라면 == 카테고리를 선택해서 보고있다면
                
                let itemViewModel = todolistViewModel.items.filter { $0.category == CategoryCollectionViewCellViewModel().items[categoryIndex].categoryName }[indexPath.row]
                // 선택한 카테고리로 필터링
                cell.configure(with: itemViewModel)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == categoryCollectionView {
            return categoryViewModel.items.count
        }
        
        else {
            if searchText != nil {
                // 검색중이라면?
                let itemViewModel = todolistViewModel.items.filter { $0.listName?.contains(searchText!) == true }
                return itemViewModel.count
                
            } else {
                // 검색중이 아니라면 == 카테고리를 선택해서 보고있다면
                let itemViewModel = todolistViewModel.items.filter { $0.category == CategoryCollectionViewCellViewModel().items[categoryIndex].categoryName }
                return itemViewModel.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            
            categoryIndex = indexPath.row
            
            searchText = nil
            searchTextField.text = nil
            // 검색어가 있는 상태에서 카테고리를 선택했다면 검색어 제거
            
            routineCollectionView.reloadData()
        }
    }
}
