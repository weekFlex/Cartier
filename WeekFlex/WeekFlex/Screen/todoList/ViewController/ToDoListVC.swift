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
    private var routineList: [RoutineList] = []
    
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
        setRoutine()
        // Do any additional setup after loading the view.
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
        nextButton.tintColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
    }
    
    func setLabel() {
        
        explainLabel.text = "루틴에 추가할 할 일을 선택하세요"
        explainLabel.font = UIFont.appleRegular(size: 16)
        explainLabel.textColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        
        searchTextField.placeholder = "원하는 할 일을 찾을 수 있어요"
        searchTextField.returnKeyType = .done
        searchTextField.font = UIFont.appleRegular(size: 14)
        searchTextField.delegate = self
    }
    
    func setView() {
        
        textFieldView.backgroundColor = .gray
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        routineCollectionView.delegate = self
        routineCollectionView.dataSource = self
        
    }
    
    private func setRoutine() {
        
        let rountine1 = RoutineList(routineName: "원서 읽기", routineTime: "월, 수 10:00am-11:00am", pick: true)
        let rountine2 = RoutineList(routineName: "스피킹", routineTime: "화, 목 10:00am-1:00pm", pick: true)
        let rountine3 = RoutineList(routineName: "문제집 풀기", routineTime: "월, 수, 금", pick: false)
        routineList = [rountine1,rountine2,rountine3]
        
    }
}

extension ToDoListVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textFieldView.backgroundColor = .gray
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
            textFieldView.backgroundColor = .gray
        }
        return true
    }
}

extension ToDoListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                            indexPath: IndexPath) -> CGSize {
        
        if collectionView == categoryCollectionView {
            return CGSize(width: 50, height: collectionView.frame.height)
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
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoutineCell.identifier, for: indexPath) as? RoutineCell else { return UICollectionViewCell() }
            cell.set(routineList[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categoryViewModel.items.count
        } else {
            return routineList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            routineCollectionView.reloadData()
        }
    }
}


struct RoutineList {
    var name: String
    var time: String
    var check: Bool
    
    init(routineName: String, routineTime: String, pick: Bool) {
        self.name = routineName
        self.time = routineTime
        self.check = pick
    }
}
