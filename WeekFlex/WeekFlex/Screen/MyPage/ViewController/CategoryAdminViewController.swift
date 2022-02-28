//
//  CategoryAdminViewController.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/08/27.
//

import UIKit

class CategoryAdminViewController: UIViewController {
    
    // View Model
    private var categoryListViewModel : CategoryListViewModel?
    
    // MARK: IBOutlet

    @IBOutlet var prevButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var categoryTableView: UITableView!
    
    @IBAction func prevButtonDidTap(_ sender: Any) {
        
    }
    let editRoutineStoryboard = UIStoryboard.init(name: "EditRoutine", bundle: nil)
    var createCategoryVC: CreateCategoryVC?
   
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        createCategoryVC = editRoutineStoryboard.instantiateViewController(identifier: "CreateCategoryVC") as CreateCategoryVC?
        setData()
        setLayout()
        setDelegate()
    }
    // MARK: function
    
    func setLayout() {
        // Layout
        view.backgroundColor = UIColor(white: 1, alpha: 1.0)
        headerLabel.setLabel(text: "카테고리 관리", color: .black, font: .appleBold(size: 20), letterSpacing: -0.2)
        prevButton.setImage(UIImage(named: "icon32BackBlack"), for: .normal)
        // tableview
        categoryTableView.separatorStyle = .none
    }
    
    
    func setDelegate() {
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
    }
    
    func setData() {
        if let token = UserDefaults.standard.string(forKey: "UserToken") {
            CategoryService().getCategories(token: token) { categoryList in
                print("get category", categoryList)
                if let categoryList = categoryList {
                    self.categoryListViewModel = CategoryListViewModel(categories: categoryList)
                }
                DispatchQueue.main.async {
                    print("reload")
                    self.categoryTableView.reloadData()
                }
            }
        }
    }
}

// MARK: - TableView

extension CategoryAdminViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryListViewModel?.numberOfCategories ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        let categoryVM = categoryListViewModel?.categoryAtIndex(indexPath.row)
        cell.selectionStyle = .none
        cell.categoryColor.image = UIImage(named: categoryVM?.categoryColorImageName ?? "icon-24-star-n0")
        cell.categoryTitle.text = categoryVM?.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryVM = categoryListViewModel?.categoryAtIndex(indexPath.row)
//        // 전 뷰로 해당 카테고리 데이터를 넘긴다
//        saveCategoryDelegate?.saveCategoryProtocol(savedCategory: categoryVM!.category)
//
//        // 지금 뷰가 없어진다
//        self.hideViewDelegate?.hideViewProtocol()
//        self.dismiss(animated: true, completion: nil)
        
        // 해당 카테고리 편집 뷰로 이동
        if let createCategoryVC = createCategoryVC {
            createCategoryVC.modalTransitionStyle = .coverVertical
            createCategoryVC.modalPresentationStyle = .custom
            createCategoryVC.checkedID = categoryVM?.category.color
            createCategoryVC.categoryName = categoryVM?.category.name
            createCategoryVC.categoryID = categoryVM?.category.id
            createCategoryVC.isEditingMode = true
            print("\(categoryVM?.categoryColorImageName) \(categoryVM?.category.color)")
            self.present(createCategoryVC, animated: true, completion: .none)
        }
       
    }
    
}

extension CategoryAdminViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
