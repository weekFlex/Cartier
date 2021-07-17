//
//  LeftAlignFlowLayout.swift
//  WeekFlex
//
//  Created by 김민희 on 2021/07/17.
//

import UIKit

class LeftAlignFlowLayout: UICollectionViewFlowLayout {
    // CollectionView 왼쪽 정렬을 위한 커스텀
    
    let cellSpacing: CGFloat = 10
    var updateCell: (CGFloat) -> Void = { _ in }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 10.0
        self.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        let attributes = super.layoutAttributesForElements(in: rect)
 
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        if let minY = attributes?.last?.frame.minY {
            // cell minY 전송하기
            
            let line = minY / 32
            updateCell(line)
        }
        return attributes
    }
}
