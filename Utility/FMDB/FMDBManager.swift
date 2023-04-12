import Foundation
import FMDB
protocol CRUD {
}

class FMDBManager: CRUD {
    static let sharedInstance:FMDBManager = .init()
    static let dbName = "transaction.db"
    lazy var dbURL: URL = {
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask,
                 appropriateFor: nil, create: true)
            .appendingPathComponent(FMDBManager.dbName)
        print(fileURL)
        return fileURL
    }()
    
    lazy var db: FMDatabase = {
        let database = FMDatabase(url: dbURL)
        return database
    }()
    
}
