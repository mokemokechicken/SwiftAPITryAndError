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
        
        public func toDictionary() -> [String:AnyObject] {
            var ret = [String:AnyObject]()
            if let x = page { ret["page"] = x }
            if let x = perPage { ret["per_page"] = x }
            return ret
        }
    }

    func call(params: Params, completionHandler: ((MyAPIResponse, [Item]?) -> Void)?) {
        // Convert PATH
         config.buildRequestURL(apiRequest, params: params.toDictionary())
        
        // Do Request
        doRequest() { response in
            if let handler = completionHandler {
                handler(response, Item.fromData(response.data) as? [Item])
            }
            return
        }
    }
    
}