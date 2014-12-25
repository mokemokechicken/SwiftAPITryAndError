    import Foundation

public class QiitaAPIPatchItem : QiitaAPIBase {
    public class Body : QiitaEntityBase {
        var body: String = ""
        var coediting: Bool = false
        var `private`: Bool = false
        var tags: [QiitaTag] = [QiitaTag]()
        var title: String = ""

        public override func toJsonDictionary() -> NSDictionary {
            var hash = NSMutableDictionary()
            // Encode body
            hash["body"] = self.encodeObject(self.body)
            // Encode coediting
            hash["coediting"] = self.encodeObject(self.coediting)
            // Encode `private`
            hash["private"] = self.encodeObject(self.`private`)
            // Encode tags
            hash["tags"] = encodeObject(self.tags)
            // Encode title
            hash["title"] = self.encodeObject(self.title)
            return hash
        }

        public override class func fromJsonDictionary(hash: NSDictionary?) -> Body? {
            if let h = hash {
                var this = Body()
                // Decode body
                if let x = h["body"] as? String {
                    this.body = x
                } else {
                    return nil
                }

                // Decode coediting
                if let x = h["coediting"] as? Bool {
                    this.coediting = x
                } else {
                    return nil
                }

                // Decode `private`
                if let x = h["private"] as? Bool {
                    this.`private` = x
                } else {
                    return nil
                }

                // Decode tags
                if let xx = h["tags"] as? [NSDictionary] {
                    for x in xx {
                        if let obj = QiitaTag.fromJsonDictionary(x) {
                            this.tags.append(obj)
                        } else {
                            return nil
                        }
                    }
                } else {
                    return nil
                }

                // Decode title
                if let x = h["title"] as? String {
                    this.title = x
                } else {
                    return nil
                }

                return this
            } else {
                return nil
            }
        }
    }

    public typealias ErrorType = QiitaAPIError
    public typealias BodyType = Body

    public init(config: QiitaAPIConfigProtocol) {
        var meta = [String:AnyObject]()
        let apiInfo = QiitaAPIInfo(method: .PATCH, path: "items/{id}", meta: meta)
        super.init(config: config, info: apiInfo)
    }

    public func setup(#id: String) -> QiitaAPIPatchItem {
        query = [String:AnyObject]()
        query["id"] = id

        var path = apiRequest.info.path
        path = replacePathPlaceholder(path, key: "id")
        apiRequest.request.URL = NSURL(string: path, relativeToURL: config.baseURL)
        return self
    }

    public func call(object: Body, completionHandler: (QiitaAPIResponse) -> Void) {
        doRequest(object) { response in
            completionHandler(response)
        }
    }

    public class func errorInfo(response: QiitaAPIResponse) -> QiitaAPIError? {
        return ErrorType.fromData(response.data) as ErrorType?
    }
}

