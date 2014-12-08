import Foundation

private func encode(obj: AnyObject?) -> AnyObject {
    switch obj {
    case nil:
        return NSNull()
        
    case let ojmObject as JsonGenEntityBase:
        return ojmObject.toJsonDictionary()
        
    default:
        return obj!
    }
}

private func decodeOptional(obj: AnyObject?) -> AnyObject? {
    switch obj {
    case let x as NSNull:
        return nil
    
    default:
        return obj
    }
}

public class JsonGenEntityBase {
    public init() {
    }

    public func toJsonDictionary() -> NSDictionary {
        return NSDictionary()
    }

    public class func toJsonArray(entityList: [JsonGenEntityBase]) -> NSArray {
        return entityList.map {x in encode(x)}
    }

    public class func toJsonData(entityList: [JsonGenEntityBase], pritty: Bool = false) -> NSData {
        var obj = toJsonArray(entityList)
        return toJson(obj, pritty: pritty)
    }

    public func toJsonData(pritty: Bool = false) -> NSData {
        var obj = toJsonDictionary()
        return JsonGenEntityBase.toJson(obj, pritty: pritty)
    }

    public class func toJsonString(entityList: [JsonGenEntityBase], pritty: Bool = false) -> NSString {
        return NSString(data: toJsonData(entityList, pritty: pritty), encoding: NSUTF8StringEncoding)!
    }

    public func toJsonString(pritty: Bool = false) -> NSString {
        return NSString(data: toJsonData(pritty: pritty), encoding: NSUTF8StringEncoding)!
    }

    public class func fromData(data: NSData!) -> AnyObject? {
        if data == nil {
            return nil
        }

        var object = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: nil) as? NSObject
        switch object {
        case let hash as NSDictionary:
            return fromJsonDictionary(hash)

        case let array as NSArray:
            return fromJsonArray(array)

        default:
            return nil
        }
    }

    public class func fromJsonDictionary(hash: NSDictionary?) -> JsonGenEntityBase? {
        return nil
    }

    public class func fromJsonArray(array: NSArray?) -> [JsonGenEntityBase]? {
        if array == nil {
            return nil
        }
        var ret = [JsonGenEntityBase]()
        if let xx = array as? [NSDictionary] {
            for x in xx {
                if let obj = fromJsonDictionary(x) {
                    ret.append(obj)
                } else {
                    return nil
                }
            }
        } else {
            return nil
        }
        return ret
    }

    private class func toJson(obj: NSObject, pritty: Bool = false) -> NSData {
        let options = pritty ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions.allZeros
        return NSJSONSerialization.dataWithJSONObject(obj, options: options, error: nil)!
    }
}

public class Tag : JsonGenEntityBase {
    var name: String = ""
    var versions: [String] = [String]()

    public override func toJsonDictionary() -> NSDictionary {
        var hash = NSMutableDictionary()
        // Encode name
        hash["name"] = encode(self.name)
        // Encode versions
        hash["versions"] = self.versions.map {x in encode(x)}
        return hash
    }

    public override class func fromJsonDictionary(hash: NSDictionary?) -> Tag? {
        if let h = hash {
            var this = Tag()
            // Decode name
            if let x = h["name"] as? String {
                this.name = x
            } else {
                return nil
            }

            // Decode versions
            if let xx = h["versions"] as? [String] {
                this.versions = xx
            } else {
                return nil
            }

            return this
        } else {
            return nil
        }
    }
}

public class Item : JsonGenEntityBase {
    var body: String = ""
    var coediting: Bool = false
    var createdAt: String = ""
    var id: String = ""
    var Private: Bool?
    var tags: [Tag] = [Tag]()
    var title: String = ""
    var updatedAt: String = ""
    var url: String = ""
    var user: User = User()

    public override func toJsonDictionary() -> NSDictionary {
        var hash = NSMutableDictionary()
        // Encode body
        hash["body"] = encode(self.body)
        // Encode coediting
        hash["coediting"] = encode(self.coediting)
        // Encode createdAt
        hash["created_at"] = encode(self.createdAt)
        // Encode id
        hash["id"] = encode(self.id)
        // Encode Private
        if let x = self.Private {
            hash["_private"] = encode(x)
        }

        // Encode tags
        hash["tags"] = self.tags.map {x in encode(x)}
        // Encode title
        hash["title"] = encode(self.title)
        // Encode updatedAt
        hash["updated_at"] = encode(self.updatedAt)
        // Encode url
        hash["url"] = encode(self.url)
        // Encode user
        hash["user"] = self.user.toJsonDictionary()
        return hash
    }

    public override class func fromJsonDictionary(hash: NSDictionary?) -> Item? {
        if let h = hash {
            var this = Item()
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

            // Decode createdAt
            if let x = h["created_at"] as? String {
                this.createdAt = x
            } else {
                return nil
            }

            // Decode id
            if let x = h["id"] as? String {
                this.id = x
            } else {
                return nil
            }

            // Decode Private
            this.Private = h["_private"] as? Bool
            // Decode tags
            if let xx = h["tags"] as? [NSDictionary] {
                for x in xx {
                    if let obj = Tag.fromJsonDictionary(x) {
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

            // Decode updatedAt
            if let x = h["updated_at"] as? String {
                this.updatedAt = x
            } else {
                return nil
            }

            // Decode url
            if let x = h["url"] as? String {
                this.url = x
            } else {
                return nil
            }

            // Decode user
            if let x = User.fromJsonDictionary((h["user"] as? NSDictionary)) {
                this.user = x
            } else {
                return nil
            }

            return this
        } else {
            return nil
        }
    }
}

public class User : JsonGenEntityBase {
    var description: String?
    var facebookId: String?
    var followeesCount: Int = 0
    var followersCount: Int = 0
    var githubLoginName: String?
    var id: String = ""
    var itemsCount: Int = 0
    var linkedinId: String?
    var location: String?
    var name: String?
    var organization: String?
    var profileImageUrl: String?
    var twitterScreenName: String?
    var websiteUrl: String?

    public override func toJsonDictionary() -> NSDictionary {
        var hash = NSMutableDictionary()
        // Encode description
        if let x = self.description {
            hash["description"] = encode(x)
        }

        // Encode facebookId
        if let x = self.facebookId {
            hash["facebook_id"] = encode(x)
        }

        // Encode followeesCount
        hash["followees_count"] = encode(self.followeesCount)
        // Encode followersCount
        hash["followers_count"] = encode(self.followersCount)
        // Encode githubLoginName
        if let x = self.githubLoginName {
            hash["github_login_name"] = encode(x)
        }

        // Encode id
        hash["id"] = encode(self.id)
        // Encode itemsCount
        hash["items_count"] = encode(self.itemsCount)
        // Encode linkedinId
        if let x = self.linkedinId {
            hash["linkedin_id"] = encode(x)
        }

        // Encode location
        if let x = self.location {
            hash["location"] = encode(x)
        }

        // Encode name
        if let x = self.name {
            hash["name"] = encode(x)
        }

        // Encode organization
        if let x = self.organization {
            hash["organization"] = encode(x)
        }

        // Encode profileImageUrl
        if let x = self.profileImageUrl {
            hash["profile_image_url"] = encode(x)
        }

        // Encode twitterScreenName
        if let x = self.twitterScreenName {
            hash["twitter_screen_name"] = encode(x)
        }

        // Encode websiteUrl
        if let x = self.websiteUrl {
            hash["website_url"] = encode(x)
        }

        return hash
    }

    public override class func fromJsonDictionary(hash: NSDictionary?) -> User? {
        if let h = hash {
            var this = User()
            // Decode description
            this.description = h["description"] as? String
            // Decode facebookId
            this.facebookId = h["facebook_id"] as? String
            // Decode followeesCount
            if let x = h["followees_count"] as? Int {
                this.followeesCount = x
            } else {
                return nil
            }

            // Decode followersCount
            if let x = h["followers_count"] as? Int {
                this.followersCount = x
            } else {
                return nil
            }

            // Decode githubLoginName
            this.githubLoginName = h["github_login_name"] as? String
            // Decode id
            if let x = h["id"] as? String {
                this.id = x
            } else {
                return nil
            }

            // Decode itemsCount
            if let x = h["items_count"] as? Int {
                this.itemsCount = x
            } else {
                return nil
            }

            // Decode linkedinId
            this.linkedinId = h["linkedin_id"] as? String
            // Decode location
            this.location = h["location"] as? String
            // Decode name
            this.name = h["name"] as? String
            // Decode organization
            this.organization = h["organization"] as? String
            // Decode profileImageUrl
            this.profileImageUrl = h["profile_image_url"] as? String
            // Decode twitterScreenName
            this.twitterScreenName = h["twitter_screen_name"] as? String
            // Decode websiteUrl
            this.websiteUrl = h["website_url"] as? String
            return this
        } else {
            return nil
        }
    }
}

