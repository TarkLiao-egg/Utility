import Foundation

class TransactionDB: SQLModel {
    var id: Int = -1
    var time: Int
    var title: String
    var descriptionStr: String
    
    init(time:Int, title: String, description: String) {
        self.time = time
        self.title = title
        self.descriptionStr = description
    }
    
    required init() {
        self.time = -1
        self.title = ""
        self.descriptionStr = ""
    }
    
    override func primaryKey() -> String {
        return "id"
    }
    
    override func ignoredKeys() -> [String] {
        return []
    }
}
