//
//  MyPageHomeVC.swift
//  WeekFlex
//
//  Created by dohan on 2021/10/04.
//

import Foundation
import UIKit


class MyPageHomeVC: UIViewController {

    // MARK: - Property
    let sectionHeader: [String] = ["관리", "기타"]
    let settingArr: [String] = ["카테고리 관리", "할 일 관리"]
    let etcArr: [String] = ["로그아웃", "계정 탈퇴", "1:1 문의", "버전"]

    // MARK: - @IBOutlet
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var via: UILabel!
    @IBOutlet weak var myPageTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInfoData()
        setTableview()
    }
}

// MARK: - UI Function
extension MyPageHomeVC {
    private func setTableview() {
        myPageTableView.delegate = self
        myPageTableView.dataSource = self
        myPageTableView.separatorStyle = .none
    }
    private func setUserInfoData() {
        //이름, 프로필사진, 로그인 경로, 버젼 세팅
        if NetworkState.isConnected() { // 네트워크 연결 시
            if let token = UserDefaults.standard.string(forKey: "UserToken") {
                APIService.shared.getUserProfile(token) { [self] result in
                    switch result {
                    case .success(let data):
                        name.text = data.userName
                        switch data.signupType {
                        case "KAKAO":
                            via.text = "카카오톡으로 로그인 됨"
                        case "FACEBOOK":
                            via.text = "페이스북으로 로그인 됨"
                        default:
                            via.text = "로그인 정보 없음"
                        }
                    // 데이터 전달 후 다시 로드
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } else {
            // 네트워크 미연결 팝업 띄우기
            print("네트워크 미연결")
        }
    }
    private func showLogoutAlert() {
        let actionSheetController = UIAlertController(title: "로그아웃",
                                                      message: "로그아웃 하시겠습니까?",
                                                      preferredStyle: .alert)
        let logout = UIAlertAction(title: "로그아웃", style: .default, handler: { action in
            self.moveLoginView()
        })
        let cancel = UIAlertAction(title: "취소" , style: .cancel, handler: nil)
        actionSheetController.addAction(cancel)
        actionSheetController.addAction(logout)
        present(actionSheetController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension MyPageHomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return settingArr.count
        case 1:
            return etcArr.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageCell.identifier) as? MyPageCell else
        {
            return UITableViewCell()
        }
        switch indexPath.section {
        case 0:
            cell.setLayout(title: settingArr[indexPath.row])
        case 1 where indexPath.row == 3:
            cell.setLayout(title: etcArr[indexPath.row], version: "v1.0")
        default:
            cell.setLayout(title: etcArr[indexPath.row])
        }
        cell.selectionStyle = .none
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeader.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader[section]
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .gray3
        header.textLabel?.font = .appleBold(size: 14)
        header.textLabel?.frame = header.bounds
        header.textLabel?.textAlignment = .left
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: // 카테고리 관리
                moveCategoryEditView()
            case 1: // 할 일 관리
                moveTaskEditView()
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0: // 로그아웃
                showLogoutAlert()
            case 1: // 계정 탈퇴
                moveDeleteAccountView()
            case 2: // 1:1 문의
                break
            default:
                break
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension MyPageHomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
}

// MARK: - Move Another ViewController
extension MyPageHomeVC {
    private func moveLoginView() {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        guard let loginVC = storyboard.instantiateViewController(identifier: "LoginVC")
                as? LoginVC else { return }
        UIApplication.shared.windows.first?.replaceRootViewController(loginVC, animated: true) {
            UserDefaults.standard.removeObject(forKey: "UserToken")
        }
    }
    private func moveCategoryEditView() {
        let categoryStoryboard = UIStoryboard.init(name: "EditRoutine", bundle: nil)
        guard let nextVC = categoryStoryboard.instantiateViewController(withIdentifier: "ManageCategoryVC")
                as? ManageCategoryVC else { return }
        navigationController?.pushViewController(nextVC, animated: true)
    }
    private func moveTaskEditView() {
        let routineStoryboard = UIStoryboard.init(name: "AddRoutine", bundle: nil)
        guard let nextVC = routineStoryboard.instantiateViewController(withIdentifier: "SelectToDoVC")
                as? SelectToDoVC else { return }
        nextVC.routineName = "할 일 관리"
        nextVC.taskCase = .editing
        navigationController?.pushViewController(nextVC, animated: true)
    }
    private func moveDeleteAccountView() {
        let deleteStoryboard = UIStoryboard.init(name: "DeleteAccount", bundle: nil)
        guard let nextVC = deleteStoryboard.instantiateViewController(withIdentifier: "DeleteAccount")
                as? DeleteAccountVC else { return }
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
