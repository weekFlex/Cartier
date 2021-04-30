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
    
    //MARK: Variable
    
    var cellIndex: Int = 0
    var viewIndex: Int = 0
    var taskTitle: String = ""
    weak var delegate: EditPopUpDelegate?
    
    //MARK: IBOutlet
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var taskLabel: UILabel!

    
    //MARK: IBAction
    
    @IBAction func editButton(_ sender: Any) {
        delegate?.didTabEdit(cellIndex: cellIndex, viewIndex: viewIndex)
    }
    @IBAction func deleteButton(_ sender: Any) {
        delegate?.didTabDelete(cellIndex: cellIndex, viewIndex: viewIndex)
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { super.touchesBegan(touches, with: event)
        if let touch = touches.first , touch.view == self.view { self.dismiss(animated: true, completion: nil) } }

}

extension EditPopUpVC {
    
    func setLayout(){
        self.popupView.layer.cornerRadius = 20
        self.taskLabel.text = taskTitle
    }
}
