import Foundation

public class QiitaItem : QiitaEntityBase {
    var body: String = ""
    var coediting: Bool = false
    var createdAt: String = ""
    var id: String = ""
    var `private`: Bool?
    var tags: [QiitaTag] = [QiitaTag]()
    var title: String = ""
    var updatedAt: String = ""
    var url: String = ""
    var user: QiitaUser = QiitaUser()

    public override func toJsonDictionary() -> NSDictionary {
        var hash = NSMutableDictionary()
        // Encode body
        hash["body"] = self.encodeObject(self.body)
        // Encode coediting
        hash["coediting"] = self.encodeObject(self.coediting)
        // Encode createdAt
        hash["created_at"] = self.encodeObject(self.createdAt)
        // Encode id
        hash["id"] = self.encodeObject(self.id)
        // Encode `private`
        if let x = self.`private` {
            hash["private"] = self.encodeObject(x)
        }

        // Encode tags
        hash["tags"] = encodeObject(self.tags)
        // Encode title
        hash["title"] = self.encodeObject(self.title)
        // Encode updatedAt
        hash["updated_at"] = self.encodeObject(self.updatedAt)
        // Encode url
        hash["url"] = self.encodeObject(self.url)
        // Encode user
        hash["user"] = self.user.toJsonDictionary()
        return hash
    }

    public override class func fromJsonDictionary(hash: NSDictionary?) -> QiitaItem? {
        if let h = hash {
            var this = QiitaItem()
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

            // Decode `private`
            this.`private` = h["private"] as? Bool
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
            if let x = QiitaUser.fromJsonDictionary((h["user"] as? NSDictionary)) {
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

