//
//  WaterfallLayout.swift
//  YZCLive
//
//  Created by Jason on 2018/1/8.
//  Copyright © 2018年 叶志成. All rights reserved.
//

import UIKit

@objc protocol WaterfallLayoutDataSource : class {
    func waterfallLayout(_ layout : WaterfallLayout, indexPath : IndexPath) -> CGFloat
    @objc optional func numberOfColsInWaterfallLayout(_ layout : WaterfallLayout) -> Int
}

class WaterfallLayout: UICollectionViewFlowLayout {
    
    // MARK: 对外提供属性
    weak var dataSource : WaterfallLayoutDataSource?
    
    // MARK: 私有属性
    fileprivate lazy var attrsArray : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate var totalHeight : CGFloat = 0
    fileprivate lazy var colHeights : [CGFloat] = {
        let cols = self.dataSource?.numberOfColsInWaterfallLayout?(self) ?? 2
        var colHeights = Array(repeating: self.sectionInset.top, count: cols)
        return colHeights
    }()
    fileprivate var maxH : CGFloat = 0
    fileprivate var startIndex = 0
}


extension WaterfallLayout {
    
    override func prepare() {
        super.prepare()
        
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        let cols = dataSource?.numberOfColsInWaterfallLayout?(self) ?? 2
        let itemW = (collectionView!.bounds.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing) / CGFloat(cols)
        
        for i in startIndex..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            guard let height = dataSource?.waterfallLayout(self, indexPath: indexPath) else {
                fatalError("请设置数据源,并且实现对应的数据源方法")
            }
            
            var minH = colHeights.min()!
            let index = colHeights.index(of: minH)!
            minH = minH + height + minimumLineSpacing
            colHeights[index] = minH
            
            attrs.frame = CGRect(x: self.sectionInset.left + (self.minimumInteritemSpacing + itemW) * CGFloat(index), y: minH - height - self.minimumLineSpacing, width: itemW, height: height)
            attrsArray.append(attrs)
        }
        maxH = colHeights.max()!
        startIndex = itemCount
    }
}

extension WaterfallLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: maxH + sectionInset.bottom - minimumLineSpacing)
    }
}

