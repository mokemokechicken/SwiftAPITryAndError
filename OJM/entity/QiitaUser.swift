import Foundation

public class QiitaUser : QiitaEntityBase {
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
            hash["description"] = self.encodeObject(x)
        }

        // Encode facebookId
        if let x = self.facebookId {
            hash["facebook_id"] = self.encodeObject(x)
        }

        // Encode followeesCount
        hash["followees_count"] = self.encodeObject(self.followeesCount)
        // Encode followersCount
        hash["followers_count"] = self.encodeObject(self.followersCount)
        // Encode githubLoginName
        if let x = self.githubLoginName {
            hash["github_login_name"] = self.encodeObject(x)
        }

        // Encode id
        hash["id"] = self.encodeObject(self.id)
        // Encode itemsCount
        hash["items_count"] = self.encodeObject(self.itemsCount)
        // Encode linkedinId
        if let x = self.linkedinId {
            hash["linkedin_id"] = self.encodeObject(x)
        }

        // Encode location
        if let x = self.location {
            hash["location"] = self.encodeObject(x)
        }

        // Encode name
        if let x = self.name {
            hash["name"] = self.encodeObject(x)
        }

        // Encode organization
        if let x = self.organization {
            hash["organization"] = self.encodeObject(x)
        }

        // Encode profileImageUrl
        if let x = self.profileImageUrl {
            hash["profile_image_url"] = self.encodeObject(x)
        }

        // Encode twitterScreenName
        if let x = self.twitterScreenName {
            hash["twitter_screen_name"] = self.encodeObject(x)
        }

        // Encode websiteUrl
        if let x = self.websiteUrl {
            hash["website_url"] = self.encodeObject(x)
        }

        return hash
    }

    public override class func fromJsonDictionary(hash: NSDictionary?) -> QiitaUser? {
        if let h = hash {
            var this = QiitaUser()
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

