//
//  YZCPageCollectionView.swift
//  YZCPageView
//
//  Created by 叶志成 on 2018/1/7.
//  Copyright © 2018年 叶志成. All rights reserved.
//

import UIKit

protocol YZCPageCollectionViewDataSource: class {
    func numberOfSections(in pageCollectionView: YZCPageCollectionView) -> Int
    func pageCollectionView(_ collectionView: YZCPageCollectionView, numberOfItemsInSection section: Int) -> Int
    func pageCollectionView(_ pageCollectionView: YZCPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

class YZCPageCollectionView: UIView {

    weak var dataSource: YZCPageCollectionViewDataSource?
    
    fileprivate var titles: [String]
    fileprivate var isTitleInTop: Bool
    fileprivate var style: YZCTitleStyle
    fileprivate var layout: YZCPageCollectViewLayout
    fileprivate var collectionView: UICollectionView!
    fileprivate var pageControl: UIPageControl!
    fileprivate var titleView: YZCTitleView!
    fileprivate var sourceIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    init(frame: CGRect, titles : [String], style : YZCTitleStyle, isTitleInTop : Bool, layout : YZCPageCollectViewLayout) {
        self.titles = titles
        self.style = style
        self.isTitleInTop = isTitleInTop
        self.layout = layout
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YZCPageCollectionView {
    fileprivate func setupUI() {
        
        let titleY = isTitleInTop ? 0 : bounds.height - style.titleHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleHeight)
        titleView = YZCTitleView(frame: titleFrame, titles: titles, style: style)
        addSubview(titleView)
        titleView.delegate = self
        titleView.backgroundColor = UIColor.randomColor()
        
        let pageControlHeight : CGFloat = 20
        let pageControlY = isTitleInTop ? (bounds.height - pageControlHeight) : (bounds.height - pageControlHeight - style.titleHeight)
        let pageControlFrame = CGRect(x: 0, y: pageControlY, width: bounds.width, height: pageControlHeight)
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.numberOfPages = 4
        pageControl.isEnabled = false
        addSubview(pageControl)
        pageControl.backgroundColor = UIColor.randomColor()
        
        let collectionViewY = isTitleInTop ? style.titleHeight : 0
        let collectionViewFrame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: bounds.height - style.titleHeight - pageControlHeight)
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        collectionView.backgroundColor = UIColor.randomColor()
    }
}

// MARK:- 对外暴露的方法
extension YZCPageCollectionView {
    func register(cell : AnyClass?, identifier : String) {
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    func register(nib : UINib, identifier : String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
}

// MARK:- UICollectionViewDataSource
extension YZCPageCollectionView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
        }
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageCollectionView(self, collectionView, cellForItemAt: indexPath)
    }
}

extension YZCPageCollectionView : UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewEndScroll()
        }
    }
    
    fileprivate func scrollViewEndScroll() {
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        if sourceIndexPath.section != indexPath.section {
            let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            
            titleView.setTitleWithProgress(1.0, sourceIndex: sourceIndexPath.section, targetIndex: indexPath.section)
            
            sourceIndexPath = indexPath
        }
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
    }
}

extension YZCPageCollectionView : YZCTitleViewDelegate {
    func titleView(_ titleView: YZCTitleView, selectedIndex index: Int) {
        let indexPath = IndexPath(item: 0, section: index)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        scrollViewEndScroll()
    }
}
