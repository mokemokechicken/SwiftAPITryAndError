import Foundation

public class QiitaAPIPostItem : QiitaAPIBase {
    public class Body : QiitaEntityBase {
        var body: String = ""
        var coediting: Bool = false
        var gist: Bool?
        var `private`: Bool = false
        var tags: [QiitaTag] = [QiitaTag]()
        var title: String = ""
        var tweet: Bool?

        public override func toJsonDictionary() -> NSDictionary {
            var hash = NSMutableDictionary()
            // Encode body
            hash["body"] = self.encodeObject(self.body)
            // Encode coediting
            hash["coediting"] = self.encodeObject(self.coediting)
            // Encode gist
            if let x = self.gist {
                hash["gist"] = self.encodeObject(x)
            }

            // Encode `private`
            hash["private"] = self.encodeObject(self.`private`)
            // Encode tags
            hash["tags"] = encodeObject(self.tags)
            // Encode title
            hash["title"] = self.encodeObject(self.title)
            // Encode tweet
            if let x = self.tweet {
                hash["tweet"] = self.encodeObject(x)
            }

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

                // Decode gist
                this.gist = h["gist"] as? Bool
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

                // Decode tweet
                this.tweet = h["tweet"] as? Bool
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
        let apiInfo = QiitaAPIInfo(method: .POST, path: "items", meta: meta)
        super.init(config: config, info: apiInfo)
    }

    public func setup() -> QiitaAPIPostItem {
        query = [String:AnyObject]()

        var path = apiRequest.info.path
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
