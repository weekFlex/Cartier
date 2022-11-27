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
        myPageTableView.delegate = self
        myPageTableView.dataSource = self
        myPageTableView.separatorStyle = .none
    }

    // MARK: - Network
    func setUserInfoData() {
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
