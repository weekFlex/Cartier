//
//  LookBackVC.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/08/26.
//

import UIKit

class LookBackVC: UIViewController {
    
    // MARK: Variable Part
    
    var week = ["월", "화", "수", "목", "금", "토", "일"]
    var goalPercent: Int = 10   // 이번주 목표 달성률
    var nick: String = "민희" // 닉네임
    var lookBackWrite: Bool = false // 회고 썼는지 안썻는지
    var lookBackTitle: String = "최대글자수최대글자수최대" // 회고제목
    var lookBackContents: String = "원래는 영어를 완벽하게 마스터하려고 했는데 인강으로 해서 그런지 결국 작심삼일...해버렸다. 토익 이거 얼마짜리인데 벌써 이러면 어떡하냐 ㅜ 기출문제집이 너무 아까워지고 있다. 토익 이제 한달 남았는데 제발 다음주부터는 열심히 하자 나 자신... 아 그래도 정해둔 책은 다 읽어서 다행이다. 영어 제발 하자~! 민트초코 맛있음" // 회고 내용

    // MARK: IBOutlet
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var goalPercentLabel: UILabel! {
        didSet {
            goalPercentLabel.text = "목표 달성률 \(goalPercent)%\n이번 주는 어땠나요?"
            let attrString = NSMutableAttributedString(string: goalPercentLabel.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            goalPercentLabel.attributedText = attrString
            goalPercentLabel.font = .metroBold(size: 20)
        }
    }
    @IBOutlet weak var writeLookBackButton: UIButton!
    @IBOutlet weak var routineDateLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var weekStartCollectionView: UICollectionView!
    @IBOutlet weak var categoryStarCollectionView: UICollectionView!
    @IBOutlet weak var categoryStarCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var routineResultLabel: UILabel! {
        didSet {
            routineResultLabel.text = "1개의 루틴 성공 *-*\n3개의 루틴에 도전했어요"
            routineResultLabel.numberOfLines = 0
            let attrString = NSMutableAttributedString(string: routineResultLabel.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            routineResultLabel.attributedText = attrString
            routineResultLabel.font = .appleBold(size: 20)
        }
    }
    
    @IBOutlet weak var routineStarCollectionView: UICollectionView!
    @IBOutlet weak var routineStarCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var nickTopView: UIView!
    
    lazy var editButton: UIButton = {
        
        let button = UIButton()
        
        button.setButton(text: "수정하기", color: .gray3, font: .appleMedium(size: 12))
        button.backgroundColor = nil
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 24).isActive = true
        
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.setLabel(text: "\(lookBackTitle)", color: .black, font: .appleBold(size: 16))
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
//        label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 24).isActive = true
        return label
    }()
    
    lazy var contentsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setLabel(text: "\(lookBackContents)", color: .black, font: .appleMedium(size: 13))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var writeButton: UIButton = {
        let button = UIButton()
        button.setButton(text: "회고 작성하기", color: .white, font: .appleBold(size: 16), backgroundColor: .black)
        button.setRounded(radius: 6)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: Life Cycle Part
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setViewStyle()
        if lookBackWrite {
            // 회고를 썼다면?
      
            view.addSubview(titleLabel)
            nickLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = false
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 24).isActive = true
            titleLabel.topAnchor.constraint(equalTo: nickLabel.bottomAnchor, constant: 32).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 20).isActive = true
        } else {
            // 회고 작성 전
            
            view.addSubview(contentsLabel)
            view.addSubview(writeButton)
            
            contentsLabel.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor, constant: 24).isActive = true
            contentsLabel.trailingAnchor.constraint(equalTo: self.mainView.trailingAnchor, constant: 24).isActive = true
            contentsLabel.setLabel(text: "아직 회고를 작성하지 않았어요", color: .gray3, font: .appleBold(size: 16))
            contentsLabel.topAnchor.constraint(equalTo: nickLabel.bottomAnchor, constant: 32).isActive = true
            writeButton.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor, constant: 24).isActive = true
            writeButton.trailingAnchor.constraint(equalTo: self.mainView.trailingAnchor, constant: 24).isActive = true
            writeButton.widthAnchor.constraint(equalTo: self.mainView.widthAnchor, multiplier: 327/375).isActive = true
            writeButton.heightAnchor.constraint(equalTo: writeButton.widthAnchor, multiplier: 52/327).isActive = true
            writeButton.topAnchor.constraint(equalTo: contentsLabel.bottomAnchor, constant: 16).isActive = true
            writeButton.bottomAnchor.constraint(equalTo: self.mainView.bottomAnchor, constant: -80).isActive = true
            
        }
    }

    override func viewWillLayoutSubviews() {
        titleImageView.setRounded(radius: nil)
//        contentsLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 80).isActive = true
    }

}

// MARK: Extension

extension LookBackVC {
    
    func setViewStyle() {
        
        weekStartCollectionView.delegate = self
        weekStartCollectionView.dataSource = self
        weekStartCollectionView.setRounded(radius: 3)
        
        categoryStarCollectionView.delegate = self
        categoryStarCollectionView.dataSource = self
        
        routineStarCollectionView.delegate = self
        routineStarCollectionView.dataSource = self
        
        routineDateLabel.setLabel(text: "11월 30일~12월 6일", color: .gray3, font: .appleMedium(size: 12))
        
        
        writeLookBackButton.setButton(text: "회고 작성하기 >", color: .gray4, font: .appleMedium(size: 10), backgroundColor: UIColor(red: 246.0 / 255.0, green: 247.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0))
        writeLookBackButton.setRounded(radius: 6)
        
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.image = UIImage(named: "Character/character-80-sowhat-disable")?.resizableImage(withCapInsets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12), resizingMode: .stretch)
        titleImageView.backgroundColor = .bgSelected
        
        nickLabel.setLabel(text: "\(nick)님의 기록", color: .black, font: .appleBold(size: 20))
    }
}


// MARK: UICollectionViewDelegateFlowLayout

extension LookBackVC: UICollectionViewDelegateFlowLayout {
    // CollectionView 크기 잡기
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 한 아이템의 크기
        
        if collectionView == weekStartCollectionView {
            return CGSize(width: collectionView.frame.width/7, height: 74/327 * collectionView.frame.width)
        } else if collectionView == categoryStarCollectionView {
            return CGSize(width: collectionView.frame.width, height: 24)
        } else {
            return CGSize(width: collectionView.frame.width, height: 62/328 * collectionView.frame.width)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // 아이템간의 간격
        
        if collectionView == weekStartCollectionView {
            return 0
        } else if collectionView == categoryStarCollectionView {
            return 0
        } else {
            return 0
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == weekStartCollectionView {
            return 0
        } else if collectionView == categoryStarCollectionView {
            return 28
        } else {
            return 7
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // collectionView와 View 간의 간격
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
}

// MARK: UICollectionViewDataSource

extension LookBackVC: UICollectionViewDataSource {
    // CollectionView 데이터 넣기
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == weekStartCollectionView {
            return 7
        } else if collectionView == categoryStarCollectionView  {
            
            let count = 5
            categoryStarCollectionViewHeight.constant = CGFloat(24 * count + (28*(count-1)))
            return count
            
        } else {
            let count = 3
            let height: CGFloat = 62/328 * collectionView.frame.width * CGFloat(count)
            routineStarCollectionViewHeight.constant =  height + CGFloat((8*(count-1)))
            return count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == weekStartCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekStarCell.identifier, for: indexPath) as? WeekStarCell else {
                return UICollectionViewCell()
            }
            
            cell.dayLabel.text = week[indexPath.row]
            cell.starImage.image = UIImage(named: "icon-24-star-n\(indexPath.row)")
            
            return cell
            
        } else if collectionView == categoryStarCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryStarCell.identifier, for: indexPath) as? CategoryStarCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(image: "icon-24-star-n4", category: "운동", percent: 25)
            
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoutineStarCell.identifier, for: indexPath) as? RoutineStarCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(image: "icon-24-star-n4", routine: "Design Master", percent: 80)
            
            return cell
        }
        
        
        
    }
    
    
}
