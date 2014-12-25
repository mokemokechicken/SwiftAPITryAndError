import Foundation

public class QiitaAPIError : QiitaEntityBase {
    var message: String = ""
    var type: String = ""

    public override func toJsonDictionary() -> NSDictionary {
        var hash = NSMutableDictionary()
        // Encode message
        hash["message"] = self.encodeObject(self.message)
        // Encode type
        hash["type"] = self.encodeObject(self.type)
        return hash
    }

    public override class func fromJsonDictionary(hash: NSDictionary?) -> QiitaAPIError? {
        if let h = hash {
            var this = QiitaAPIError()
            // Decode message
            if let x = h["message"] as? String {
                this.message = x
            } else {
                return nil
            }

            // Decode type
            if let x = h["type"] as? String {
                this.type = x
            } else {
                return nil
            }

            return this
        } else {
            return nil
        }
    }
}

