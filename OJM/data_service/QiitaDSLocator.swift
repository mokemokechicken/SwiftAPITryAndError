    import Foundation

public class QiitaDSLocator {
    public var ListItem: QiitaDSListItem<[QiitaItem]>!
    public var GetItem: QiitaDSGetItem<QiitaItem>!
    public var PostItem: QiitaDSPostItem<NSNull>!
    public var PatchItem: QiitaDSPatchItem<NSNull>!

    public convenience init(factory: QiitaAPIFactory) {
        self.init()
        self.ListItem = QiitaDSListItem(factory: factory)
        self.GetItem = QiitaDSGetItem(factory: factory)
        self.PostItem = QiitaDSPostItem(factory: factory)
        self.PatchItem = QiitaDSPatchItem(factory: factory)
    }
}
