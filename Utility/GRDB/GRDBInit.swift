import Combine
import Foundation
import GRDB

class DBSource: NSObject {
    static let dbName = "DB.db"
    static let shared = DBSource()
    private static var dbPath: String = {
        let filePath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!.appending("/\(DBSource.dbName)")
        print(filePath)
        return filePath
    }()
    
    private static var configuration: Configuration = {
        var configuration = Configuration()
        configuration.busyMode = Database.BusyMode.timeout(5.0)
        return configuration
    }()
    
    static let dbQueue: DatabaseQueue = {
        let db = try! DatabaseQueue(path: DBSource.dbPath, configuration: DBSource.configuration)
        db.releaseMemory()
        return db
    }()
}

protocol EnumProtocol {
    func getEnums() -> [String]
}

class GRDBInit: NSObject, DBProtocol, Comparable, EnumProtocol {
    private static let dbQueue: DatabaseQueue = DBSource.dbQueue
    static let shared = GRDBInit()
    private static var verified = [String:Bool]()
    var id: Int? = nil
    static var ignorePrefix: String = "i_"
    
    func getEnums() -> [String] {
        return ["id"]
    }
    required override init() {
        super.init()
        let tableName = "\(type(of: self).classForCoder())"
        let verified = Self.verified[tableName]
        guard verified == nil || !verified! else { return }
        Self.verified[tableName] = true

        let tmp = Self.init()
        try? Self.dbQueue.inDatabase { (db) -> Void in
            try db.create(table: tableName, temporary: false, ifNotExists: true, body: { (t) in
                if try db.tableExists(tableName) {
                    return
                }
                for keyValue in tmp.getKeyValues() {
                    let key = keyValue.key
                    let value = keyValue.value
                    if key == "id" {
                        if value is String {
                            t.column(key, .text).primaryKey(autoincrement: true).notNull()
                        } else {
                            t.column(key, .integer).primaryKey(autoincrement: true).notNull()
                        }
                    } else if value is Int? {
                        t.column(key, .integer)
                    } else if value is Int {
                        t.column(key, .integer).notNull()
                    } else {
                        if value is Bool? {
                            t.column(key, Database.ColumnType.boolean)
                        } else if value is Bool {
                            t.column(key, Database.ColumnType.boolean).notNull()
                        } else if value is Float? || value is Double? {
                            t.column(key, Database.ColumnType.double)
                        } else if value is Float || value is Double {
                            t.column(key, Database.ColumnType.double).notNull()
                        } else if value is Date? {
                            t.column(key, Database.ColumnType.datetime)
                        } else if value is Date {
                            t.column(key, Database.ColumnType.datetime).notNull()
                        } else if value is Data? {
                            t.column(key, Database.ColumnType.blob)
                        } else if value is Data {
                            t.column(key, Database.ColumnType.blob).notNull()
                        } else if value is String? {
                            t.column(key, Database.ColumnType.text)
                        } else if value is String {
                            t.column(key, Database.ColumnType.text).notNull()
                        }
                    }
                }
            })
        }
    }
    
    static func < (lhs: GRDBInit, rhs: GRDBInit) -> Bool {
        return lhs.id! < rhs.id!
    }
    
    static func == (lhs: GRDBInit, rhs: GRDBInit) -> Bool {
        return lhs.id == rhs.id
    }
    
    func getKeyValues() -> [String:Any] {
        var nameMap = [String: String]()
        var res = [String:Any]()
        let obj = Mirror(reflecting:self)
        
        nameMap["id"] = "id"
        for (i,enumValue) in obj.children.enumerated() {
            nameMap[enumValue.label!] = getEnums()[i + 1]
        }
        getKeys(obj: obj, results: &res)
        getValues(obj: obj.superclassMirror, results: &res)
        var newRes = [String:Any]()
        for r in res {
            newRes[nameMap[r.key]!] = r.value
        }
        return newRes
        
    }
    
    func getKeys(obj: Mirror, results: inout [String: Any]) {
        for (_, attr) in obj.children.enumerated() {
            if let name = attr.label {
                let range = NSRange(location: 0, length: name.utf16.count)
                let regex = try! NSRegularExpression(pattern: "\(Self.ignorePrefix)[0-9a-zA-Z_]*")
                if regex.firstMatch(in: name, options: [], range: range) == nil {
                    results[name] = unwrap(attr.value)
                }
            }
        }
    }
    
    func getValues(obj: Mirror?, results: inout [String:Any]) {
        guard let obj = obj else { return }
        getKeys(obj: obj, results: &results)
        getValues(obj: obj.superclassMirror, results: &results)
    }
    
    
    func unwrap(_ any:Any) -> Any {
        let mi = Mirror(reflecting: any)
        if mi.displayStyle != .optional {
            return any
        }
         
        if mi.children.count == 0 { return any }
        let (_, some) = mi.children.first!
        return some
    }
}

protocol DBProtocol {}

extension DBProtocol {
    static var dbQueue: DatabaseQueue {
        return DBSource.dbQueue
    }
}

@available(iOS 13.0.0, *)
extension DBProtocol where Self: FetchableRecord, Self: PersistableRecord, Self: GRDBInit {
    static func get() async -> [Self] {
        let _ = Self.init()
        do {
            return try await dbQueue.read { db in
                return try Self.fetchAll(db, sql: "SELECT * FROM \(Self.self)")
            }
        } catch {
            print(error)
            return []
        }
    }
    
    func store() async -> Self? {
        do {
            return try await DBSource.dbQueue.write({ db -> Self? in
                if let id = self.id {
                    try self.update(db)
                    return try Self.fetchOne(db, sql: "SELECT * FROM \(Self.self) where id = \(id)") ?? nil
                } else {
                    try self.insert(db)
                    return try Self.fetchOne(db, sql: "SELECT * FROM \(Self.self) ORDER BY id DESC LIMIT 1")
                }
            })
        } catch {
            print(error)
            return nil
        }
    }
    
    func delete(_ items: [Self]) async -> [Self] {
        do {
            return try await Self.dbQueue.write({ db -> [Self] in
                for item in items {
                    try item.delete(db)
                }
                return try Self.fetchAll(db)
            })
        } catch {
            print(error)
            return []
        }
    }
}

extension DBProtocol where Self: FetchableRecord, Self: PersistableRecord, Self: GRDBInit {
    static func getSync(completion: ([Self]) -> Void) {
        let _ = Self.init()
        do {
            completion(try dbQueue.read { db in
                return try Self.fetchAll(db, sql: "SELECT * FROM \(Self.self)")
            })
        } catch {
            print(error)
            completion([])
        }
    }
    
    static func storeSync(_ items: [Self]) {
        try? DBSource.dbQueue.write({ db in
            for item in items {
                if let _ = item.id {
                    try item.update(db)
                } else {
                    try item.insert(db)
                }
            }
        })
    }
    
    static func createSync(_ items: [Self]) {
        try? dbQueue.write({ db in
            for item in items {
                try item.insert(db)
            }
        })
    }
    
    static func updateSync(_ items: [Self]) {
        try? dbQueue.write({ db in
            for item in items {
                try item.update(db)
            }
        })
    }
    
    func deleteSync(_ items: [Self]) {
        try? Self.dbQueue.write({ db in
            for item in items {
                try item.delete(db)
            }
        })
    }
}

@available(iOS 13.0.0, *)
extension Array where Element: PersistableRecord, Element: FetchableRecord, Element: GRDBInit {
    static var dbQueue: DatabaseQueue {
        return DBSource.dbQueue
    }
    
    func store() async -> [Element] {
        do {
            return try await Self.dbQueue.write({ db -> [Element] in
                for item in self {
                    if let _ = item.id {
                        try item.update(db)
                    } else {
                        try item.insert(db)
                    }
                }
                return try Element.fetchAll(db)
            })
        } catch {
            print(error)
            return []
        }
    }
    
    func delete() async -> [Element] {
        do {
            return try await Self.dbQueue.write({ db -> [Element] in
                for item in self {
                    try item.delete(db)
                }
                return try Element.fetchAll(db)
            })
        } catch {
            print(error)
            return []
        }
    }
}


extension Array where Element: PersistableRecord, Element: GRDBInit {
    static var dbQueue: DatabaseQueue {
        return DBSource.dbQueue
    }
    
    func storeSync() {
        try? Self.dbQueue.write({ db in
            for item in self {
                if let _ = item.id {
                    try item.update(db)
                } else {
                    try item.insert(db)
                }
            }
        })
    }
    
    func deleteSync() {
        try? Self.dbQueue.write({ db in
            for item in self {
                try item.delete(db)
            }
        })
    }
}
