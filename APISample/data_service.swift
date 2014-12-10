public class QiitaDS<ET> {
    public typealias NotificationHandler = (ET?, QQQiitaDSStatus?) -> Void
    
    let factory: QQQiitaAPIFactory
    public init(factory: QQQiitaAPIFactory) {
        self.factory = factory
    }
    
    private var observers = [(AnyObject, NotificationHandler)]()
    public func addObserver(object: AnyObject, handler: NotificationHandler) {
        factory.config.log("\(self) addObserver \(object)")
        observers.append((object, handler))
    }
    
    public func removeObserver(object: AnyObject) {
        factory.config.log("\(self) removeObserver \(object)")
        observers = observers.filter { $0.0 !== object}
    }
    
    public func notify(data: ET?, status: QQQiitaDSStatus) {
        factory.config.log("\(self) notify")
        for observer in observers {
            observer.1(data, status)
        }
    }
    
    private var cache = [String:Any]()
    public var enableCache = true
    
    private func findInCache(key: String) -> Any? {
        return self.cache[key]
    }
    
    private func storeInCache(key:String, object: Any?) {
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
}
