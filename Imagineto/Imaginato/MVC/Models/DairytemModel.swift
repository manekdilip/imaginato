//
//  LibraryItemModel.swift


import UIKit
class DairytemModel: NSObject {

    var id = ""
    var title = ""
    var content = ""
    var date = ""
    
    override init() {
    }
    
    init(withJason:[String:Any]) {
        self.id = createString(value: withJason["id"] as AnyObject)
        self.title = createString(value: withJason["title"] as AnyObject)
        self.content = createString(value: withJason["content"] as AnyObject)
        self.date = createString(value: withJason["date"] as AnyObject)
    }
}
    

