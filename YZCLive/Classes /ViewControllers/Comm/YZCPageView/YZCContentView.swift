//
//  YZCContentView.swift
//  YZCPageView
//
//  Created by 叶志成 on 2018/1/7.
//  Copyright © 2018年 叶志成. All rights reserved.
//

import UIKit

@objc protocol YZCContentViewDelegate: class {
    func contentView(_ contentView: YZCContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
    @objc optional func contentViewEndScroll(_ contentView: YZCContentView)
}

private let kContentCellID = "kContentCellID"

class YZCContentView: UIView {
    
    weak var delegate: YZCContentViewDelegate?
    
    fileprivate var childVcs: [UIViewController]!
    fileprivate weak var parentVc: UIViewController!
    fileprivate var isForBidScrollDelegate: Bool = false
    fileprivate var startOffsetX: CGFloat = 0
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.backgroundColor = UIColor.clear
        
        return collectionView
        
    }()
    
    init(frame: CGRect, childVcs: [UIViewController], parentViewContoller: UIViewController) {
        super.init(frame: frame)
        
        self.childVcs = childVcs
        self.parentVc = parentViewContoller
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YZCContentView {
    func setUpUI() {
        for vc in childVcs {
            parentVc.addChildViewController(vc)
        }
        
        addSubview(collectionView)
    }
}

 //MARK: - UICollectionViewDelegate
extension YZCContentView : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForBidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isForBidScrollDelegate { return } //判断是否是点击事件
        
        var progress: CGFloat = 0
        var soucreIndex: Int = 0
        var targetIdnex: Int = 0
        
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        
        if currentOffsetX > startOffsetX { //左滑
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            soucreIndex = Int(currentOffsetX / scrollViewW)
            
            targetIdnex = soucreIndex + 1
            if targetIdnex >= childVcs.count {
                progress = 1
                targetIdnex = soucreIndex
            }
            
            //如果完全滑动过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIdnex = soucreIndex
            }
        } else { //右滑
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            targetIdnex = Int(currentOffsetX / scrollViewW)
            soucreIndex = targetIdnex + 1
            
            if soucreIndex >= childVcs.count {
                soucreIndex = childVcs.count - 1
            }
        }
        
        delegate?.contentView(self, progress: progress, sourceIndex: soucreIndex, targetIndex: targetIdnex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.contentViewEndScroll?(self)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            delegate?.contentViewEndScroll?(self)
        }
    }
}

 //MARK: - UICollectionViewDelegate
extension YZCContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}

 //MARK: - 对外方法
extension YZCContentView {
    func setCurrentIndex(_ currentIndex: Int) {
        isForBidScrollDelegate = true
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated:false)
    }
}



