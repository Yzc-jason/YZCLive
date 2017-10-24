//
//  HomeController.swift
//  YZCLive
//
//  Created by 叶志成 on 2017/10/11.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import UIKit

class HomeController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    private var lastOffset: CGFloat = 0.0
    
    //MARK:lazy
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate   = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapGestureForFLEX()
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.itemWithTarget(target: self, action: #selector(searchAction), imageString: "search_head", highImageString: "search_head")
     
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.itemWithTarget(target: self, action: #selector(crowAction), imageString: "head_crown", highImageString: "head_crown")
        
        self.view.addSubview(self.tableView)
    }

    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    private func tableView(tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        
    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        log.debug(scrollView.contentOffset)
        var currentOffset:CGFloat = 0.0
        
        if lastOffset > scrollView.contentOffset.y {  //下拉
            currentOffset  = lastOffset - scrollView.contentOffset.y
        }else{ //上拉
            currentOffset = lastOffset + scrollView.contentOffset.y
        }
        
        if currentOffset < -42 {
            currentOffset = -42
        }else if currentOffset > 20 {
            currentOffset = 20
        }
        log.debug(String(format: "currentOffset %f", arguments: [currentOffset]))
        self.navigationController?.navigationBar.yzc_top = currentOffset
        lastOffset =  scrollView.contentOffset.y
        
    }
    
    //MARK:- Action
    @objc private func searchAction() {
        
    }
    
    @objc private func crowAction() {
        
    }

    
    
}


