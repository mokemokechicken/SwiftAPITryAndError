public class QiitaDataService<ET:AnyObject> {
    public typealias NotificationHandler = (ET?, NSError?) -> Void

    private var observers = [(AnyObject, NotificationHandler)]()

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
    
    public func notify(data: ET?, error: NSError?) {
        for observer in observers {
            observer.1(data, error)
        }
    }
}



import Foundation

let f = QiitaAPIFactory(config: QiitaAPIConfig(baseURL: NSURL(string: "")!))

public class QiitaServiceLocator {
    public init() {}
    public var dataServiceGetItem: QiitaDataServiceGetItem<QiitaItem>!
    
    public convenience init(factory: QiitaAPIFactory) {
        self.init()
        self.dataServiceGetItem = QiitaDataServiceGetItem(factory: f)
    }
}

public class QiitaDataServiceGetItem<ET:QiitaItem> : QiitaDataService<ET> {
    public typealias ET = QiitaItem

    public override init(factory: QiitaAPIFactory) {
        super.init(factory: factory)
    }

    public func findInCache(params: AnyObject) -> ET? {
        return nil
    }

    public func request(_body_: AnyObject, id: String) {
        factory.createGetItem().setup(id: id).call { res, item in
            self.notify(item, error: res.error)
        }
    }
}
