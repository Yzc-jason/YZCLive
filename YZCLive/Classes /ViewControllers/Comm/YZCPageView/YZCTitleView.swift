//
//  YZCTitleView.swift
//  YZCPageView
//
//  Created by 叶志成 on 2018/1/7.
//  Copyright © 2018年 叶志成. All rights reserved.
//

import UIKit

protocol YZCTitleViewDelegate : class {
    func titleView(_ titleView: YZCTitleView, selectedIndex index: Int)
}

class YZCTitleView: UIView {
    
    weak var delegate: YZCTitleViewDelegate?
    
    fileprivate var titles: [String]!
    fileprivate var style: YZCTitleStyle!
    fileprivate var currentIndex : Int = 0
    
    fileprivate lazy var normalColorRGB: (r: CGFloat, g: CGFloat, b: CGFloat) = self.getRGBWithColor(self.style.normalColor)
    fileprivate lazy var selectedColorRGB: (r: CGFloat, g: CGFloat, b: CGFloat) = self.getRGBWithColor(self.style.selectedColor)
    
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    
    //MARK: - 控件属性
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    fileprivate lazy var splitLineView: UIView = {
        let splitView = UIView()
        splitView.backgroundColor = UIColor.lightGray
        let h: CGFloat = 0.5
        splitView.frame = CGRect(x: 0, y: self.frame.height - h, width: self.frame.width, height: h)
        return splitView
    }()
    fileprivate lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        return bottomLine
    }()
    fileprivate lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverBgColor
        coverView.alpha = 0.7
        return coverView
    }()
    
    init(frame: CGRect, titles: [String], style: YZCTitleStyle) {
        super.init(frame: frame)
        
        self.titles = titles
        self.style  = style
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension YZCTitleView {
    fileprivate func setUpUI() {
        addSubview(scrollView)
        addSubview(splitLineView)
        setupTitleLabels()
        setupTitleLabelsPosition()
        if style.isShowBottomLine {
            setupBottomLine()
        }
        if style.isShowCover {
            setupCoverView()
        }
    }
    
    fileprivate func setupTitleLabels() {
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.tag = index
            label.text = title
            label.font = style.font
            label.textColor = index == 0 ? style.selectedColor : style.normalColor
            label.textAlignment = .center
            
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_ :)))
            label.addGestureRecognizer(tapGes)
            
            titleLabels.append(label)
            scrollView.addSubview(label)
            
        }
    }
    
    fileprivate func setupTitleLabelsPosition() {
        var titleX: CGFloat = 0.0
        var titleW: CGFloat = 0.0
        let titleH : CGFloat = frame.height
        let titleY: CGFloat = 0.0
        let count = titles.count
        
        for (index, label) in titleLabels.enumerated() {
            if style.isScrollEnable {
                let rect = (label.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : style.font], context: nil)
                titleW = rect.width
                if index == 0 {
                    titleX = style.titleMargin * 0.5
                } else {
                    let preLabel = titleLabels[index - 1]
                    titleX = preLabel.frame.maxX + style.titleMargin
                }
                
            } else {
                titleW = frame.width / CGFloat(count)
                titleX = titleW * CGFloat(index)
            }
            
            label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
            
            // 放大的代码
            if index == 0 {
                let scale = style.isNeedScale ? style.scaleRange : 1.0
                label.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        
        if style.isScrollEnable {
            scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + style.titleMargin * 0.5, height: 0)
        }
    }
    
    fileprivate func setupBottomLine() {
        scrollView.addSubview(bottomLine)
        bottomLine.frame = titleLabels.first!.frame
        bottomLine.frame.size.height = style.bottomLineH
        bottomLine.frame.origin.y = bounds.height - style.bottomLineH
    }
    
    fileprivate func setupCoverView() {
        scrollView.insertSubview(coverView, at: 0)
        let firstLabel = titleLabels[0]
        var coverH = style.coverH
        let coverW = firstLabel.frame.width
        var coverX = firstLabel.frame.origin.x
        let coverY = (bounds.height - coverH) * 0.5
        
        if style.isScrollEnable {
            coverX -= style.coverMargin
            coverH += style.coverMargin * 2
        }
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        
        coverView.layer.cornerRadius = style.coverRadius
        coverView.layer.masksToBounds = true
    }
    
}

extension YZCTitleView {
    fileprivate func getRGBWithColor(_ color: UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard let components = color.cgColor.components else {
            fatalError("请使用GRB方式给Title设置颜色")
        }
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}

 //MARK: - 事件处理
extension YZCTitleView {
    @objc fileprivate func titleLabelClick(_ tap: UITapGestureRecognizer) {
        guard let currentLabel = tap.view as? UILabel else { return }
        if currentLabel.tag == currentIndex { return }
        let oldLabel = titleLabels[currentIndex]

        currentLabel.textColor = style.selectedColor
        oldLabel.textColor = style.normalColor
        currentIndex = currentLabel.tag
        delegate?.titleView(self, selectedIndex: currentIndex)
        contentViewDidEndScroll()

        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.15, animations: {
                self.bottomLine.frame.origin.x = currentLabel.frame.origin.x
                self.bottomLine.frame.size.width = currentLabel.frame.size.width
            })
        }

        if style.isNeedScale {
            oldLabel.transform = CGAffineTransform.identity
            currentLabel.transform = CGAffineTransform(scaleX: style.scaleRange, y: style.scaleRange)
        }
        
        if style.isShowCover {
            let coverX = style.isScrollEnable ? (currentLabel.frame.origin.x - style.coverMargin) : currentLabel.frame.origin.x
            let coverW = style.isScrollEnable ? (currentLabel.frame.width + style.coverMargin * 2) : currentLabel.frame.width
            UIView.animate(withDuration: 0.15, animations: {
                self.coverView.frame.origin.x = coverX
                self.coverView.frame.size.width = coverW
            })
        }
    }
}

//暴露方法
extension YZCTitleView {
    func setTitleWithProgress(_ progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        let colorDelta = (selectedColorRGB.0 - normalColorRGB.0, selectedColorRGB.1 - normalColorRGB.1, selectedColorRGB.2 - normalColorRGB.2)
        sourceLabel.textColor = UIColor(r: selectedColorRGB.0 - colorDelta.0 * progress, g: selectedColorRGB.1 - colorDelta.1 * progress, b: selectedColorRGB.2 - colorDelta.2 * progress)
        targetLabel.textColor = UIColor(r: normalColorRGB.0 + colorDelta.0 * progress, g: normalColorRGB.1 + colorDelta.1 * progress, b: normalColorRGB.2 + colorDelta.2 * progress)
        currentIndex = targetIndex
        
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveTotalW = targetLabel.frame.width - sourceLabel.frame.width

        if style.isShowBottomLine {
            bottomLine.frame.size.width = sourceLabel.frame.width + moveTotalW * progress
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + moveTotalX * progress
        }
        if style.isNeedScale {
            let scaleDelta = (style.scaleRange - 1.0) * progress
            sourceLabel.transform = CGAffineTransform(scaleX: style.scaleRange - scaleDelta, y: style.scaleRange - scaleDelta)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + scaleDelta, y: 1.0 + scaleDelta)
        }
        
        if style.isShowCover {
            coverView.frame.size.width = style.isScrollEnable ? (sourceLabel.frame.width + 2 * style.coverMargin + moveTotalW * progress) : (sourceLabel.frame.width + moveTotalW * progress)
            coverView.frame.origin.x = style.isScrollEnable ? (sourceLabel.frame.origin.x - style.coverMargin + moveTotalX * progress) : (sourceLabel.frame.origin.x + moveTotalX * progress)
        }
    }
    
    func contentViewDidEndScroll() {
        guard style.isScrollEnable else { return }
        let targetLabel = titleLabels[currentIndex]
    
        var offSetX = targetLabel.center.x - bounds.width * 0.5
        if offSetX < 0 {
            offSetX = 0
        }
        
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offSetX > maxOffset {
            offSetX = maxOffset
        }
        scrollView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
    }
}



