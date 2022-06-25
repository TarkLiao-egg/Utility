import Foundation
import UIKit

class DataDB: SQLModel {
    var id: Int = -1
    var title: String
    var image: Data
    
    init(title: String, image: UIImage) {
        self.title = title
        self.image = image.pngData() ?? image.jpegData(compressionQuality: 0.5) ?? Data()
    }
    
    required init() {
        self.title = ""
        self.image = Data()
    }
    
    override func primaryKey() -> String {
        return "id"
    }
    
    override func ignoredKeys() -> [String] {
        return []
    }
}
