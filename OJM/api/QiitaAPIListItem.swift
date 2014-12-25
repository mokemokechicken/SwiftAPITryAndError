import Foundation

public class QiitaAPIListItem : QiitaAPIBase {
    public typealias EntityType = [QiitaItem]
    public typealias ErrorType = QiitaAPIError

    public init(config: QiitaAPIConfigProtocol) {
        var meta = [String:AnyObject]()
        let apiInfo = QiitaAPIInfo(method: .GET, path: "items", meta: meta)
        super.init(config: config, info: apiInfo)
    }

    public func setup(page: Int? = nil, perPage: Int? = nil) -> QiitaAPIListItem {
        query = [String:AnyObject]()
        if let x = page { query["page"] = x }
        if let x = perPage { query["per_page"] = x }

        var path = apiRequest.info.path
        apiRequest.request.URL = NSURL(string: path, relativeToURL: config.baseURL)
        return self
    }

    public func call(completionHandler: (QiitaAPIResponse, [QiitaItem]?) -> Void) {
        doRequest() { response in
            completionHandler(response, QiitaItem.fromData(response.data) as? [QiitaItem])
        }
    }

    public class func errorInfo(response: QiitaAPIResponse) -> QiitaAPIError? {
        return ErrorType.fromData(response.data) as ErrorType?
    }
}
