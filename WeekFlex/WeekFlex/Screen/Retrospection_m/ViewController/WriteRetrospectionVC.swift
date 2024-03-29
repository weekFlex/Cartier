//
//  WriteRetrospectionVC.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/10/12.
//

import UIKit
import Moya

class WriteRetrospectionVC: UIViewController {
    
    var titleImage: UIImage?
    var placeHolder: String = "이번 한 주에 대해 회고 내용을 작성해보세요!"
    var startDate: String?
    

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var buttonBackView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var contextTextView: UITextView!
    @IBOutlet weak var countingLabel: UILabel!
    
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeButtonDidTap(_ sender: Any) {
        
        guard let pvc = self.presentingViewController else { return }
        

        if NetworkState.isConnected() {
            // 네트워크 연결 시

            if let token = UserDefaults.standard.string(forKey: "UserToken"),
            let startDate = startDate {
                
                var context = contextTextView.text ?? ""
                if context == placeHolder {
                    context = ""
                }
                
                let title = titleTextField.text ?? ""

                
                APIService.shared.writeRetrospection(token, context, 0, startDate, title){ [self] result in
                    switch result {

                    case .success(_):
                        self.dismiss(animated: true, completion: {
                            pvc.dismiss(animated: true, completion: nil)
                            NotificationCenter.default.post(name: .reloadData, object: nil, userInfo: nil)
                        })

                    case .failure(let error):
                        print(error)

                    }
                }
            }
        } else {
            // 네트워크 미연결 팝업 띄우기

        }
        
    }
    
    @IBAction func editButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let titleImage = titleImage {
            characterImageView.image = titleImage.resizableImage(withCapInsets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12), resizingMode: .stretch)
        }
        
        characterImageView.backgroundColor = .bgSelected
        characterImageView.setRounded(radius: nil)
        
        buttonBackView.backgroundColor = .bgSelected
        buttonBackView.setRounded(radius: nil)
        editButton.setTitle("", for: .normal)
        editButton.backgroundColor = .white
        editButton.setRounded(radius: nil)
        
        closeButton.setTitle("", for: .normal)
        completeButton.setTitle("", for: .normal)
        completeButton.isEnabled = false
        
        titleTextField.font = .appleBold(size: 20)
        titleTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        titleTextField.delegate = self
        
        contextTextView.text = placeHolder
        contextTextView.textColor = .gray2
        contextTextView.font = UIFont.appleMedium(size: 14)
        contextTextView.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.titleTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 뷰 클릭 시 키보드 내리기
        view.endEditing(true)
    }


}

extension WriteRetrospectionVC {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // 검색할 때
        
        if let text = textField.text {
            if text == "" {
                completeButton.isEnabled = false
                completeButton.setImage(UIImage(named: "icon32CheckInactive"), for: .normal)
            } else {
                completeButton.isEnabled = true
                completeButton.setImage(UIImage(named: "icon32CheckBlack"), for: .normal)
            }
        }
        
    }
    
    
}

extension WriteRetrospectionVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            self.contextTextView.becomeFirstResponder()
        }
        
        return true
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

extension WriteRetrospectionVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeHolder
            textView.textColor = .gray2
        }
    }
    
}
