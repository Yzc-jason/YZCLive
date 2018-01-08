//
//  NetworkTools.swift
//  YZCLive
//
//  Created by Jason on 2017/11/22.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Alamofire
import ObjectMapper

public enum NetError:Swift.Error {
    case HTTPError(NSError)
    case CustomError(Int,String)
    case DataError
    
    func handle() -> NetError {
        return self
    }
}

enum MethodType {
    case get
    case post
}

class NetworkTools {
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        Alamofire.request(URLString, method: method, parameters: parameters).validate(contentType: ["text/plain"]).responseJSON { (response) in
            guard let result = response.result.value else {
                log.debug(response.result.error!)
                return
            }
            finishedCallback(result)
        }
    }
}

extension NetworkTools {
    class func getNewRoomOnline(pageIndex:Int) -> Observable<[String: Any]> {
        return Observable<[String: Any]>.create({ (observer) -> Disposable in
            let parame = ["page":pageIndex]
            let url = "http://live.9158.com/Room/GetNewRoomOnline"
            Alamofire.request(url, method: .get, parameters: parame, encoding: URLEncoding.default).responseJSON { (response) in
                log.debug(response)
                switch response.result {
                case .success(let res):
                    if let json = res as? [String: Any], let code = Int((json["code"] as? String)!), let msg = json["msg"] as? String {
                        if code == 100 {
                            observer.onNext(json["data"] as! [String : Any])
                            observer.onCompleted()
                        }else{
                            observer.onError(NetError.CustomError(code, msg))
                        }
                    }else{
                        observer.onError(NetError.DataError)
                    }
                    break
                    
                case .failure(let error as NSError):
                    observer.onError(NetError.HTTPError(error).handle())
                    break
                }
            }
            return Disposables.create {
            }
        })
    }
    
    class func getShortVideo(pageIndex:Int, block:@escaping ([AchorlModel]) -> ()) {
        let parame = ["page":pageIndex]
        let url = "http://live.9158.com/Room/GetNewRoomOnline"
        Alamofire.request(url, method: .get, parameters: parame, encoding: URLEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let res):
                if let json = res as? [String: Any], let code = Int((json["code"] as? String)!), let msg = json["msg"] as? String {
                    if code == 100 {
                        let data =  json["data"] as! [String : Any]
                        let achorlArray = data["list"] as? [[String: Any]]
                        let achorls:[AchorlModel] = (achorlArray?.mapObjs(type: AchorlModel.self))!
                        block(achorls)
                    }else{
                        log.debug(msg)
                    }
                }
                break
                
            case .failure(let error as NSError):
                log.debug(error)
                break
            }
        }
    }
}


