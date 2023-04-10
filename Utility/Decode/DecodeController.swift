import UIKit
// https://zhgchg.li/posts/1aa2f8445642/
class DecodeController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let jsonString = """
        {
          "count": 3,
          "offset": 0,
          "limit": 10,
          "results": [
            {
              "id": 123456,
              "comment": "是告五人，不是五告人!",
              "target_object": {
                "type": "song",
                "id": 99,
                "name": "披星戴月的想你",
                "create_date": "2020-06-13T15:21:42+0800"
              },
              "commenter": {
                "type": "user",
                "id": 1,
                "name": "zhgchgli",
                "email": "zhgchgli@gmail.com",
                "birthday": "1994/07/18"
              }
            },
            {
              "error": "not found"
            },
            {
              "error": "not found"
            },
            {
              "id": 2,
              "comment": "哈哈，我也是!",
              "target_object": {
                "type": "user",
                "id": 1,
                "name": "zhgchgli",
                "email": "zhgchgli@gmail.com",
                "birthday": "1994/07/18"
              },
              "commenter": {
                "type": "user",
                "id": 1,
                "name": "路人甲",
                "email": "man@gmail.com",
                "birthday": "2000/01/12"
              }
            }
          ]
        }
        """
        
        let jsonDecoder = JSONDecoder()
        let iso8601DateFormatter = ISO8601DateFormatter()
        let dateFormatter = DateFormatter()

        jsonDecoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            //ISO8601:
            if let date = iso8601DateFormatter.date(from: dateString) {
                return date
            }
            
            //YYYY-MM-DD:
            dateFormatter.dateFormat = "yyyy/MM/dd"
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        })

        do {
            let pageEntity = try jsonDecoder.decode(PageEntity<CommentEntity>.self, from: jsonString.data(using: .utf8)!)
            let comments = pageEntity.results.compactMap { CommentModel($0) }
            comments.forEach { (comment) in
                print(comment.displayMessage)
            }
        } catch {
            print(error)
        }

        
        var jsonData = """
        {
            "id":1
        }
        """.data(using: .utf8)!
        var result = try! JSONDecoder().decode(Song.self, from: jsonData)
        print(result)

        jsonData = """
        {
            "id":1,
            "file":null
        }
        """.data(using: .utf8)!
        result = try! JSONDecoder().decode(Song.self, from: jsonData)
        print(result)

        jsonData = """
        {
            "id":1,
            "file":\"https://test.com/m.mp3\"
        }
        """.data(using: .utf8)!
        result = try! JSONDecoder().decode(Song.self, from: jsonData)
        print(result)

    }
}

//
// Entity:
struct SongEntity: Decodable {
    enum CodingKeys: String, CodingKey {
        case type
        case id
        case name
        case createDate = "create_date"
    }
    var type: String
    var id: Int
    var name: String
    var createDate: Date
}

struct UserEntity: Decodable {
    var type: String
    var id: Int
    var name: String
    var email: String
    var birthday: Date
}

struct CommentEntity: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case commenter
        case targetObject = "target_object"
    }
    enum PredictKey: String, CodingKey {
        case type
    }
    enum ObjectType: String, Decodable {
        case song
        case user
    }
    
    enum TargetObjectEnum: Decodable {
        case song(SongEntity)
        case user(UserEntity)
        
        enum PredictKey: String, CodingKey {
            case type
        }
        
        enum TargetObjectType: String, Decodable {
            case song
            case user
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: PredictKey.self)
            let targetObjectType = try container.decode(TargetObjectType.self, forKey: .type)
            
            let singleValueContainer = try decoder.singleValueContainer()
            
            switch targetObjectType {
            case .song:
                let song = try singleValueContainer.decode(SongEntity.self)
                self = .song(song)
            case .user:
                let user = try singleValueContainer.decode(UserEntity.self)
                self = .user(user)
            }
        }
    }
    var id: Int
    var comment: String
    var commenter: UserEntity
    var targetObject: Decodable
    var targetObjectEnum: TargetObjectEnum
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.comment = try container.decode(String.self, forKey: .comment)
        self.commenter = try container.decode(UserEntity.self, forKey: .commenter)
        self.targetObjectEnum = try container.decode(TargetObjectEnum.self, forKey: .targetObject)
        //targetObject cloud be UserEntity or SongEntity
        let targetObjectNestedContainer = try container.nestedContainer(keyedBy: PredictKey.self, forKey: .targetObject)
        let type = try targetObjectNestedContainer.decode(ObjectType.self, forKey: .type)
        switch type {
        case .song:
            self.targetObject = try container.decode(SongEntity.self, forKey: .targetObject)
        case .user:
            self.targetObject = try container.decode(UserEntity.self, forKey: .targetObject)
        }
    }
}

struct EmptyEntity: Decodable { }

struct PageEntity<E: Decodable>: Decodable {
    enum CodingKeys: String, CodingKey {
        case count
        case offset
        case limit
        case results
    }
    var count: Int
    var offset: Int
    var limit: Int
    var results: [E]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decode(Int.self, forKey: .count)
        self.offset = try container.decode(Int.self, forKey: .offset)
        self.limit = try container.decode(Int.self, forKey: .limit)
        
        var nestedUnkeyedContainer = try container.nestedUnkeyedContainer(forKey: .results)
        
        self.results = []
        while !nestedUnkeyedContainer.isAtEnd {
            if let entity = try? nestedUnkeyedContainer.decode(E.self) {
                self.results.append(entity)
            } else {
                let _ = try nestedUnkeyedContainer.decode(EmptyEntity.self)
            }
        }
    }
}

// Model:
class UserModel: NSObject {
    var type: String
    var id: Int
    var name: String
    var email: String
    var birthday: Date
    init(_ entity: UserEntity) {
        self.type = entity.type
        self.id = entity.id
        self.name = entity.name
        self.email = entity.email
        self.birthday = entity.birthday
    }
}

class SongModel: NSObject {
    var type: String
    var id: Int
    var name: String
    var createDate: Date
    init(_ entity: SongEntity) {
        self.type = entity.type
        self.id = entity.id
        self.name = entity.name
        self.createDate = entity.createDate
    }
}

class CommentModel: NSObject {
    var id: Int
    var comment: String
    var commenter: UserModel
    var targetObject: NSObject?
    
    var displayMessage: String //simulation business logic
    
    init(_ entity: CommentEntity) {
        self.id = entity.id
        self.comment = entity.comment
        self.commenter = UserModel(entity.commenter)
        if let userEntity = entity.targetObject as? UserEntity {
            self.targetObject = UserModel(userEntity)
        } else if let songEntity = entity.targetObject as? SongEntity {
            self.targetObject = SongModel(songEntity)
        }
        self.displayMessage = "\(entity.commenter.name):\(entity.comment)"
    }
}


class Customer : Codable {
    enum CustomerType: String, CaseIterable, Codable {
        ///VIP客戶
        case VIP = "1"
        ///普通客戶
        case Others = "2"
        
        init(from decoder: Decoder) throws {
            self = try CustomerType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .Others
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        }
    }

    /// 客戶類型
    var CustomerType : CustomerType?
    /// 銀行餘額
    var Balance : String?
    
    enum CodingKeys: CodingKey {
        case CustomerType
        case Balance
    }
    
    required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Customer.CodingKeys> = try decoder.container(keyedBy: Customer.CodingKeys.self)
        
        self.CustomerType = try container.decodeIfPresent(Customer.CustomerType.self, forKey: Customer.CodingKeys.CustomerType)
        self.Balance = try container.decodeIfPresent(String.self, forKey: Customer.CodingKeys.Balance)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<Customer.CodingKeys> = encoder.container(keyedBy: Customer.CodingKeys.self)
        
        try container.encodeIfPresent(self.CustomerType, forKey: Customer.CodingKeys.CustomerType)
        try container.encodeIfPresent(self.Balance, forKey: Customer.CodingKeys.Balance)
    }
}

struct Song: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case file
    }
    enum OptionalValue<T: Decodable>: Decodable {
        case null
        case value(T)
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let value = try? container.decode(T.self) {
                self = .value(value)
            } else {
                self = .null
            }
        }
    }
    var id: Int
    var file: OptionalValue<String>?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        
        if container.contains(.file) {
            self.file = try container.decode(OptionalValue<String>.self, forKey: .file)
        } else {
            self.file = nil
        }
    }
}
