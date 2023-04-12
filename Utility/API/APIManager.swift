import Foundation
import Alamofire

class APIManager: CRUD {

    private static let host:String = "https://e-app-testing-z.herokuapp.com"
    private static let transaction:String = "/transaction"

    static let sharedInstance:APIManager = .init()

    public enum DecodeError: Error, LocalizedError {
        case dataNull
        public var errorDescription: String? {
            switch self {
            case .dataNull:
                return "Data Null"
            }
        }
    }
}
