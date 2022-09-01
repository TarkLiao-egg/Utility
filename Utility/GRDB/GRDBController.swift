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
                print(datum.id)
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
                print(datum.id)
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
                print(datum.id)
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
            data.timestamp += 2
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
            array.append(Player(date: Date(), times: 1, exStr: "123"))
            array.append(Player(date: Date(), times: 2, exStr: "1234"))
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
    var imageData: Data?
    
    static func < (lhs: Player, rhs: Player) -> Bool {
        return lhs.timestamp > rhs.timestamp
    }
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case timestamp = "timestamp"
        case times = "times"
        case exerciseTimeStr = "exerciseTimeStr"
        case imageData = "imageData"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timestamp = try container.decode(Int.self, forKey: .timestamp)
        self.times = try container.decode(Int.self, forKey: .times)
        self.exerciseTimeStr = try container.decode(String.self, forKey: .exerciseTimeStr)
        self.imageData = try container.decode(Data.self, forKey: .imageData)
        super.init()
        self.id = try? container.decode(Int.self, forKey: .id)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(times, forKey: .times)
        try container.encode(exerciseTimeStr, forKey: .exerciseTimeStr)
        try container.encode(imageData, forKey: .imageData)
    }
    
    init(date: Date, times: Int, exStr: String, image: UIImage? = nil) {
        self.timestamp = date.getTimeStamp()
        self.times = times
        self.exerciseTimeStr = exStr
        super.init()
        if let image = image {
            saveImage(image)
        }
    }
    
    required override init() {
        self.timestamp = Date().getTimeStamp()
        self.times = 0
        self.exerciseTimeStr = ""
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
}
