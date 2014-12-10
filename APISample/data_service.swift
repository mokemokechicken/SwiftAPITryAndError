public class QiitaDataService<ET:AnyObject> {
    public typealias NotificationHandler = (ET?, NSError?) -> Void

    private var observers = [(AnyObject, NotificationHandler)]()
    private var cache = [String:ET]()
    public var enableCache = true

    let factory: QiitaAPIFactory
    
    public init(factory: QiitaAPIFactory) {
        self.factory = factory
    }

    public func addObserver(object: AnyObject, handler: NotificationHandler) {
        observers.append((object, handler))
    }
    
    public func removeObserver(object: AnyObject) {
        observers = observers.filter { $0.0 !== object}
    }
    
    private func findInCache(key: String) -> ET? {
        var ret: ET?
        ret = self.cache[key]
        return ret
    }
    
    private func storeInCache(key:String, object: ET?) {
        if let o = object {
            if enableCache {
                self.cache[key] = o
            }
        } else {
            self.cache.removeValueForKey(key)
        }
    }
    
    public func clearCache() {
        self.cache.removeAll(keepCapacity: false)
    }
    
    public func notify(data: ET?, error: NSError?) {
        for observer in observers {
            observer.1(data, error)
        }
    }
}

private class URLUtil {
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


import Foundation

let f = QiitaAPIFactory(config: QiitaAPIConfig(baseURL: NSURL(string: "")!))

public class QiitaDataServiceLocator {
    public var dataServiceGetItem: QiitaDataServiceGetItem<QiitaItem>!
    
    public convenience init(factory: QiitaAPIFactory) {
        self.init()
        self.dataServiceGetItem = QiitaDataServiceGetItem(factory: factory)
    }
}

public class QiitaDataServiceGetItem<ET:QiitaItem> : QiitaDataService<ET> {
    public typealias ET = QiitaItem

    public override init(factory: QiitaAPIFactory) {
        super.init(factory: factory)
    }
    
    private func cacheKeyFor(id: String) -> String {
        var params = [String: AnyObject]()
        params["id"] = id
        return URLUtil.makeQueryString(params)
    }
    
    public func data(id: String) -> ET? {
        let key = cacheKeyFor(id)
        return findInCache(key)
    }

    public func request(_body_: AnyObject, id: String) {
        factory.createGetItem().setup(id: id).call { res, item in
            if let x = item {
                let key = self.cacheKeyFor(id)
                self.storeInCache(key, object: item)
            }
            self.notify(item, error: res.error)
        }
    }

}
