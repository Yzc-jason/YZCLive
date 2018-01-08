//
//  HomeCollectionViewCell.swift
//  YZCLive
//
//  Created by Jason on 2017/10/31.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import UIKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {
    static let cellId: String = "AchorlCell"
    
    fileprivate lazy var titleNameLabel: UILabel = {
        let titleNameLabel = UILabel(frame: CGRect(x: 15, y: 0, width: self.familyImageView.yzc_width, height: self.familyImageView.yzc_height))
        titleNameLabel.textColor = UIColor.black
        titleNameLabel.font = UIFont.systemFont(ofSize: 15)
        return titleNameLabel
    }()
    
    fileprivate lazy var familyImageView: UIImageView =  {
        let familyImageView = UIImageView(image: UIImage(named: "MJ_family_bg_1_71x20_"))
        familyImageView.yzc_left = 5
        familyImageView.yzc_top  = 3
        familyImageView.yzc_height = 25
        return familyImageView
    }()
    
    fileprivate lazy var backgroundImageView: UIImageView =  {
        let backgroundImageView = UIImageView(frame: self.frame)
        return backgroundImageView
    }()
    
    fileprivate lazy var typeImageView: UIImageView =  {
        let typeImageView = UIImageView(image: UIImage(named: "MJ_flag_live_1_38x20_"))
        typeImageView.yzc_centerY = self.familyImageView.yzc_centerY
        typeImageView.yzc_left = self.yzc_width - typeImageView.yzc_width - 5
        return typeImageView
    }()
    
    fileprivate lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel(frame: CGRect(x: self.titleNameLabel.yzc_left, y: 0, width: self.yzc_width, height: 30))
        userNameLabel.textColor = UIColor.white
        userNameLabel.font = UIFont.systemFont(ofSize: 14)
        return userNameLabel
    }()
 
    fileprivate lazy var startImageView: UIImageView =  {
        let startImageView = UIImageView(image: UIImage(named: "girl_star1"))
        startImageView.yzc_height = 19
        startImageView.yzc_width  = 40
       
         self.contentView.addSubview(startImageView)
        return startImageView
    }()
    
    fileprivate lazy var onlinePeopleLabel: UILabel = {
        let onlinePeopleLabel = UILabel(frame: CGRect(x: self.typeImageView.yzc_left, y: 0, width: 100, height: 30))
        onlinePeopleLabel.textColor = UIColor.white
        onlinePeopleLabel.yzc_left = self.yzc_width - onlinePeopleLabel.yzc_width - 10
        onlinePeopleLabel.font = UIFont.systemFont(ofSize: 14)
        onlinePeopleLabel.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(onlinePeopleLabel)
        return onlinePeopleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.backgroundImageView)
        self.contentView.addSubview(self.familyImageView)
        self.familyImageView.addSubview(self.titleNameLabel)
        self.contentView.addSubview(self.typeImageView)
        self.contentView.addSubview(self.userNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundImageView.yzc_top = 0
        self.userNameLabel.yzc_bottom = self.yzc_height - 30
        self.startImageView.yzc_top   = self.userNameLabel.yzc_bottom
        self.startImageView.yzc_left  = self.userNameLabel.yzc_left
        self.onlinePeopleLabel.yzc_centerY = self.startImageView.yzc_centerY
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundImageView.image = nil
        self.backgroundImageView.frame = self.contentView.frame
        
    }
    
    var model: AchorlModel? {
        didSet {
            self.userNameLabel.text = model?.nickname
            self.startImageView.image = UIImage(named: "girl_star2")
            self.titleNameLabel.text = model?.familyName
            self.backgroundImageView.setImage(model?.photo, "home_pic_default")
            self.onlinePeopleLabel.text = String(format: "%d人", arguments: [(model?.roomid)!])
        }
    }
    
    var anchorModel : AnchorModel? {
        didSet {
            backgroundImageView.setImage(anchorModel!.isEvenIndex ? anchorModel?.pic74 : anchorModel?.pic51, "home_pic_default")
            typeImageView.isHidden = anchorModel?.live == 0
            userNameLabel.text = anchorModel?.name
            onlinePeopleLabel.text = "\(anchorModel?.focus ?? 0)人"
        }
    }
}
