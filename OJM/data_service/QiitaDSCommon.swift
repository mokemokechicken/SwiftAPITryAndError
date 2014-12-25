    import Foundation

public class QiitaDS<ET> {
    public typealias NotificationHandler = (ET?, QiitaDSStatus) -> Void
    public var requestedObjectConverter: ET? -> ET? = { $0 }

    let factory: QiitaAPIFactory
    public init(factory: QiitaAPIFactory) {
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

    func notify(data: ET?, status: QiitaDSStatus) {
        factory.config.log("\(self) notify")
        for observer in observers {
            observer.1(data, status)
        }
    }

    private var cache = [String:Any]()
    public var enableCache = true

    func findInCache(key: String) -> Any? {
        return self.cache[key]
    }

    func storeInCache(key:String, object: Any?) {
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

public class QiitaDSStatus {
    public let response: QiitaAPIResponse

    public init(response: QiitaAPIResponse) {
        self.response = response
    }
}


