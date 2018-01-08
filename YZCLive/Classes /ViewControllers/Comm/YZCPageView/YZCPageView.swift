//
//  YZCPageView.swift
//  YZCPageView
//
//  Created by 叶志成 on 2018/1/7.
//  Copyright © 2018年 叶志成. All rights reserved.
//

import UIKit

class YZCPageView: UIView {
    
    fileprivate var titles: [String]!
    fileprivate var childVcs: [UIViewController]!
    fileprivate var style: YZCTitleStyle!
    fileprivate weak var parentVc: UIViewController!
    
    fileprivate var titleView: YZCTitleView!
    fileprivate var contentView: YZCContentView!

    init(frame:CGRect, titles: [String], style: YZCTitleStyle, childVcs: [UIViewController], parentVc: UIViewController) {
        super.init(frame: frame)
        
        assert(titles.count == childVcs.count, "标题和控制器个数不一致，请检测！！！")
        self.style = style
        self.childVcs = childVcs
        self.titles = titles
        self.parentVc = parentVc
        parentVc.automaticallyAdjustsScrollViewInsets = false
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YZCPageView {
    fileprivate func setUpUI() {
        let titleH: CGFloat = 44
        let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
        titleView = YZCTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.delegate = self
        addSubview(titleView)
        
        let contentFrame = CGRect(x: 0, y: titleH, width: frame.width, height: frame.height - titleH)
        contentView = YZCContentView(frame: contentFrame, childVcs: childVcs, parentViewContoller: parentVc)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.delegate = self
        addSubview(contentView)
    }
}

 //MARK: - YZCTitleViewDelegate
extension YZCPageView : YZCTitleViewDelegate {
    func titleView(_ titleView: YZCTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}

 //MARK: - YZCContentViewDelegate
extension YZCPageView : YZCContentViewDelegate {
    func contentView(_ contentView: YZCContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func contentViewEndScroll(_ contentView: YZCContentView) {
        titleView.contentViewDidEndScroll()
    }
}

