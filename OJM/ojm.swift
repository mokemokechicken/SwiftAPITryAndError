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

    public func toJsonData() -> NSData {
        var obj = toJsonDictionary()
        return NSJSONSerialization.dataWithJSONObject(obj, options: NSJSONWritingOptions.PrettyPrinted, error: nil)!
    }

    public func toJsonString() -> NSString {
        return NSString(data: toJsonData(), encoding: NSUTF8StringEncoding)!
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
    var description: String = ""
    var facebookId: String = ""
    var followeesCount: Int = 0
    var followersCount: Int = 0
    var githubLoginName: String = ""
    var id: String = ""
    var itemsCount: Int = 0
    var linkedinId: String = ""
    var location: String = ""
    var name: String = ""
    var organization: String = ""
    var profileImageUrl: String = ""
    var twitterScreenName: String = ""
    var websiteUrl: String = ""

    public override func toJsonDictionary() -> NSDictionary {
        var hash = NSMutableDictionary()
        // Encode description
        hash["description"] = encode(self.description)
        // Encode facebookId
        hash["facebook_id"] = encode(self.facebookId)
        // Encode followeesCount
        hash["followees_count"] = encode(self.followeesCount)
        // Encode followersCount
        hash["followers_count"] = encode(self.followersCount)
        // Encode githubLoginName
        hash["github_login_name"] = encode(self.githubLoginName)
        // Encode id
        hash["id"] = encode(self.id)
        // Encode itemsCount
        hash["items_count"] = encode(self.itemsCount)
        // Encode linkedinId
        hash["linkedin_id"] = encode(self.linkedinId)
        // Encode location
        hash["location"] = encode(self.location)
        // Encode name
        hash["name"] = encode(self.name)
        // Encode organization
        hash["organization"] = encode(self.organization)
        // Encode profileImageUrl
        hash["profile_image_url"] = encode(self.profileImageUrl)
        // Encode twitterScreenName
        hash["twitter_screen_name"] = encode(self.twitterScreenName)
        // Encode websiteUrl
        hash["website_url"] = encode(self.websiteUrl)
        return hash
    }

    public override class func fromJsonDictionary(hash: NSDictionary?) -> User? {
        if let h = hash {
            var this = User()
            // Decode description
            if let x = h["description"] as? String {
                this.description = x
            } else {
                return nil
            }

            // Decode facebookId
            if let x = h["facebook_id"] as? String {
                this.facebookId = x
            } else {
                return nil
            }

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
            if let x = h["github_login_name"] as? String {
                this.githubLoginName = x
            } else {
                return nil
            }

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
            if let x = h["linkedin_id"] as? String {
                this.linkedinId = x
            } else {
                return nil
            }

            // Decode location
            if let x = h["location"] as? String {
                this.location = x
            } else {
                return nil
            }

            // Decode name
            if let x = h["name"] as? String {
                this.name = x
            } else {
                return nil
            }

            // Decode organization
            if let x = h["organization"] as? String {
                this.organization = x
            } else {
                return nil
            }

            // Decode profileImageUrl
            if let x = h["profile_image_url"] as? String {
                this.profileImageUrl = x
            } else {
                return nil
            }

            // Decode twitterScreenName
            if let x = h["twitter_screen_name"] as? String {
                this.twitterScreenName = x
            } else {
                return nil
            }

            // Decode websiteUrl
            if let x = h["website_url"] as? String {
                this.websiteUrl = x
            } else {
                return nil
            }

            return this
        } else {
            return nil
        }
    }
}

