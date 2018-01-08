//
//  ShortViewController.swift
//  YZCLive
//
//  Created by 叶志成 on 2017/10/24.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import UIKit

class ShortViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {

    private var dataSource: [AchorlModel] = []
    let viewModel   = HomeViewModel()
    
    lazy private var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        let width = self.view.yzc_width * 0.5 - 1
        layout.itemSize = CGSize(width: width, height: width)
        
        let collectionView  = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapGestureForFLEX()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        self.collectionView.register(HomeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: HomeCollectionViewCell.cellId)
        self.builDatasorce()
    }
    
    //MARK:- collectionView的数据源和代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.cellId, for: indexPath) as! HomeCollectionViewCell
        cell.backgroundColor  = UIColor.gray
        cell.model = self.dataSource[indexPath.row]
        return cell
    }
    
    //MARK:- private method
    func builDatasorce(){
        NetworkTools.getShortVideo(pageIndex: 1) { (array) in
            self.dataSource = array
            self.collectionView.reloadData()
        }
    }
}
