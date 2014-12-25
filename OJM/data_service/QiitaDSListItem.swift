    import Foundation

public class QiitaDSListItem<DataType> : QiitaDS<DataType> {
    public typealias DataType = [QiitaItem]
    public typealias ErrorType = QiitaAPIError

    public override init(factory: QiitaAPIFactory) {
        super.init(factory: factory)
    }

    private func cacheKeyFor(page: Int? = nil, perPage: Int? = nil) -> String {
        var params = [String:AnyObject]()
        if let x = page { params["page"] = x }
        if let x = perPage { params["per_page"] = x }
        return QiitaAPIURLUtil.makeQueryString(params)
    }

    public func data(page: Int? = nil, perPage: Int? = nil) -> [QiitaItem]? {
        let key = cacheKeyFor(page: page, perPage: perPage)
        return findInCache(key) as? [QiitaItem]
    }

    public func request(page: Int? = nil, perPage: Int? = nil) {
        factory.createListItem().setup(page: page, perPage: perPage).call { res, o in
            var object = self.requestedObjectConverter(o)
            if let x = object {
                let key = self.cacheKeyFor(page: page, perPage: perPage)
                self.storeInCache(key, object: x)
            }
            self.notify(object, status: QiitaDSStatus(response: res))
        }
    }

    public func fetchParseError(status: QiitaDSStatus) -> QiitaAPIError? {
        return QiitaAPIListItem.errorInfo(status.response)
    }
}
