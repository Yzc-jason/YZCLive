//
//  HomeViewModel.swift
//  YZCLive
//
//  Created by 叶志成 on 2017/10/27.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Alamofire

public enum RefreshStatus: Int {
    case PushSuccess
    case PushFailure
    case PullSuccess
    case PullFailure
    case NoMoreData
    case Unknown
}

class HomeViewModel {
    
    lazy var anchorModels = [AnchorModel]()
    
//    fileprivate var loadData = PublishSubject<Int>()
//    fileprivate var page:Int = 1
//    fileprivate var dataSource = [SectionModel<String, AchorlModel>]()
//    public var result:Observable<[SectionModel<String, AchorlModel>]>?
//    public var refresh:Variable<RefreshStatus> = Variable(.Unknown)
//
//    override init() {
//        super.init()
//        result = loadData.flatMapLatest({ [weak self] (p) -> Observable<[SectionModel<String, AchorlModel>]> in
//            return NetworkTools.getNewRoomOnline(pageIndex: p).map({ (json) -> [SectionModel<String, AchorlModel>] in
//                if let achorlArray = json["list"] as? [[String: Any]],let achorls = achorlArray.mapObjs(type: AchorlModel.self) {
//                    if p == 1 {
//                        self?.dataSource = [SectionModel(model: "", items: achorls)]
//                        self?.refresh.value = .PushSuccess
//                        return (self!.dataSource)
//                    }else{
//                        self?.dataSource += [SectionModel(model: "", items: achorls)]
//                        self?.refresh.value = .PushSuccess
//                        return (self!.dataSource)
//                    }
//                }else{
//                    if p != 1 {
//                        self?.page -= 1
//                        self?.refresh.value = .PushFailure
//                    }else{
//                        self?.refresh.value = .PushFailure
//                    }
//                }
//                return [SectionModel(model: "", items: [])]
//            }).catchErrorJustReturn([SectionModel(model: "", items: [])])
//        })
//    }
//
//    func reloadData() {
//        page = 1
//        loadData.onNext(page)
//    }
//
//    func loadMoreData() {
//        page += 1
//        loadData.onNext(page)
//    }
}

extension HomeViewModel {
    func loadHomeData(type : HomeType, index : Int,  finishedCallback : @escaping () -> ()) {
        NetworkTools.requestData(.get, URLString: "http://qf.56.com/home/v4/moreAnchor.ios", parameters: ["type" : type.type, "index" : index, "size" : 48], finishedCallback: { (result) -> Void in
            
            guard let resultDict = result as? [String : Any] else { return }
            guard let messageDict = resultDict["message"] as? [String : Any] else { return }
            guard let dataArray = messageDict["anchors"] as? [[String : Any]] else { return }
            
            for (index, dict) in dataArray.enumerated() {
                let anchor = AnchorModel(dict: dict)
                anchor.isEvenIndex = index % 2 == 0
                self.anchorModels.append(anchor)
            }
            
            finishedCallback()
        })
    }
}

