//
//  WriteLookBackVC.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/10/12.
//

import UIKit
import Moya

class WriteLookBackVC: UIViewController {
    
    var titleImage: UIImage = Image(imageLiteralResourceName: "Character/character-80-angry")
    

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var buttonBackView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var contextTextView: UITextView!
    @IBOutlet weak var countingLabel: UILabel!
    
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
    
    }
    
    @IBAction func completeButtonDidTap(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        characterImageView.image = titleImage.resizableImage(withCapInsets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12), resizingMode: .stretch)
        characterImageView.backgroundColor = .bgSelected
        characterImageView.setRounded(radius: nil)
        
        buttonBackView.backgroundColor = .bgSelected
        buttonBackView.setRounded(radius: nil)
        editButton.setTitle("", for: .normal)
        editButton.backgroundColor = .white
        editButton.setRounded(radius: nil)
        
        closeButton.setTitle("", for: .normal)
        completeButton.setTitle("", for: .normal)
        
        titleTextField.font = .appleBold(size: 20)
    }
    


}
