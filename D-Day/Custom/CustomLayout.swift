//
//  CustomLayout.swift
//  D-Day
//
//  Created by hana on 2023/06/15.
//

import UIKit

protocol CustomLayoutDelegate: AnyObject {
    //높이
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat
    func numberOfItemsInCollectionView() -> Int
}

class CustomLayout: UICollectionViewLayout {
    var delegate: CustomLayoutDelegate?
    
    private var numberOfColumns: Int = 2
    private var cellPadding: CGFloat = 0
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = self.collectionView else {
                return 0
        }
        //???
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    //layout 업데이트
    override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        cache.removeAll()

        // xOffset - [0, screen_width/2]
        let columnWidth: CGFloat = contentWidth / CGFloat(numberOfColumns)
        let xOffset: [CGFloat] = [0, columnWidth]
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        let numberOfItems = delegate?.numberOfItemsInCollectionView() ?? 0
        
        // yOffset - [0, 0]
        var currentColumn = 0
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            //collectionViewController에서 설정한 image 높이
            let imageHeight = delegate?.collectionView(collectionView, heightForImageAtIndexPath: indexPath) ?? 0
            let height = cellPadding * 2 + imageHeight
            let frame = CGRect(x: xOffset[currentColumn], y: yOffset[currentColumn], width: columnWidth, height: height)
            //insetBy - 원본frame 대비 dx 만큼 작은 frame 반환
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            // cache 저장
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache += [attributes]

            // 새로 계산된 항목의 프레임을 설명하도록 확장.....
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[currentColumn] += height

            // 다음 항목이 다음 열에 배치되도록 설정
            currentColumn += currentColumn < (numberOfColumns - 1) ? 1 : -currentColumn
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { rect.intersects( $0.frame) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
