import Foundation

public enum QiitaAPIBodyFormat {
    case JSON, FormURLEncoded
}

// APIの実行時の挙動を操作するためのもの
public protocol QiitaAPIConfigProtocol {
    var baseURL: NSURL { get }
    var bodyFormat: QiitaAPIBodyFormat { get }
    var userAgent: String? { get }
    var queue: dispatch_queue_t { get }
    
    func configureRequest(apiRequest: QiitaAPIRequest)
    func beforeRequest(apiRequest: QiitaAPIRequest)
    func afterResponse(apiResponse: QiitaAPIResponse)
    func log(str: String?)
}

public class QiitaAPIConfig : QiitaAPIConfigProtocol {
    public let baseURL: NSURL
    public let bodyFormat: QiitaAPIBodyFormat
    public let queue: dispatch_queue_t
    public var userAgent: String?
    
    public init(baseURL: NSURL, bodyFormat: QiitaAPIBodyFormat? = nil, queue: NSOperationQueue? = nil) {
        self.baseURL = baseURL
        self.bodyFormat = bodyFormat ?? .JSON
        self.queue = queue ?? dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    }
    
    public func log(str: String?) {
        if let x = str { NSLog(x) }
    }
    
    public func configureRequest(apiRequest: QiitaAPIRequest) {
        apiRequest.request.setValue("gzip;q=1.0,compress;q=0.5", forHTTPHeaderField: "Accept-Encoding")
        if let ua = userAgent { apiRequest.request.setValue(ua, forHTTPHeaderField: "User-Agent") }
    }
    
    public func beforeRequest(apiRequest: QiitaAPIRequest) {
        let method = apiRequest.info.method
        if method == .POST || method == .PUT || method == .PATCH {
            switch bodyFormat {
            case .FormURLEncoded:
                apiRequest.request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            case .JSON:
                apiRequest.request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
    }
    public func afterResponse(apiResponse: QiitaAPIResponse) {}
}

public protocol QiitaAPIEntityProtocol {
    func toJsonDictionary() -> NSDictionary
    func toJsonData() -> NSData
    func toJsonString() -> NSString
    
    class func fromData(data: NSData!) -> QiitaAPIEntityProtocol?
    class func fromJsonDictionary(hash: NSDictionary?) -> QiitaAPIEntityProtocol?
}

// API定義から作られる静的な情報、を動的に参照するためのもの
public class QiitaAPIInfo {
    public enum HTTPMethod : String {
        case GET    = "GET"
        case POST   = "POST"
        case PUT    = "PUT"
        case PATCH  = "PATCH"
        case DELETE = "DELETE"
    }
    
    public let method: HTTPMethod
    public let path: String
    public let meta : [String:AnyObject]
    
    public init(method: HTTPMethod, path: String, meta: [String:AnyObject]) {
        self.method = method
        self.path = path
        self.meta = meta
    }
}

public class QiitaAPIRequest {
    public let request = NSMutableURLRequest()
    public let info : QiitaAPIInfo
    
    public init(info: QiitaAPIInfo) {
        self.info = info
        self.request.HTTPMethod = info.method.rawValue
    }
}

public class QiitaAPIResponse {
    public let response: NSHTTPURLResponse?
    public let error: NSError?
    public let request: QiitaAPIRequest
    public let data: NSData?
    
    public init(request: QiitaAPIRequest, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) {
        self.request = request
        self.response = response
        self.data = data
        self.error = error
    }

    public func statusCode() -> Int {
        return response?.statusCode ?? -1
    }

    public func isStatus2xx() -> Bool {
        let s = statusCode()
        return 200 <= s && s < 300
    }
}

public class QiitaAPIBase {
    public typealias CompletionHandler = (QiitaAPIResponse) -> Void
    
    public var config: QiitaAPIConfigProtocol
    public let apiRequest : QiitaAPIRequest
    public var handlerQueue: dispatch_queue_t?
    public var query = [String:AnyObject]()
    public var body: NSData?
    
    public init(config: QiitaAPIConfigProtocol, info: QiitaAPIInfo) {
        self.config = config
        self.apiRequest = QiitaAPIRequest(info: info)
    }
    
    func setupBody(object: AnyObject) {
        // set body if needed
        let method = apiRequest.info.method
        if !(method == .POST || method == .PUT || method == .PATCH) {
            return
        }

        switch(config.bodyFormat, object) {
        case (.FormURLEncoded, let x as QiitaEntityBase):
            let str = QiitaAPIURLUtil.makeQueryString(x.toJsonDictionary() as [String:AnyObject])
            self.body = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            
        case (.JSON, let x as QiitaEntityBase):
            self.body = x.toJsonData()
            
        case (.JSON, let x as [QiitaEntityBase]):
            self.body = QiitaEntityBase.toJsonData(x)

        case (_, let x as NSData):
            self.body = x

        default:
            return
        }
        apiRequest.request.HTTPBody = self.body
    }

    func replacePathPlaceholder(path: String, key: String) -> String {
        if let x:AnyObject = query[key] {
            query.removeValueForKey(key)
            return path.stringByReplacingOccurrencesOfString(
                "{\(key)}", withString: QiitaAPIURLUtil.escape("\(x)"))
        }
        return path
    }
    
    func doRequest(object: AnyObject, completionHandler: CompletionHandler) {
        setupBody(object)
        doRequest(completionHandler)
    }
    
    func doRequest(completionHandler: CompletionHandler) {
        config.configureRequest(apiRequest)
        
        // Add Encoded Query String
        let urlComponents = NSURLComponents(URL: apiRequest.request.URL!, resolvingAgainstBaseURL: true)!
        let qs = QiitaAPIURLUtil.makeQueryString(query)
        if !qs.isEmpty {
            urlComponents.percentEncodedQuery = (urlComponents.percentEncodedQuery != nil ? urlComponents.percentEncodedQuery! + "&" : "") + qs
            apiRequest.request.URL = urlComponents.URL
        }
        
        config.log("Request: \(apiRequest.request.HTTPMethod) \(apiRequest.request.URL?.absoluteString)")
        self.config.beforeRequest(self.apiRequest)

        dispatch_async(config.queue) {
            var response: NSURLResponse?
            var error: NSError?
            var data = NSURLConnection.sendSynchronousRequest(self.apiRequest.request, returningResponse: &response, error: &error)
            var apiResponse = QiitaAPIResponse(request: self.apiRequest, response: response as? NSHTTPURLResponse, data: data, error: error)
            dispatch_async(self.handlerQueue ?? dispatch_get_main_queue()) { // Thread周りは微妙。どうするといいだろう。
                self.config.afterResponse(apiResponse)
                if let e = apiResponse.error {
                    self.config.log(e.description)
                    if let d = data {
                        var responseBody = NSString(data: d, encoding: NSUTF8StringEncoding) ?? "Response is not UTF8Encoding"
                        self.config.log("RESPONSE(\(d.length) bytes): \(responseBody)")
                    }
                }
                completionHandler(apiResponse)
            }
        }
    }

    func jsonGenObjectFromJsonData(data: NSData!) -> AnyObject? {
        return QiitaJsonGenObjectFromJsonData(data)
    }
}

///////////////////// Begin https://github.com/Alamofire/Alamofire/blob/master/Source/Alamofire.swift
class QiitaAPIURLUtil {
    class func makeQueryString(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in sorted(Array(parameters.keys), <) {
            let value: AnyObject! = parameters[key]
            components += queryComponents(key, value)
        }
        
        return join("&", components.map{"\($0)=\($1)"} as [String])
    }
    
    class func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
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
    
    class func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":/?&=;+!@#$()',*"
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue)
    }
}

