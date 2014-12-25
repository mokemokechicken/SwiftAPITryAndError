    import Foundation

public class QiitaDSGetItem<DataType> : QiitaDS<DataType> {
    public typealias DataType = QiitaItem
    public typealias ErrorType = QiitaAPIError

    public override init(factory: QiitaAPIFactory) {
        super.init(factory: factory)
    }

    private func cacheKeyFor(#id: String) -> String {
        var params = [String:AnyObject]()
        params["id"] = id
        return QiitaAPIURLUtil.makeQueryString(params)
    }

    public func data(#id: String) -> QiitaItem? {
        let key = cacheKeyFor(id: id)
        return findInCache(key) as? QiitaItem
    }

    public func request(#id: String) {
        factory.createGetItem().setup(id: id).call { res, o in
            var object = self.requestedObjectConverter(o)
            if let x = object {
                let key = self.cacheKeyFor(id: id)
                self.storeInCache(key, object: x)
            }
            self.notify(object, status: QiitaDSStatus(response: res))
        }
    }

    public func fetchParseError(status: QiitaDSStatus) -> QiitaAPIError? {
        return QiitaAPIGetItem.errorInfo(status.response)
    }
}
