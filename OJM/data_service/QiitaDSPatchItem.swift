    import Foundation

public class QiitaDSPatchItem<DataType> : QiitaDS<DataType> {
    public typealias DataType = NSNull
    public typealias ErrorType = QiitaAPIError
    public typealias BodyType = QiitaAPIPatchItem.BodyType

    public override init(factory: QiitaAPIFactory) {
        super.init(factory: factory)
    }

    private func cacheKeyFor(#id: String) -> String {
        var params = [String:AnyObject]()
        params["id"] = id
        return QiitaAPIURLUtil.makeQueryString(params)
    }

    public func data(#id: String) -> NSNull? {
        let key = cacheKeyFor(id: id)
        return findInCache(key) as? NSNull
    }

    public func request(Body: QiitaAPIPatchItem.Body, id: String) {
        factory.createPatchItem().setup(id: id).call(Body) { res in
            self.notify(nil, status: QiitaDSStatus(response: res))
        }
    }

    public func fetchParseError(status: QiitaDSStatus) -> QiitaAPIError? {
        return QiitaAPIPatchItem.errorInfo(status.response)
    }
}
