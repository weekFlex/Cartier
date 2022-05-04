//
//  ManageCategoryVC.swift
//  WeekFlex
//
//  Created by Hailey on 2022/05/04.
//

import UIKit

class ManageCategoryVC: UIViewController {

    // MARK: Property
    private var categoryListViewModel : CategoryListViewModel?
    
    // MARK: @IBOutlet
    @IBOutlet weak var categoryTableView: UITableView!
    
    // MARK: @IBAction
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setData()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Function
    func setDelegate() {
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
    }
    
    func setData() {
        if let token = UserDefaults.standard.string(forKey: "UserToken") {
            CategoryService().getCategories(token: token) { categoryList in
                if let categoryList = categoryList {
                    self.categoryListViewModel = CategoryListViewModel(categories: categoryList)
                }
                DispatchQueue.main.async {
                    self.categoryTableView.reloadData()
                }
            }
        }
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension ManageCategoryVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
        return categoryListViewModel?.numberOfCategories ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryListCell.identifier,
                                                   for: indexPath)
                as? CategoryListCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        let categoryVM = categoryListViewModel?.categoryAtIndex(indexPath.row)
        guard let icon = categoryVM?.categoryColorImageName,
              let title = categoryVM?.title else { return cell }
        cell.configure(icon: icon, title: title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let categoryVM = categoryListViewModel?.categoryAtIndex(indexPath.row) else { return }
//        categoryVM.category
        // 전 뷰로 해당 카테고리 데이터를 넘긴다
    }
    
}
