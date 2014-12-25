import Foundation

public class QiitaTag : QiitaEntityBase {
    var name: String = ""
    var versions: [String] = [String]()

    public override func toJsonDictionary() -> NSDictionary {
        var hash = NSMutableDictionary()
        // Encode name
        hash["name"] = self.encodeObject(self.name)
        // Encode versions
        hash["versions"] = encodeObject(self.versions)
        return hash
    }

    public override class func fromJsonDictionary(hash: NSDictionary?) -> QiitaTag? {
        if let h = hash {
            var this = QiitaTag()
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

