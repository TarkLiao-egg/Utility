import Foundation
import GRDB
class PlantModel: FetchableRecord, PersistableRecord, Codable, Comparable {
    private var _id: Int? = nil
    @objc var id: Int
    @objc var name: String
    @objc var imageData: Data?
    @objc var createAt: Date
    
    var notes: [NoteModel] {
        try! DBManager.dbQueue.read { db in
            return try self.request(for: PlantModel.hasMany(NoteModel.self)).fetchAll(db)
        }
    }
    
    static func == (lhs: PlantModel, rhs: PlantModel) -> Bool {
        return lhs.id == rhs.id
    }
    static func < (lhs: PlantModel, rhs: PlantModel) -> Bool {
        return lhs.id > rhs.id
    }
    
    static func store(_ items: [PlantModel]) {
        try? DBManager.dbQueue.write({ db in
            for item in items {
                if item.id == -1 {
                    try item.insert(db)
                } else {
                    try item.update(db)
                }
            }
        })
    }
    
    static func create() {
        var migrator = DatabaseMigrator()
        do {
            
            let modelName = String(describing: self)
            migrator.registerMigration(modelName) { db in
                try db.create(table: modelName) { t in
                    t.column(#keyPath(id), .integer).primaryKey()
                    t.column(#keyPath(name), .text).notNull()
                    t.column(#keyPath(imageData), .blob)
                    t.column(#keyPath(createAt), .datetime).notNull()
                }
            }
            try migrator.migrate(DBManager.dbQueue)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case imageData
        case createAt
    }
    
    required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<PlantModel.CodingKeys> = try decoder.container(keyedBy: PlantModel.CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: PlantModel.CodingKeys.id)
        self.name = try container.decode(String.self, forKey: PlantModel.CodingKeys.name)
        self.imageData = try container.decodeIfPresent(Data.self, forKey: PlantModel.CodingKeys.imageData)
        self.createAt = try container.decode(Date.self, forKey: PlantModel.CodingKeys.createAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<PlantModel.CodingKeys> = encoder.container(keyedBy: PlantModel.CodingKeys.self)
        if id == -1 {
            try container.encode(self._id, forKey: PlantModel.CodingKeys.id)
        } else {
            try container.encode(self.id, forKey: PlantModel.CodingKeys.id)
        }
        try container.encode(self.name, forKey: PlantModel.CodingKeys.name)
        try container.encode(self.imageData, forKey: PlantModel.CodingKeys.imageData)
        try container.encode(self.createAt, forKey: PlantModel.CodingKeys.createAt)
    }
    
    init(name: String, imageData: Data? = nil, createAt: Date) {
        self.id = -1
        self.name = name
        self.imageData = imageData
        self.createAt = createAt
    }
    
    init() {
        self.id = -1
        self.name = ""
        self.createAt = Date()
    }
    
    func saveImage(_ image: UIImage?) {
        if let nsdata = image?.pngData() {
            self.imageData = nsdata
        } else if let nsdata = image?.jpegData(compressionQuality: 0.5) {
            self.imageData = nsdata
        } else {
            self.imageData = nil
        }
    }
    
    func loadImage() -> UIImage? {
        if let data = imageData {
            return UIImage(data: data)
        }
        return nil
    }
    
    func getDays(_ date: Date? = nil) -> String {
        let day: Int
        if let date = date {
            day = Int((date.timeIntervalSince1970 - createAt.timeIntervalSince1970) / 24 / 60 / 60)
        } else {
            day = Int((Date().timeIntervalSince1970 - createAt.timeIntervalSince1970) / 24 / 60 / 60)
        }
        return String(day) + " Days"
    }
}
