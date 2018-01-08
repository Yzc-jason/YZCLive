//
//  AnchorViewController.swift
//  YZCLive
//
//  Created by Jason on 2018/1/8.
//  Copyright © 2018年 叶志成. All rights reserved.
//

import UIKit

private let kEdgeMargin : CGFloat = 8
private let kAnchorCellID = "kAnchorCellID"

class AnchorViewController: UIViewController {

    var homeType: HomeType!
    fileprivate var lastOffset: CGFloat = 0.0
    // MARK: 定义属性
    fileprivate lazy var homeVM : HomeViewModel = HomeViewModel()
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = WaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: kEdgeMargin, left: kEdgeMargin, bottom: kEdgeMargin, right: kEdgeMargin)
        layout.minimumLineSpacing = kEdgeMargin
        layout.minimumInteritemSpacing = kEdgeMargin
        layout.dataSource = self
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellWithReuseIdentifier: kAnchorCellID)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData(index: 0)
    }
    
}


// MARK:- 设置UI界面内容
extension AnchorViewController {
    fileprivate func setupUI() {
        view.addSubview(collectionView)
    }
}

extension AnchorViewController {
    fileprivate func loadData(index : Int) {
        homeVM.loadHomeData(type: homeType, index : index, finishedCallback: {
            self.collectionView.reloadData()
        })
    }
}

// MARK:- collectionView的数据源&代理
extension AnchorViewController : UICollectionViewDataSource, WaterfallLayoutDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeVM.anchorModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAnchorCellID, for: indexPath) as! HomeViewCell
        cell.anchorModel = homeVM.anchorModels[indexPath.item]
        if indexPath.item == homeVM.anchorModels.count - 1 {
            loadData(index: homeVM.anchorModels.count)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let roomVc = RoomViewController()
//        navigationController?.pushViewController(roomVc, animated: true)
    }
    
    func waterfallLayout(_ layout: WaterfallLayout, indexPath: IndexPath) -> CGFloat {
        return indexPath.item % 2 == 0 ? kScreenW * 2 / 3 : kScreenW * 0.5
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        if UIDevice.current.isX() {
//            return UIEdgeInsetsMake(88, 0, 78, 0)
//        }else if #available(iOS 11.0, *) {
//            return UIEdgeInsetsMake(64, 0, 44, 0)
//        }
//        return UIEdgeInsetsMake(44, 0, 0, 0)
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > 0 {
//            if lastOffset > scrollView.contentOffset.y {  //下拉
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.navigationController?.navigationBar.yzc_top = 20;
//                    self.navigationController?.tabBarController?.tabBar.yzc_top = UIScreen.main.bounds.size.height - 44
//                    if UIDevice.current.isX() {
//                        self.navigationController?.navigationBar.yzc_top =  42
//                        self.navigationController?.tabBarController?.tabBar.yzc_top = UIScreen.main.bounds.size.height - 44 - 34
//                    }
//                })
//            }else{ //上拉
//                UIView.animate(withDuration: 0.2, animations: {
//                    let offset =  scrollView.contentOffset.y - self.lastOffset
//                    self.navigationController?.navigationBar.yzc_top = -42
//                    if scrollView.contentOffset.y < 42 {
//                        self.navigationController?.navigationBar.yzc_top = offset < -42 ? -42 : offset
//                    }
//                    self.navigationController?.tabBarController?.tabBar.yzc_top = UIScreen.main.bounds.size.height
//                })
//            }
//            lastOffset =  scrollView.contentOffset.y
//        }
//    }
}


