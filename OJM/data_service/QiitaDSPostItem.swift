    import Foundation

public class QiitaDSPostItem<DataType> : QiitaDS<DataType> {
    public typealias DataType = NSNull
    public typealias ErrorType = QiitaAPIError
    public typealias BodyType = QiitaAPIPostItem.BodyType

    public override init(factory: QiitaAPIFactory) {
        super.init(factory: factory)
    }

    private func cacheKeyFor() -> String { return "_" }

    public func data() -> NSNull? {
        let key = cacheKeyFor()
        return findInCache(key) as? NSNull
    }

    public func request(Body: QiitaAPIPostItem.Body) {
        factory.createPostItem().setup().call(Body) { res in
            self.notify(nil, status: QiitaDSStatus(response: res))
        }
    }

    public func fetchParseError(status: QiitaDSStatus) -> QiitaAPIError? {
        return QiitaAPIPostItem.errorInfo(status.response)
    }
}
