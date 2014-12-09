import Foundation

private func encode(obj: AnyObject?) -> AnyObject {
    switch obj {
    case nil:
        return NSNull()
        
    case let ojmObject as JsonGenEntityBase:
        return ojmObject.toJsonDictionary()
        
    default:
        return obj!
    }
}

private func decodeOptional(obj: AnyObject?) -> AnyObject? {
    switch obj {
    case let x as NSNull:
        return nil
    
    default:
        return obj
    }
}

func JsonGenObjectFromJsonData(data: NSData!) -> AnyObject? {
    if data == nil {
        return nil
    }
    return NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: nil)
}

public class JsonGenEntityBase {
    public init() {
    }

    public func toJsonDictionary() -> NSDictionary {
        return NSDictionary()
    }

    public class func toJsonArray(entityList: [JsonGenEntityBase]) -> NSArray {
        return entityList.map {x in encode(x)}
    }

    public class func toJsonData(entityList: [JsonGenEntityBase], pritty: Bool = false) -> NSData {
        var obj = toJsonArray(entityList)
        return toJson(obj, pritty: pritty)
    }

    public func toJsonData(pritty: Bool = false) -> NSData {
        var obj = toJsonDictionary()
        return JsonGenEntityBase.toJson(obj, pritty: pritty)
    }

    public class func toJsonString(entityList: [JsonGenEntityBase], pritty: Bool = false) -> NSString {
        return NSString(data: toJsonData(entityList, pritty: pritty), encoding: NSUTF8StringEncoding)!
    }

    public func toJsonString(pritty: Bool = false) -> NSString {
        return NSString(data: toJsonData(pritty: pritty), encoding: NSUTF8StringEncoding)!
    }

    public class func fromData(data: NSData!) -> AnyObject? {
        var object:AnyObject? = JsonGenObjectFromJsonData(data)
        switch object {
        case let hash as NSDictionary:
            return fromJsonDictionary(hash)

        case let array as NSArray:
            return fromJsonArray(array)

        default:
            return object
        }
    }

    public class func fromJsonDictionary(hash: NSDictionary?) -> JsonGenEntityBase? {
        return nil
    }

    public class func fromJsonArray(array: NSArray?) -> [JsonGenEntityBase]? {
        if array == nil {
            return nil
        }
        var ret = [JsonGenEntityBase]()
        if let xx = array as? [NSDictionary] {
            for x in xx {
                if let obj = fromJsonDictionary(x) {
                    ret.append(obj)
                } else {
                    return nil
                }
            }
        } else {
            return nil
        }
        return ret
    }

    private class func toJson(obj: NSObject, pritty: Bool = false) -> NSData {
        let options = pritty ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions.allZeros
        return NSJSONSerialization.dataWithJSONObject(obj, options: options, error: nil)!
    }
}

public class QiitaTag : JsonGenEntityBase {
    var name: String = ""
    var versions: [String] = [String]()

    public override func toJsonDictionary() -> NSDictionary {
        var hash = NSMutableDictionary()
        // Encode name
        hash["name"] = encode(self.name)
        // Encode versions
        hash["versions"] = self.versions.map {x in encode(x)}
        return hash
    }

    public override class func fromJsonDictionary(hash: NSDictionary?) -> QiitaTag? {
        if let h = hash {
            var this = QiitaTag()
            // Decode name
            if let x = h["name"] as? String {
                this.name = x
            } else {
                return nil
            }

            // Decode versions
            if let xx = h["versions"] as? [String] {
                this.versions = xx
            } else {
                return nil
            }

            return this
        } else {
            return nil
        }
    }
}

public class QiitaItem : JsonGenEntityBase {
    var body: String = ""
    var coediting: Bool = false
    var createdAt: String = ""
    var id: String = ""
    var `private`: Bool?
    var tags: [QiitaTag] = [QiitaTag]()
    var title: String = ""
    var updatedAt: String = ""
    var url: String = ""
    var user: QiitaUser = QiitaUser()

    public override func toJsonDictionary() -> NSDictionary {
        var hash = NSMutableDictionary()
        // Encode body
        hash["body"] = encode(self.body)
        // Encode coediting
        hash["coediting"] = encode(self.coediting)
        // Encode createdAt
        hash["created_at"] = encode(self.createdAt)
        // Encode id
        hash["id"] = encode(self.id)
        // Encode `private`
        if let x = self.`private` {
            hash["private"] = encode(x)
        }

        // Encode tags
        hash["tags"] = self.tags.map {x in encode(x)}
        // Encode title
        hash["title"] = encode(self.title)
        // Encode updatedAt
        hash["updated_at"] = encode(self.updatedAt)
        // Encode url
        hash["url"] = encode(self.url)
        // Encode user
        hash["user"] = self.user.toJsonDictionary()
        return hash
    }

    public override class func fromJsonDictionary(hash: NSDictionary?) -> QiitaItem? {
        if let h = hash {
            var this = QiitaItem()
            // Decode body
            if let x = h["body"] as? String {
                this.body = x
            } else {
                return nil
            }

            // Decode coediting
            if let x = h["coediting"] as? Bool {
                this.coediting = x
            } else {
                return nil
            }

            // Decode createdAt
            if let x = h["created_at"] as? String {
                this.createdAt = x
            } else {
                return nil
            }

            // Decode id
            if let x = h["id"] as? String {
                this.id = x
            } else {
                return nil
            }

            // Decode `private`
            this.`private` = h["private"] as? Bool
            // Decode tags
            if let xx = h["tags"] as? [NSDictionary] {
                for x in xx {
                    if let obj = QiitaTag.fromJsonDictionary(x) {
                        this.tags.append(obj)
                    } else {
                        return nil
                    }
                }
            } else {
                return nil
            }

            // Decode title
            if let x = h["title"] as? String {
                this.title = x
            } else {
                return nil
            }

            // Decode updatedAt
            if let x = h["updated_at"] as? String {
                this.updatedAt = x
            } else {
                return nil
            }

            // Decode url
            if let x = h["url"] as? String {
                this.url = x
            } else {
                return nil
            }

            // Decode user
            if let x = QiitaUser.fromJsonDictionary((h["user"] as? NSDictionary)) {
                this.user = x
            } else {
                return nil
            }

            return this
        } else {
            return nil
        }
    }
}

public class QiitaUser : JsonGenEntityBase {
    var description: String?
    var facebookId: String?
    var followeesCount: Int = 0
    var followersCount: Int = 0
    var githubLoginName: String?
    var id: String = ""
    var itemsCount: Int = 0
    var linkedinId: String?
    var location: String?
    var name: String?
    var organization: String?
    var profileImageUrl: String?
    var twitterScreenName: String?
    var websiteUrl: String?

    public override func toJsonDictionary() -> NSDictionary {
        var hash = NSMutableDictionary()
        // Encode description
        if let x = self.description {
            hash["description"] = encode(x)
        }

        // Encode facebookId
        if let x = self.facebookId {
            hash["facebook_id"] = encode(x)
        }

        // Encode followeesCount
        hash["followees_count"] = encode(self.followeesCount)
        // Encode followersCount
        hash["followers_count"] = encode(self.followersCount)
        // Encode githubLoginName
        if let x = self.githubLoginName {
            hash["github_login_name"] = encode(x)
        }

        // Encode id
        hash["id"] = encode(self.id)
        // Encode itemsCount
        hash["items_count"] = encode(self.itemsCount)
        // Encode linkedinId
        if let x = self.linkedinId {
            hash["linkedin_id"] = encode(x)
        }

        // Encode location
        if let x = self.location {
            hash["location"] = encode(x)
        }

        // Encode name
        if let x = self.name {
            hash["name"] = encode(x)
        }

        // Encode organization
        if let x = self.organization {
            hash["organization"] = encode(x)
        }

        // Encode profileImageUrl
        if let x = self.profileImageUrl {
            hash["profile_image_url"] = encode(x)
        }

        // Encode twitterScreenName
        if let x = self.twitterScreenName {
            hash["twitter_screen_name"] = encode(x)
        }

        // Encode websiteUrl
        if let x = self.websiteUrl {
            hash["website_url"] = encode(x)
        }

        return hash
    }

    public override class func fromJsonDictionary(hash: NSDictionary?) -> QiitaUser? {
        if let h = hash {
            var this = QiitaUser()
            // Decode description
            this.description = h["description"] as? String
            // Decode facebookId
            this.facebookId = h["facebook_id"] as? String
            // Decode followeesCount
            if let x = h["followees_count"] as? Int {
                this.followeesCount = x
            } else {
                return nil
            }

            // Decode followersCount
            if let x = h["followers_count"] as? Int {
                this.followersCount = x
            } else {
                return nil
            }

            // Decode githubLoginName
            this.githubLoginName = h["github_login_name"] as? String
            // Decode id
            if let x = h["id"] as? String {
                this.id = x
            } else {
                return nil
            }

            // Decode itemsCount
            if let x = h["items_count"] as? Int {
                this.itemsCount = x
            } else {
                return nil
            }

            // Decode linkedinId
            this.linkedinId = h["linkedin_id"] as? String
            // Decode location
            this.location = h["location"] as? String
            // Decode name
            this.name = h["name"] as? String
            // Decode organization
            this.organization = h["organization"] as? String
            // Decode profileImageUrl
            this.profileImageUrl = h["profile_image_url"] as? String
            // Decode twitterScreenName
            this.twitterScreenName = h["twitter_screen_name"] as? String
            // Decode websiteUrl
            this.websiteUrl = h["website_url"] as? String
            return this
        } else {
            return nil
        }
    }
}

private func try<T>(x: T?, handler: (T) -> Void) {
    if let xx = x {
        handler(xx)
    }
}

private func try<T>(x: T?, handler: (T) -> Any?) -> Any? {
    if let xx = x {
        return handler(xx)
    }
    return nil
}


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
        NSLog("\(str)")
    }
    
    public func configureRequest(apiRequest: QiitaAPIRequest) {
        apiRequest.request.setValue("gzip;q=1.0,compress;q=0.5", forHTTPHeaderField: "Accept-Encoding")
        try(userAgent) { ua in apiRequest.request.setValue(ua, forHTTPHeaderField: "User-Agent") }
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
    
    func setBody(object: AnyObject) {
        // set body if needed
        let method = apiRequest.info.method
        if !(method == .POST || method == .PUT || method == .PATCH) {
            return
        }

        switch(config.bodyFormat, object) {
        case (.FormURLEncoded, let x as JsonGenEntityBase):
            let str = URLUtil.makeQueryString(x.toJsonDictionary() as [String:AnyObject])
            self.body = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            
        case (.JSON, let x as JsonGenEntityBase):
            self.body = x.toJsonData()
            
        case (.JSON, let x as [JsonGenEntityBase]):
            self.body = JsonGenEntityBase.toJsonData(x)

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
                "{\(key)}", withString: URLUtil.escape("\(x)"))
        }
        return path
    }
    
    func doRequest(object: AnyObject, completionHandler: CompletionHandler) {
        setBody(object)
        doRequest(completionHandler)
    }
    
    func doRequest(completionHandler: CompletionHandler) {
        config.configureRequest(apiRequest)
        
        // Add Encoded Query String
        let urlComponents = NSURLComponents(URL: apiRequest.request.URL!, resolvingAgainstBaseURL: true)!
        let qs = URLUtil.makeQueryString(query)
        if !qs.isEmpty {
            urlComponents.percentEncodedQuery = (urlComponents.percentEncodedQuery != nil ? urlComponents.percentEncodedQuery! + "&" : "") + qs
            apiRequest.request.URL = urlComponents.URL
        }
        
        config.log("Request URL: \(apiRequest.request.URL?.absoluteString)")
        
        dispatch_async(config.queue) {
            self.config.beforeRequest(self.apiRequest)
            var response: NSURLResponse?
            var error: NSError?
            var data = NSURLConnection.sendSynchronousRequest(self.apiRequest.request, returningResponse: &response, error: &error)
            var apiResponse = QiitaAPIResponse(request: self.apiRequest, response: response as? NSHTTPURLResponse, data: data, error: error)
            self.config.afterResponse(apiResponse)
            dispatch_async(self.handlerQueue ?? dispatch_get_main_queue()) { // Thread周りは微妙。どうするといいだろう。
                completionHandler(apiResponse)
            }
        }
    }
}

///////////////////// Begin https://github.com/Alamofire/Alamofire/blob/master/Source/Alamofire.swift
class URLUtil {
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

public class QiitaAPIFactory {
    public let config: QiitaAPIConfigProtocol
    public init(config: QiitaAPIConfigProtocol) {
        self.config = config
    }
    public func createListItem() -> QiitaAPIListItem {
        return QiitaAPIListItem(config: config)
    }
    public func createGetItem() -> QiitaAPIGetItem {
        return QiitaAPIGetItem(config: config)
    }
    public func createPostItem() -> QiitaAPIPostItem {
        return QiitaAPIPostItem(config: config)
    }
    public func createPatchItem() -> QiitaAPIPatchItem {
        return QiitaAPIPatchItem(config: config)
    }
    public func createSamplePut() -> QiitaAPISamplePut {
        return QiitaAPISamplePut(config: config)
    }
    public func createSamplePatch() -> QiitaAPISamplePatch {
        return QiitaAPISamplePatch(config: config)
    }
    public func createSamplePostBinary() -> QiitaAPISamplePostBinary {
        return QiitaAPISamplePostBinary(config: config)
    }
}

public class QiitaAPIListItem : QiitaAPIBase {
    public init(config: QiitaAPIConfigProtocol) {
        var meta = [String:AnyObject]()
        let apiInfo = QiitaAPIInfo(method: .GET, path: "items", meta: meta)
        super.init(config: config, info: apiInfo)
    }

    public func setup(page: Int? = nil, perPage: Int? = nil) -> QiitaAPIListItem {
        query = [String:AnyObject]()
        if let x = page { query["page"] = x }
        if let x = perPage { query["per_page"] = x }

        var path = apiRequest.info.path
        apiRequest.request.URL = NSURL(string: path, relativeToURL: config.baseURL)
        return self
    }

    public func call(completionHandler: (QiitaAPIResponse, [QiitaItem]?) -> Void) {
        doRequest() { response in
            completionHandler(response, QiitaItem.fromData(response.data) as? [QiitaItem])
        }
    }
}

public class QiitaAPIGetItem : QiitaAPIBase {
    public init(config: QiitaAPIConfigProtocol) {
        var meta = [String:AnyObject]()
        let apiInfo = QiitaAPIInfo(method: .GET, path: "items/{id}", meta: meta)
        super.init(config: config, info: apiInfo)
    }

    public func setup(#id: String) -> QiitaAPIGetItem {
        query = [String:AnyObject]()
        query["id"] = id

        var path = apiRequest.info.path
        path = replacePathPlaceholder(path, key: "id")
        apiRequest.request.URL = NSURL(string: path, relativeToURL: config.baseURL)
        return self
    }

    public func call(completionHandler: (QiitaAPIResponse, QiitaItem?) -> Void) {
        doRequest() { response in
            completionHandler(response, QiitaItem.fromData(response.data) as? QiitaItem)
        }
    }
}

public class QiitaAPIPostItem : QiitaAPIBase {
    public class Body : JsonGenEntityBase {
        var body: String = ""
        var coediting: Bool = false
        var gist: Bool?
        var `private`: Bool = false
        var tags: [QiitaTag] = [QiitaTag]()
        var title: String = ""
        var tweet: Bool?

        public override func toJsonDictionary() -> NSDictionary {
            var hash = NSMutableDictionary()
            // Encode body
            hash["body"] = encode(self.body)
            // Encode coediting
            hash["coediting"] = encode(self.coediting)
            // Encode gist
            if let x = self.gist {
                hash["gist"] = encode(x)
            }

            // Encode `private`
            hash["private"] = encode(self.`private`)
            // Encode tags
            hash["tags"] = self.tags.map {x in encode(x)}
            // Encode title
            hash["title"] = encode(self.title)
            // Encode tweet
            if let x = self.tweet {
                hash["tweet"] = encode(x)
            }

            return hash
        }

        public override class func fromJsonDictionary(hash: NSDictionary?) -> Body? {
            if let h = hash {
                var this = Body()
                // Decode body
                if let x = h["body"] as? String {
                    this.body = x
                } else {
                    return nil
                }

                // Decode coediting
                if let x = h["coediting"] as? Bool {
                    this.coediting = x
                } else {
                    return nil
                }

                // Decode gist
                this.gist = h["gist"] as? Bool
                // Decode `private`
                if let x = h["private"] as? Bool {
                    this.`private` = x
                } else {
                    return nil
                }

                // Decode tags
                if let xx = h["tags"] as? [NSDictionary] {
                    for x in xx {
                        if let obj = QiitaTag.fromJsonDictionary(x) {
                            this.tags.append(obj)
                        } else {
                            return nil
                        }
                    }
                } else {
                    return nil
                }

                // Decode title
                if let x = h["title"] as? String {
                    this.title = x
                } else {
                    return nil
                }

                // Decode tweet
                this.tweet = h["tweet"] as? Bool
                return this
            } else {
                return nil
            }
        }
    }

    public init(config: QiitaAPIConfigProtocol) {
        var meta = [String:AnyObject]()
        let apiInfo = QiitaAPIInfo(method: .POST, path: "items", meta: meta)
        super.init(config: config, info: apiInfo)
    }

    public func setup() -> QiitaAPIPostItem {
        query = [String:AnyObject]()

        var path = apiRequest.info.path
        apiRequest.request.URL = NSURL(string: path, relativeToURL: config.baseURL)
        return self
    }

    public func call(object: Body, completionHandler: (QiitaAPIResponse) -> Void) {
        doRequest(object) { response in
            completionHandler(response)
        }
    }
}

public class QiitaAPIPatchItem : QiitaAPIBase {
    public class Body : JsonGenEntityBase {
        var body: String = ""
        var coediting: Bool = false
        var `private`: Bool = false
        var tags: [QiitaTag] = [QiitaTag]()
        var title: String = ""

        public override func toJsonDictionary() -> NSDictionary {
            var hash = NSMutableDictionary()
            // Encode body
            hash["body"] = encode(self.body)
            // Encode coediting
            hash["coediting"] = encode(self.coediting)
            // Encode `private`
            hash["private"] = encode(self.`private`)
            // Encode tags
            hash["tags"] = self.tags.map {x in encode(x)}
            // Encode title
            hash["title"] = encode(self.title)
            return hash
        }

        public override class func fromJsonDictionary(hash: NSDictionary?) -> Body? {
            if let h = hash {
                var this = Body()
                // Decode body
                if let x = h["body"] as? String {
                    this.body = x
                } else {
                    return nil
                }

                // Decode coediting
                if let x = h["coediting"] as? Bool {
                    this.coediting = x
                } else {
                    return nil
                }

                // Decode `private`
                if let x = h["private"] as? Bool {
                    this.`private` = x
                } else {
                    return nil
                }

                // Decode tags
                if let xx = h["tags"] as? [NSDictionary] {
                    for x in xx {
                        if let obj = QiitaTag.fromJsonDictionary(x) {
                            this.tags.append(obj)
                        } else {
                            return nil
                        }
                    }
                } else {
                    return nil
                }

                // Decode title
                if let x = h["title"] as? String {
                    this.title = x
                } else {
                    return nil
                }

                return this
            } else {
                return nil
            }
        }
    }

    public init(config: QiitaAPIConfigProtocol) {
        var meta = [String:AnyObject]()
        let apiInfo = QiitaAPIInfo(method: .PATCH, path: "items/{id}", meta: meta)
        super.init(config: config, info: apiInfo)
    }

    public func setup(#id: String) -> QiitaAPIPatchItem {
        query = [String:AnyObject]()
        query["id"] = id

        var path = apiRequest.info.path
        path = replacePathPlaceholder(path, key: "id")
        apiRequest.request.URL = NSURL(string: path, relativeToURL: config.baseURL)
        return self
    }

    public func call(object: Body, completionHandler: (QiitaAPIResponse) -> Void) {
        doRequest(object) { response in
            completionHandler(response)
        }
    }
}

public class QiitaAPISamplePut : QiitaAPIBase {
    public class Response : JsonGenEntityBase {
        var count: Int = 0
        var tags: [QiitaTag] = [QiitaTag]()

        public override func toJsonDictionary() -> NSDictionary {
            var hash = NSMutableDictionary()
            // Encode count
            hash["count"] = encode(self.count)
            // Encode tags
            hash["tags"] = self.tags.map {x in encode(x)}
            return hash
        }

        public override class func fromJsonDictionary(hash: NSDictionary?) -> Response? {
            if let h = hash {
                var this = Response()
                // Decode count
                if let x = h["count"] as? Int {
                    this.count = x
                } else {
                    return nil
                }

                // Decode tags
                if let xx = h["tags"] as? [NSDictionary] {
                    for x in xx {
                        if let obj = QiitaTag.fromJsonDictionary(x) {
                            this.tags.append(obj)
                        } else {
                            return nil
                        }
                    }
                } else {
                    return nil
                }

                return this
            } else {
                return nil
            }
        }
    }

    public init(config: QiitaAPIConfigProtocol) {
        var meta = [String:AnyObject]()
        let apiInfo = QiitaAPIInfo(method: .PUT, path: "path/to/{id}/{key}", meta: meta)
        super.init(config: config, info: apiInfo)
    }

    public func setup(#`where`: String, id: String, key: String, page: Int? = nil, perPage: Int? = nil) -> QiitaAPISamplePut {
        query = [String:AnyObject]()
        query["where"] = `where`
        query["id"] = id
        query["key"] = key
        if let x = page { query["page"] = x }
        if let x = perPage { query["per_page"] = x }

        var path = apiRequest.info.path
        path = replacePathPlaceholder(path, key: "id")
        path = replacePathPlaceholder(path, key: "key")
        apiRequest.request.URL = NSURL(string: path, relativeToURL: config.baseURL)
        return self
    }

    public func call(object: [QiitaItem], completionHandler: (QiitaAPIResponse, Response?) -> Void) {
        doRequest(object) { response in
            completionHandler(response, Response.fromData(response.data) as? Response)
        }
    }
}

public class QiitaAPISamplePatch : QiitaAPIBase {
    public init(config: QiitaAPIConfigProtocol) {
        var meta = [String:AnyObject]()
        let apiInfo = QiitaAPIInfo(method: .PATCH, path: "path/to/{id}/{key}", meta: meta)
        super.init(config: config, info: apiInfo)
    }

    public func setup(#id: String, key: String) -> QiitaAPISamplePatch {
        query = [String:AnyObject]()
        query["id"] = id
        query["key"] = key

        var path = apiRequest.info.path
        path = replacePathPlaceholder(path, key: "id")
        path = replacePathPlaceholder(path, key: "key")
        apiRequest.request.URL = NSURL(string: path, relativeToURL: config.baseURL)
        return self
    }

    public func call(object: QiitaItem, completionHandler: (QiitaAPIResponse, [String]?) -> Void) {
        doRequest(object) { response in
            completionHandler(response, JsonGenObjectFromJsonData(response.data) as? [String])
        }
    }
}

public class QiitaAPISamplePostBinary : QiitaAPIBase {
    public class Response : JsonGenEntityBase {
        var url: String = ""

        public override func toJsonDictionary() -> NSDictionary {
            var hash = NSMutableDictionary()
            // Encode url
            hash["url"] = encode(self.url)
            return hash
        }

        public override class func fromJsonDictionary(hash: NSDictionary?) -> Response? {
            if let h = hash {
                var this = Response()
                // Decode url
                if let x = h["url"] as? String {
                    this.url = x
                } else {
                    return nil
                }

                return this
            } else {
                return nil
            }
        }
    }

    public init(config: QiitaAPIConfigProtocol) {
        var meta = [String:AnyObject]()
        let apiInfo = QiitaAPIInfo(method: .POST, path: "post/to/binary", meta: meta)
        super.init(config: config, info: apiInfo)
    }

    public func setup() -> QiitaAPISamplePostBinary {
        query = [String:AnyObject]()

        var path = apiRequest.info.path
        apiRequest.request.URL = NSURL(string: path, relativeToURL: config.baseURL)
        return self
    }

    public func call(object: NSData, completionHandler: (QiitaAPIResponse, Response?) -> Void) {
        doRequest(object) { response in
            completionHandler(response, Response.fromData(response.data) as? Response)
        }
    }
}
