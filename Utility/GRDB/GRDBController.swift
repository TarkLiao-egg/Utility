//
//  GRDBController.swift
//  Utility
//
//  Created by 廖力頡 on 2022/8/14.
//
import GRDB
import UIKit

class GRDBController: UIViewController {
    lazy var dbQueue: DatabaseQueue = {
        return DBManager.dbQueue
    }()
    var datas = [Player]()
    override func viewDidLoad() {
        super.viewDidLoad()
        readData { data in
            self.datas = data
            print(data.count)
            for datum in data {
                print(datum.name)
            }
        }
        writeData { isComp in
            print(isComp)
        }
        print("padding1")
        readData { data in
            self.datas = data
            print(data.count)
            for datum in data {
                print(datum.name)
            }
            
            
            print("padding3")
            
            
        }
        updateData(datas) { isComp in
            print(isComp)
        }
        print("padding2")
        readData { data in
            self.datas = data
            print(data.count)
            for datum in data {
                print(datum.name)
            }
        }
        
        deleteData(datas)
    }
    
    func deleteData(_ datas: [Player]) {
        do {
            try dbQueue.write({ db in
                for item in datas {
                    try item.delete(db)
                }
            })
        } catch {
            print("error error")
        }
    }
    
    func updateData(_ datas: [Player], completion: (Bool) -> Void) {
        for data in datas {
            data.name += "2"
        }
        do {
            try dbQueue.write({ db in
                for item in datas {
                    try item.update(db)
                }
                completion(true)
            })
        } catch {
            print("error update")
        }
    }
    
    func writeData(completion: (Bool) -> Void) {
        do {
            var array = [Player]()
            array.append(Player(val: 2, name: "tark"))
            array.append(Player(val: 3, name: "Gloria"))
            try dbQueue.write({ db in
                for item in array {
                    try item.insert(db)
                }
                completion(true)
            })
                
            
        } catch {
            print("error")
        }
    }
    
    
    
    func readData(completion: (([Player]) throws -> Void)) {
        do {
            try dbQueue.read { db in
                let players = try Player.fetchAll(db)
                try completion(players)
            }
        } catch {
            print("error")
        }
    }

}


class Player: DBInit, FetchableRecord, PersistableRecord, Codable, Comparable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
    
    var timestamp: Int
    var times: Int
    var exerciseTimeStr: String
    static func < (lhs: Player, rhs: Player) -> Bool {
        return lhs.timestamp > rhs.timestamp
    }
    
    init(date: Date, times: Int, exStr: String) {
        self.timestamp = date.getInt()
        self.times = times
        self.exerciseTimeStr = exStr
        super.init()
    }
    
    required override init() {
        self.timestamp = Date().getInt()
        self.times = 0
        self.exerciseTimeStr = ""
    }
}
