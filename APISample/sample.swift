//
//  sample.swift
//  APISample
//
//  Created by 森下 健 on 2014/12/07.
//  Copyright (c) 2014年 Yumemi. All rights reserved.
//

import Foundation


public enum MyAPIBodyFormat {
    case JSON, FormURLEncoded
}

// APIの実行時の挙動を操作するためのもの
public protocol MyAPIConfigProtocol {
    var baseURL: String { get }
    var bodyFormat: MyAPIBodyFormat { get }
    var queue: dispatch_queue_t { get }

    func buildRequestURL(request: MyAPIRequest, params: [String:String]) -> NSURL
    func beforeRequest(request: MyAPIRequest)
    func afterResponse(response: MyAPIResponse)
}

public class MyAPIConfig : MyAPIConfigProtocol {
    public let baseURL: String
    public let bodyFormat: MyAPIBodyFormat
    public let queue: dispatch_queue_t
    
    public init(baseURL: String, bodyFormat: MyAPIBodyFormat? = nil, queue: NSOperationQueue? = nil) {
        self.baseURL = baseURL
        self.bodyFormat = bodyFormat ?? .JSON
        self.queue = queue ?? dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    }
    
    public func buildRequestURL(request: MyAPIRequest, params: [String:String]) -> NSURL {
        // TODO: Replace PATH parameter
        return NSURL()
    }
    
    public func beforeRequest(request: MyAPIRequest) {}
    public func afterResponse(response: MyAPIResponse) {}
}

public class MyAPIFactory {
    public let config: MyAPIConfigProtocol
    
    public init(config: MyAPIConfigProtocol) {
        self.config = config
    }
    
    // ADD Custom
    public func createMyAPIItem() -> MyAPIItem {
        return MyAPIItem(config: config)
    }
}

public protocol MyAPIEntityProtocol {
    func toJsonDictionary() -> NSDictionary
    func toJsonData() -> NSData
    func toJsonString() -> NSString
    
    class func fromData(data: NSData!) -> MyAPIEntityProtocol?
    class func fromJsonDictionary(hash: NSDictionary?) -> MyAPIEntityProtocol?
}

// API定義から作られる静的な情報、を動的に参照するためのもの
public class MyAPIInfo {
    public enum HTTPMethod : String {
        case GET    = "GET"
        case POST   = "POST"
        case PUT    = "PUT"
        case PATCH  = "PATCH"
        case DELETE = "DELETE"
    }
    
    public let method: HTTPMethod
    public let path: String
    public let meta : [String:String]
    
    public init(method: HTTPMethod, path: String, meta: [String:String]) {
        self.method = method
        self.path = path
        self.meta = meta
    }
}

public class MyAPIRequest {
    public let request = NSMutableURLRequest()
    public let info : MyAPIInfo
    
    public init(info: MyAPIInfo) {
        self.info = info
    }
}

public class MyAPIResponse {
    public let response: NSHTTPURLResponse?
    public let error: NSError?
    public let request: MyAPIRequest
    public let data: NSData?
    
    public init(request: MyAPIRequest, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) {
        self.request = request
        self.response = response
        self.data = data
        self.error = error
    }
}

public class MyAPIBase {
    public typealias CompletionHandler = (MyAPIResponse) -> Void
    
    public var config: MyAPIConfigProtocol
    public let apiRequest : MyAPIRequest

    public init(config: MyAPIConfigProtocol, info: MyAPIInfo) {
        self.config = config
        self.apiRequest = MyAPIRequest(info: info)
    }
    
    func call(query q: [String:String]? = nil, body: NSData? = nil,  headers hdr: [String:String]? = nil, config cfg: MyAPIConfigProtocol? = nil, queue: dispatch_queue_t? = nil, completionHandler: CompletionHandler? = nil) {
        let query = q ?? [String:String]()
        let config = cfg ?? self.config
        let headers = hdr ?? [String:String]()
        
        // set URL if not yet
        let request = apiRequest.request
        if request.URL == nil {
            request.URL = config.buildRequestURL(apiRequest, params: query)
        }
        
        // set body if needed
        let method = apiRequest.info.method
        if method == .POST || method == .PUT || method == .PATCH {
            request.HTTPBody = body
        }

        // default customize
        config.beforeRequest(apiRequest)
        
        // adhoc header overwrite
        for (k, v) in headers {
            request.setValue(v, forHTTPHeaderField: k)
        }

        dispatch_async(config.queue) {
            var response: NSURLResponse?   // = NSURLResponse() as NSURLResponse?
            var error: NSError?            // = NSError() as NSError?
            var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
            var apiResponse = MyAPIResponse(request: self.apiRequest, response: response as? NSHTTPURLResponse, data: data, error: error)
            if let handler = completionHandler {
                dispatch_async(queue ?? dispatch_get_main_queue()) { // Thread周りは微妙。どうするといいだろう。
                    handler(apiResponse)
                }
            }
        }
    }
    
    func encode(data: AnyObject, format: MyAPIBodyFormat) {
        // TODO
        
        
    }
    
    ///////////////////// Begin https://github.com/Alamofire/Alamofire/blob/master/Source/Alamofire.swift
    func makeQueryString(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in sorted(Array(parameters.keys), <) {
            let value: AnyObject! = parameters[key]
            components += queryComponents(key, value)
        }
        
        return join("&", components.map{"\($0)=\($1)"} as [String])
    }
    
    func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        var components = [(String, String)]()
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.extend([(escape(key), escape("\(value)"))])
        }
        
        return components
    }
    
    func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":/?&=;+!@#$()',*"
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue)
    }
    ///////////////////// END
}
