import Foundation
import GRDB
class NoteModel: FetchableRecord, PersistableRecord, MutablePersistableRecord, Codable, Comparable {
    var id: Int?
    @objc var noteAt: Date?
    @objc var content: String?
    @objc var plantID: Int
    
    static func == (lhs: NoteModel, rhs: NoteModel) -> Bool {
        return lhs.id == rhs.id
    }
    static func < (lhs: NoteModel, rhs: NoteModel) -> Bool {
        return lhs.id! > rhs.id!
    }
    
    static func store(_ items: [NoteModel]) -> [Int] {
        var ids = [Int]()
        try? DBManager.dbQueue.write({ db in
            for item in items {
                try item.save(db)
                if let id = item.id {
                    ids.append(id)
                } else {
                    ids.append(Int(db.lastInsertedRowID))
                }
            }
        })
        return ids
    }
    
    init() {
        self.plantID = -1
    }
    
    static func create() {
        var migrator = DatabaseMigrator()
        do {
            
            let modelName = String(describing: self)
            migrator.registerMigration(modelName) { db in
                try db.create(table: modelName) { t in
                    t.column("id", .integer).primaryKey()
                    t.column(#keyPath(noteAt), .datetime)
                    t.column(#keyPath(content), .text)
                    t.column(#keyPath(plantID), .integer).notNull()
                                .indexed()
                                .references(String(describing: PlantModel.self), onDelete: .cascade)
                }
            }
            try migrator.migrate(DBManager.dbQueue)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    enum CodingKeys: CodingKey {
        case id
        case noteAt
        case content
        case plantID
    }
    
    required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<NoteModel.CodingKeys> = try decoder.container(keyedBy: NoteModel.CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: NoteModel.CodingKeys.id)
        self.noteAt = try container.decode(Date.self, forKey: NoteModel.CodingKeys.noteAt)
        self.content = try container.decode(String.self, forKey: NoteModel.CodingKeys.content)
        self.plantID = try container.decode(Int.self, forKey: NoteModel.CodingKeys.plantID)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<NoteModel.CodingKeys> = encoder.container(keyedBy: NoteModel.CodingKeys.self)
        
        try container.encode(self.id, forKey: NoteModel.CodingKeys.id)
        try container.encode(self.noteAt, forKey: NoteModel.CodingKeys.noteAt)
        try container.encode(self.content, forKey: NoteModel.CodingKeys.content)
        try container.encode(self.plantID, forKey: NoteModel.CodingKeys.plantID)
    }
    
}
