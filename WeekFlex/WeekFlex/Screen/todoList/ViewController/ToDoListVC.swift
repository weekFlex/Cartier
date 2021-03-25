//
//  ToDoListVC.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/03/21.
//

import UIKit

class ToDoListVC: UIViewController {
    
    // MARK: Variable Part
    
    var routineName: String?
    
    var selectedViewModel : SelectedCollectionViewCellViewModel = SelectedCollectionViewCellViewModel()
    var categoryViewModel : CategoryCollectionViewCellViewModel = CategoryCollectionViewCellViewModel()
    var todolistViewModel : ToDoListCollectionViewCellViewModel = ToDoListCollectionViewCellViewModel()
    
    // 검색 할 text
    var searchText: String? = nil
    
    // 카테고리의 첫번째가 항상 default로 보여지게 만들기 위한 변수
    var categoryIndex: Int = 0
    
    // MARK: IBOutlet
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var selectRoutineView: UIView!
    @IBOutlet weak var selectedCollectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    @IBOutlet weak var routineNameLabel: UILabel!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var textFieldView: UIView!
    
    @IBOutlet weak var routineCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            // 동적 사이즈를 주기 위해 estimatedItemSize 를 사용했다. 대략적인 셀의 크기를 먼저 조정한 후에 셀이 나중에 AutoLayout 될 때, 셀의 크기가 변경된다면 그 값이 다시 UICollectionViewFlowLayout에 전달되어 최종 사이즈가 결정되게 된다.
        }
    }
    
    // MARK: IBAction
    
    // MARK: Life Cycle Part
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        setLabel()
        setView()
        setDelegate()
        
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
        
        if let routineName = routineName {
            // 이전뷰에서 루틴 이름을 설정해서 받아 올 예정
            routineNameLabel.setLabel(text: routineName, color: .white, font: .metroBold(size: 24))
        } else {
            routineNameLabel.setLabel(text: "English Master :-)", color: .white, font: .metroBold(size: 24))
        }
        
        searchTextField.placeholder = "원하는 할 일을 찾을 수 있어요"
        searchTextField.returnKeyType = .done
        searchTextField.font = UIFont.appleRegular(size: 14)
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // TextField가 수정될 때 마다 실행
        
        emptyLabel.setLabel(text: "루틴에 추가할 할 일을 선택하세요", color: .gray2, font: .appleRegular(size: 16))

    }
    
    func setView() {
        
        self.view.backgroundColor = .white
        headerView.backgroundColor = .black
        
        // category 밑에 그림자 추가
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOffset = CGSize(width: 0,height: 6)
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 0.10
        shadowView.layer.shadowColor = UIColor.gray2.cgColor

        textFieldView.backgroundColor = .gray1
        
        selectRoutineView.backgroundColor = .clear
        selectedCollectionView.backgroundColor = .clear
    
        let layout = selectedCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        // 가로 스크롤 고정
    }
    
    func setDelegate() {
        
        searchTextField.delegate = self
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        routineCollectionView.delegate = self
        routineCollectionView.dataSource = self
        
        selectedCollectionView.delegate = self
        selectedCollectionView.dataSource = self
        
        // 첫번째 카테고리 선택을 default로 만듦
        categoryCollectionView.selectItem(at: [0,0], animated: true, scrollPosition: .right)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // TextField가 수정될 때 마다 실행 될 함수
        
        // 카테고리 선택을 취소
        categoryCollectionView.deselectItem(at: [0,categoryIndex], animated: false)
        
        if textField.text == "" {
            // 검색어 비워두기
            searchText = nil
            // 자동으로 첫번째 카테고리 선택하기
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
        
        if collectionView == selectedCollectionView {
            return CGSize(width: 300, height: self.selectRoutineView.frame.height)
        }
        else if collectionView == categoryCollectionView {
            return CGSize(width: 50, height: 50)
        }
        else {
            return CGSize(width: collectionView.frame.width-32, height: 52)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == selectedCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else if collectionView == categoryCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else {
            return UIEdgeInsets(top: 14, left: 16, bottom: 10, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == selectedCollectionView {
            return 8
        }
        else if collectionView == categoryCollectionView {
            return 0
        }
        else {
            return 9
        }
        
    }
    
}
extension ToDoListVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == selectedCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedRoutineCell.identifier, for: indexPath) as? SelectedRoutineCell else { return UICollectionViewCell() }
            let itemViewModel = selectedViewModel.items[indexPath.row]
            cell.configure(with: itemViewModel)
            return cell
        }
        
        else if collectionView == categoryCollectionView {
            
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
                
                if selectedViewModel.items.count > 0 {
                    for i in 0...selectedViewModel.items.count-1 {
                        if itemViewModel.listName == selectedViewModel.items[i].listName {
                            // 만약에 내가 선택한 루틴이라면?
                            cell.selected()
                            // 배경 컬러 주기
                            break
                        }
                    }
                }
                
            } else {
                // 검색중이 아니라면 ==> 카테고리를 선택해서 보고있다면
                
                let itemViewModel = todolistViewModel.items.filter { $0.category == CategoryCollectionViewCellViewModel().items[categoryIndex].categoryName }[indexPath.row]
                // 선택한 카테고리로 필터링
                cell.configure(with: itemViewModel)
                if selectedViewModel.items.count > 0 {
                    for i in 0...selectedViewModel.items.count-1 {
                        if itemViewModel.listName == selectedViewModel.items[i].listName {
                            // 만약에 내가 선택한 루틴이라면?
                            cell.selected()
                            // 배경 컬러주기
                            break
                        }
                    }
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if collectionView == selectedCollectionView {

            if selectedViewModel.items.count != 0 {
                emptyLabel.isHidden = true
                nextButton.isEnabled = true
                nextButton.tintColor = .white
                // 다음 버튼 활성화
                
            } else {
                
                emptyLabel.isHidden = false
                nextButton.isEnabled = false
                nextButton.tintColor = .gray4
                // 다음버튼 비활성화
                
            }
            return selectedViewModel.items.count
        }
        
        else if collectionView == categoryCollectionView {
            return categoryViewModel.items.count
        }
        
        else {
            if searchText != nil {
                // 검색중이라면?
                let itemViewModel = todolistViewModel.items.filter { $0.listName?.contains(searchText!) == true }
                return itemViewModel.count
                
            } else {
                // 검색중이 아니라면 ==> 카테고리를 선택해서 보고있다면
                let itemViewModel = todolistViewModel.items.filter { $0.category == CategoryCollectionViewCellViewModel().items[categoryIndex].categoryName }
                return itemViewModel.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == selectedCollectionView {
            // x 버튼 클릭 시 ( 선택 해제 )
            
            listItemRemoved(value: indexPath.row)
            selectedCollectionView.reloadData()
            routineCollectionView.reloadData()
        }
        
        else if collectionView == categoryCollectionView {
            
            categoryIndex = indexPath.row
            
            searchText = nil
            searchTextField.text = nil
            // 검색어가 있는 상태에서 카테고리를 선택했다면 검색어 제거
            
            routineCollectionView.reloadData()
        }
        
        else {
            
            let cells = collectionView.cellForItem(at: indexPath) as? RoutineCell
            
            if selectedViewModel.items.count > 0 {
                // selectedViewModel이 비어있다면?
                
                var check = false
                for i in 0...selectedViewModel.items.count-1 {
                    // 이미 추가 된 루틴인지 검사하는 과정이 필요 (중복 추가를 막기 위해)
                    if cells?.routineNameLabel.text == selectedViewModel.items[i].listName {
                        check = true
                        break
                    }
                }
                if check == false {
                    // 추가 안된 루틴이라면 -> 추가
                    
                    listItemAdded(value: (cells?.routineNameLabel.text)!)
                    selectedCollectionView.reloadData()
                    routineCollectionView.reloadData()
                }
                
            } else {
                // selectedViewModel이 비어있다면? -> 무조건 추가
                
                listItemAdded(value: (cells?.routineNameLabel.text)!)
                selectedCollectionView.reloadData()
                routineCollectionView.reloadData()
            }
            
        }
        
    }
}

extension ToDoListVC: SelectedItemViewDelegate {

    func listItemRemoved(value: Int) {
        // 리스트에서 지우기
        selectedViewModel.items.remove(at: value)
    }
    
    
    func listItemAdded(value: String) {
        // 리스트에 추가하기
        let item = SelectedCellItemViewModel(listName: value)
        selectedViewModel.items.insert(item, at: 0)
    }
    
}
