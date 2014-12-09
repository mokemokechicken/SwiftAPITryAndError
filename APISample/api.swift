import Foundation

public class Factory {
    public let config: YOUSEI_API_GENERATOR_PREFIX_ConfigProtocol
    
    public init(config: YOUSEI_API_GENERATOR_PREFIX_ConfigProtocol) {
        self.config = config
    }
    
    // ADD Custom
    public func createGetItem() -> GetItem {
        return GetItem(config: config)
    }
}


public class GetItem : YOUSEI_API_GENERATOR_PREFIX_Base {
    public init(config: YOUSEI_API_GENERATOR_PREFIX_ConfigProtocol) {
        var meta = [String:AnyObject]()
        let apiInfo = YOUSEI_API_GENERATOR_PREFIX_Info(method: .GET, path: "items", meta: meta)
        super.init(config: config, info: apiInfo)
    }
    
    func setup(page: Int? = nil, perPage: Int? = nil, userId: Int? = nil) -> GetItem {
        query = [String:AnyObject]()
        if let x = page { query["page"] = x }
        if let x = perPage { query["per_page"] = x }
        if let x = userId { query["user_id"] = x }

        // Convert PATH
        var path = apiRequest.info.path
        path = replacePathPlaceholder(path, key: "user_id")
        apiRequest.request.URL = NSURL(string: path, relativeToURL: config.baseURL)
        return self
    }

    func call(completionHandler: (YOUSEI_API_GENERATOR_PREFIX_Response, [Item]?) -> Void) {
        doRequest() { response in
            completionHandler(response, Item.fromData(response.data) as? [Item])
        }
    }
}

public class SomePost : YOUSEI_API_GENERATOR_PREFIX_Base {
    public init(config: YOUSEI_API_GENERATOR_PREFIX_ConfigProtocol) {
        var meta = [String:String]()
        let apiInfo = YOUSEI_API_GENERATOR_PREFIX_Info(method: .POST, path: "some_post", meta: meta)
        super.init(config: config, info: apiInfo)
    }
    
    public class Params {
        public var userId: Int
        
        public init(userId: Int) {
            self.userId = userId
        }
        
        public func toDictionary() -> [String:AnyObject] {
            var ret = [String:AnyObject]()
            ret["user_id"] = userId
            return ret
        }
    }
    
    func call(object: User, completionHandler: ((YOUSEI_API_GENERATOR_PREFIX_Response, [Item]?) -> Void)) {
        doRequest(object) { response in
            completionHandler(response, Item.fromData(response.data) as? [Item])
        }
    }
}

