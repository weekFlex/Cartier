//
//  ViewCategoryVC.swift
//  WeekFlex
//
//  Created by 선민승 on 2021/07/21.
//

import UIKit

class ViewCategoryVC: UIViewController {
    
    // MARK: - Variables

    @IBOutlet var categoryTableView: UITableView!
    var hideViewDelegate: HideViewProtocol?
    // View Model
    private var categoryListViewModel : CategoryListViewModel!
    
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var modalBackgroundView: UIView!
    @IBOutlet var categoryView: UIView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var addCategoryButton: UIButton!
    
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
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
    }
    
    func setData() {
        categoryListViewModel = CategoryListViewModel(categories: [CategoryDataWithoutID(name: "첫번째 루틴", color: 1), CategoryDataWithoutID(name: "두번째 루틴", color: 2)])
    }
}

// MARK: - TableView

extension ViewCategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryListViewModel.numberOfCategories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        let categoryVM = categoryListViewModel.categoryAtIndex(indexPath.row)
        cell.categoryColor.image = UIImage(named: categoryVM.categoryColorImageName)
        cell.categoryTitle.text = categoryVM.title
        return cell
    }
}

extension ViewCategoryVC: UITableViewDelegate {
    
}
