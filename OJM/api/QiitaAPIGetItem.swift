import Foundation

public class QiitaAPIGetItem : QiitaAPIBase {
    public typealias EntityType = QiitaItem
    public typealias ErrorType = QiitaAPIError

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

    public class func errorInfo(response: QiitaAPIResponse) -> QiitaAPIError? {
        return ErrorType.fromData(response.data) as ErrorType?
    }
}
