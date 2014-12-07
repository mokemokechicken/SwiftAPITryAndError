//
//  api.swift
//  APISample
//
//  Created by 森下 健 on 2014/12/07.
//  Copyright (c) 2014年 Yumemi. All rights reserved.
//

import Foundation

public class MyAPIItem : MyAPIBase {
    public init(config: MyAPIConfigProtocol) {
        var meta = [String:String]()
        let apiInfo = MyAPIInfo(method: .GET, path: "items", meta: meta)
        super.init(config: config, info: apiInfo)
    }
    
    public class Params {
        public var page: Int?
        public var perPage: Int?
        
        public init(page: Int? = nil, perPage: Int? = nil) {
            self.page = page
            self.perPage = perPage
        }
        
        public func x() -> [String:AnyObject] {
            return [String:AnyObject]()
        }
    }
    
    func call(params: Params, headers hdr: [String:String]? = nil, config cfg: MyAPIConfigProtocol? = nil, queue: dispatch_queue_t? = nil, completionHandler: ((MyAPIResponse, Item?) -> Void)?) {
        let request = apiRequest.request
        let urlComponents = NSURLComponents(string: "\(config.baseURL)/\(apiRequest.info.path)")!
        urlComponents.percentEncodedQuery = (urlComponents.percentEncodedQuery != nil ? urlComponents.percentEncodedQuery! + "&" : "") + makeQueryString(params.x())
        request.URL = urlComponents.URL
        
        call() { response in
            if let handler = completionHandler {
                handler(response, Item.fromData(response.data) as? Item)
            }
        }
    }
    
}