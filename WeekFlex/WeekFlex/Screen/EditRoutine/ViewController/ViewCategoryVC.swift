//
//  ViewCategoryVC.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/07/21.
//

import UIKit

class ViewCategoryVC: UIViewController {
    
    // MARK: - Variables
    
    let didDismissCreateCategoryVC: Notification.Name = Notification.Name("DidDismissCreateCategoryVC")
    var hideViewDelegate: HideViewProtocol?
    var saveCategoryDelegate: SaveCategoryProtocol?
    
    // View Model
    private var categoryListViewModel : CategoryListViewModel?
    
    // MARK: IBOutlet
    
    @IBOutlet var categoryTableView: UITableView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var modalBackgroundView: UIView!
    @IBOutlet var categoryView: UIView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var addCategoryButton: UIButton!
    
    @IBAction func addCategoryButton(_ sender: Any) {
        guard let createCategoryVC = self.storyboard?.instantiateViewController(identifier: "CreateCategoryVC") as? CreateCategoryVC else { return }
        createCategoryVC.modalTransitionStyle = .coverVertical
        createCategoryVC.modalPresentationStyle = .custom
        self.present(createCategoryVC, animated: true, completion: .none)
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setLayout()
        setDelegate()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        categoryView.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
    }
}

// MARK: - Extension for Functions

extension ViewCategoryVC {
    
    // MARK: Method
    @objc func didDismissCreateCategoryVC(_ noti: Notification) {
        setData()
    }
    
    @objc func backgroundTapped(sender: UITapGestureRecognizer) {
        self.hideViewDelegate?.hideViewProtocol()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: function

    func setLayout() {
        // Layout
        modalBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.0)
        modalBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped)))
        view.backgroundColor = UIColor(white: 0, alpha: 0.0)
        categoryView.backgroundColor = .white
        topConstraint.constant = 417/896*self.view.bounds.height
        
        headerLabel.setLabel(text: "카테고리", color: .black, font: .appleBold(size: 20), letterSpacing: -0.2)
        addCategoryButton.setImage(UIImage(named: "icon32PlusBasic"), for: .normal)
        
        // tableview
        categoryTableView.separatorStyle = .none
    }
    
    func setDelegate() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissCreateCategoryVC(_:)), name: didDismissCreateCategoryVC, object: nil)
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
    }
    
    func setData() {
        CategoryService().getCategories(token: "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJpZFwiOjMsXCJlbWFpbFwiOlwibWluaUBrYWthby5jb21cIn0ifQ.OR6VUYpvHealBtmiE97xjwT3Z16_TfMfLYiri1j05ek") { categoryList in
            if let categoryList = categoryList {
                self.categoryListViewModel = CategoryListViewModel(categories: categoryList)
            }
            DispatchQueue.main.async {
                self.categoryTableView.reloadData()
            }
        }
    }
}

// MARK: - TableView

extension ViewCategoryVC: UITableViewDataSource {
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
        // 전 뷰로 해당 카테고리 데이터를 넘긴다
        saveCategoryDelegate?.saveCategoryProtocol(savedCategory: categoryVM!.category)
        
        // 지금 뷰가 없어진다
        self.hideViewDelegate?.hideViewProtocol()
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ViewCategoryVC: UITableViewDelegate {
    
}
