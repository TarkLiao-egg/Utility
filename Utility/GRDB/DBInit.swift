
import Foundation
import GRDB

class DBManager: NSObject {
    static let dbName = "DB.db"
    static let shared = DBManager()
    private static var dbPath: String = {
        let filePath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!.appending("/\(DBManager.dbName)")
        print(filePath)
        return filePath
    }()
    
    private static var configuration: Configuration = {
        var configuration = Configuration()
        configuration.busyMode = Database.BusyMode.timeout(5.0)
        //configuration.busyMode = Database.BusyMode.immediateError
        return configuration
    }()
    
    static let dbQueue: DatabaseQueue = {
        let db = try! DatabaseQueue(path: DBManager.dbPath, configuration: DBManager.configuration)
        db.releaseMemory()
        return db
    }()
    static func createTable() {
        Player().createTable()
    }
    
    func read<T: FetchableRecord>(_ type: T.Type, completion: (([T]) -> Void))  {
        var array: [T]?
        try? DBManager.dbQueue.read { db in
            array = try T.fetchAll(db, sql: "SELECT * FROM \(T.self)")
        }
        if let array = array {
            completion(array)
        }
    }
    
    func store<T: PersistableRecord>(_ type: T.Type, _ items: [T]) where T: DBInit {
        try? DBManager.dbQueue.write({ db in
            for item in items {
                if let _ = item.id {
                    try item.update(db)
                } else {
                    try item.insert(db)
                }
            }
        })
    }

    func create<T: PersistableRecord>(_ type: T.Type, _ items: [T]) {
        try? DBManager.dbQueue.write({ db in
            for item in items {
                try item.insert(db)
            }
        })
    }

    func update<T: PersistableRecord>(_ type: T.Type, _ items: [T]) {
        try? DBManager.dbQueue.write({ db in
            for item in items {
                try item.update(db)
            }
        })
    }

    func delete<T: PersistableRecord>(_ type: T.Type, _ items: [T]) {
        try? DBManager.dbQueue.write({ db in
            for item in items {
                try item.delete(db)
            }
        })
    }
    
}

class DBInit: DBProtocol {
    var id: Int? = nil
    static var ignorePrefix: String = "i_"
    private static let dbQueue: DatabaseQueue = DBManager.dbQueue
    
    func createTable() -> Void {
        var tableName = String(describing: self)
        let range = NSRange(location: 0, length: tableName.utf16.count)
        let regex = try! NSRegularExpression(pattern: "([0-9a-zA-Z_]*.)$")
        if let match = regex.firstMatch(in: tableName, options: [], range: range) {
            tableName = String(tableName[Range(match.range, in: tableName)!])
        }
        
        try? Self.dbQueue.inDatabase { (db) -> Void in
            try db.create(table: tableName, temporary: false, ifNotExists: true, body: { (t) in
                if try db.tableExists(tableName) {
                    return
                }
                for keyValue in getKeyValues() {
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
    func getKeyValues() -> [String:Any] {
        var res = [String:Any]()
        let obj = Mirror(reflecting:self)
        getKeys(obj: obj, results: &res)
        getValues(obj: obj.superclassMirror, results: &res)
        return res
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
        return DBManager.dbQueue
    }
}


extension DBProtocol where Self: FetchableRecord {
    
    static func get(completion: (([Self]) -> Void)) {
        var datas = [Self]()
        
        try? dbQueue.read { db in
            datas = try Self.fetchAll(db, sql: "SELECT * FROM \(Self.self)")
            completion(datas)
        }
    }
}

extension DBProtocol where Self: PersistableRecord {
    static func create(_ items: [Self]) {
        try? dbQueue.write({ db in
            for item in items {
                try item.insert(db)
            }
        })
    }
    
    static func update(_ items: [Self]) {
        try? dbQueue.write({ db in
            for item in items {
                try item.update(db)
            }
        })
    }
    
    func delete(_ items: [Self]) {
        try? Self.dbQueue.write({ db in
            for item in items {
                try item.delete(db)
            }
        })
    }
}

extension Array where Element: PersistableRecord {
    static var dbQueue: DatabaseQueue {
        return DBManager.dbQueue
    }
    func create() {
        try? Self.dbQueue.write({ db in
            for item in self {
                try item.insert(db)
            }
        })
    }
    func update() {
        try? Self.dbQueue.write({ db in
            for item in self {
                try item.update(db)
            }
        })
    }
    func delete() {
        try? Self.dbQueue.write({ db in
            for item in self {
                try item.delete(db)
            }
        })
    }
}
