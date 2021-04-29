//
//  EditPopUpVC.swift
//  WeekFlex
//
//  Created by dohan on 2021/04/14.
//

import Foundation
import UIKit

protocol EditPopUpDelegate: AnyObject {
    func didTabEdit(cellIndex: Int, viewIndex:Int)
    func didTabDelete(cellIndex: Int, viewIndex:Int)
}
class EditPopUpVC: UIViewController {
    
    var cellIndex: Int = 0
    var viewIndex: Int = 0
    var taskTitle: String = ""
    weak var delegate: EditPopUpDelegate?
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var taskLabel: UILabel!

    @IBAction func editButton(_ sender: Any) {
        delegate?.didTabEdit(cellIndex: cellIndex, viewIndex: viewIndex)
    }
    @IBAction func deleteButton(_ sender: Any) {
        delegate?.didTabDelete(cellIndex: cellIndex, viewIndex: viewIndex)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
}

extension EditPopUpVC {
    
    func setLayout(){
        self.popupView.layer.cornerRadius = 20
        self.taskLabel.text = taskTitle
    }
}
