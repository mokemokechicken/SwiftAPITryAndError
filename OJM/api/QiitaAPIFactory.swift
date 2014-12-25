import Foundation

public class QiitaAPIFactory {
    public let config: QiitaAPIConfigProtocol
    public init(config: QiitaAPIConfigProtocol) {
        self.config = config
    }
    public func createListItem() -> QiitaAPIListItem {
        return QiitaAPIListItem(config: config)
    }
    public func createGetItem() -> QiitaAPIGetItem {
        return QiitaAPIGetItem(config: config)
    }
    public func createPostItem() -> QiitaAPIPostItem {
        return QiitaAPIPostItem(config: config)
    }
    public func createPatchItem() -> QiitaAPIPatchItem {
        return QiitaAPIPatchItem(config: config)
    }
}
