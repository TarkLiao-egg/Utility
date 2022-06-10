//#if canImport(Combine)
//import Moya
//import CryptoSwift
//import Combine
//import Foundation
//struct WLProvider {
//    
//    enum providerType: String {
//        case regular
//        case verbose
//        case sample
//    }
//
//    private static var provider: MoyaProvider<WLService> = {
//        // Create provider with the token.
//        let authPlugin = AccessTokenPlugin(tokenClosure: { (TargetType) -> String in
//            return ""//CoreModels.shared.user.value?.token ?? ""
//        })
//        let provider = MoyaProvider<WLService>(plugins: [authPlugin])
//        return provider
//    }()
//    
//    private static var verboseProvider: MoyaProvider<WLService> = {
//        // Create provider with the token.
//        let authPlugin = AccessTokenPlugin(tokenClosure: { (TargetType) -> String in
//            return ""//CoreModels.shared.user.value?.token ?? ""
//        })
//        let provider = MoyaProvider<WLService>(plugins: [authPlugin, NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))])
//        
//        return provider
//    }()
//    
//    private static var sampleProvider: MoyaProvider<WLService> = {
//        // Create provider with the token.
//        let authPlugin = AccessTokenPlugin(tokenClosure: { (TargetType) -> String in
//            return ""//CoreModels.shared.user.value?.token ?? ""
//        })
//        let provider = MoyaProvider<WLService>(stubClosure: MoyaProvider<WLService>.immediatelyStub, plugins: [authPlugin])
//        return provider
//    }()
//    
//    public static func request(target: WLService, type: WLProvider.providerType = .regular, callbackQueue: DispatchQueue? = DispatchQueue.main, isEncrypt: Bool = true) -> AnyPublisher<Response, MoyaError> {
//        
//        // Construct provider
//        let provider: MoyaProvider<WLService>
//        switch type {
//        case .regular:
//            provider = WLProvider.provider
//        case .sample:
//            provider = WLProvider.sampleProvider
//        case .verbose:
//            provider = WLProvider.verboseProvider
//        }
//        
//        // Clear all cookies.
//        let cstorage = HTTPCookieStorage.shared
//        if let cookies = cstorage.cookies(for: target.baseURL) {
//            for cookie in cookies {
//                cstorage.deleteCookie(cookie)
//            }
//        }
//        
//        return provider.requestPublisher(target)
//            .flatMap({ (response) -> AnyPublisher<Response, MoyaError> in
//                print("flatmap")
//                if response.statusCode == 401 {
//                    print("WLProvider: Error 401 Invalid access token.")
//                    return Deferred {
//                        Future { promise in
//                          promise(.failure(MoyaError.statusCode(response)))
//                        }
//                      }.eraseToAnyPublisher()
//                } else {
//                    if target.path == "/system_variables/appversion" {
//                        return Deferred {
//                            Future { promise in
//                              promise(.success(response))
//                            }
//                          }.eraseToAnyPublisher()
//                    }
//                    if let obj = try? JSONDecoder().decode(ResponseAES.self, from: response.data) {
//                        if let descryptData = obj.response.decryptStringToData {
//                            printDataWhenStatusCodeNotSuccess(statusCode: response.statusCode, data: descryptData)
//                            return Deferred {
//                                Future { promise in
//                                  promise(.success(Response(statusCode: response.statusCode, data: descryptData, request: response.request, response: response.response)))
//                                }
//                              }.eraseToAnyPublisher()
//                        }
//                    }
//                    printDataWhenStatusCodeNotSuccess(statusCode: response.statusCode, data: response.data)
//                    return Deferred {
//                        Future { promise in
//                          promise(.success(response))
//                        }
//                      }.eraseToAnyPublisher()
//                }
//            })
//            .eraseToAnyPublisher()
//    }
//    
//    static func printDataWhenStatusCodeNotSuccess(statusCode: Int, data: Data) {
//        if statusCode != 200 && statusCode != 201 {
//            print("statusCode:\(statusCode), dataString:\n\(String(decoding: data, as: UTF8.self))")
//        }
//    }
//}
//
//
//enum WLService {
//    case getLandlord(mobile: String)
//    case signup(firstName: String, lastName: String, phoneNumber: String, password: String, invitor: Int?, identity: String, gender: Int)
//    case login(phoneNumber: String, password: String)
//    case deleteLandlord(landlordID: Int, password: String?)
//    case forgotPassword(phoneNumber: String)
//    case postFCMToken(landlordID: Int, token: String)
//    case changePassword(landlordID: Int, oldPassword: String, newPassword: String)
//    case getTenants(landlordID: Int)
//    case getNotifications(landlordID: Int)
//    case getInfo(landlordID: Int)
//    case getAppVersion(dev: String)
//    case getLatestDiscount
//    case uploadImage(image: UIImage)
//}
//
//struct WLURL {
//    static var apiURL: URL?
//    static var baseURL: URL {
//        if let apiURL = apiURL {
//            return URL(string: "\(apiURL.absoluteString)/api")!
//        } else {
//            return URL(string: "https://wholive.com.tw/api")!
//        }
//    }
//    
//    static var webBaseURL: URL {
//        return URL(string: "https://stg.pay.wholive.com.tw")!
//    }
//}
//
//extension WLService: TargetType, AccessTokenAuthorizable {
//    
//    
//    var baseURL: URL {
//        return WLURL.baseURL
//    }
//    
//    var path: String {
//        switch self {
//        case .getLandlord(_):
//            return "/auths/landlord_name"
//        case .signup(_, _, _, _, _, _, _):
//            return "/auths/signup"
//        case .login(_, _):
//            return "/auths/login"
//        case .deleteLandlord(let landlordID, _):
//            return "/landlords/\(landlordID)"
//        case .forgotPassword(_):
//            return "/auths/send_forget_sms"
//        case .postFCMToken(let landlordID, _):
//            return "/landlords/\(landlordID)/fcm"
//        case .uploadImage(_):
//            return "/features/upload"
//        case .changePassword(let landlordID, _, _):
//            return "/landlords/\(landlordID)/update_password"
//        case .getTenants(let landlordID):
//            return "/landlords/\(landlordID)/tenants"
//        case .getNotifications(let landlordID):
//            return "/landlords/\(landlordID)/notifications"
//        case .getInfo(let landlordID):
//            return "/landlords/\(landlordID)/info"
//        case .getAppVersion:
//            return "/system_variables/appversion"
//        case .getLatestDiscount:
//            return "/billboards"
//        }
//    }
//    
//    var method: Moya.Method {
//        switch self {
//        case .getLandlord, .getTenants, .getNotifications, .getInfo, .getAppVersion, .getLatestDiscount:
//            return .get
//        case .signup, .login, .postFCMToken, .forgotPassword, .changePassword, .uploadImage:
//            return .post
////        case .updateProfile, .updateBill, .updateContract, .updateAdvisoryRecord, .updateBankInfos, .updateLock:
////            return .put
//        case .deleteLandlord:
//            return .delete
//        }
//    }
//    
//    var sampleData: Data {
//        switch self {
//        default:
//            return Data()
//        }
//    }
//    
//    var task: Task {
//        var parameters = [String: Any]()
//        switch self {
//        case .getLandlord(let mobile):
//            let parameters = ["mobile" : mobile]
//            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
//        case .signup(let firstName, let lastName, let phoneNumber, let password, let invitor, let identity, let gender):
//            var landlordData = [
//                "first_name" : firstName,
//                "last_name" : lastName,
//                "mobile" : phoneNumber,
//                "password" : password,
//                "device" : "ios",
//                "rental_identity": identity,
//                "gender": gender
//            ] as [String: Any]
//            if let invitor = invitor {
//                landlordData["invited_by"] = "\(invitor)"
//            }
//            parameters["landlord"] = landlordData
//            break
//        case .login(let phoneNumber, let password):
//            parameters["landlord"] = [
//                "mobile" : phoneNumber,
//                "password" : password
//            ]
//            break
//        case .deleteLandlord(_, let password):
//            if let pwd = password, pwd.count > 0 {
//                parameters["password"] = password
//            } else {
//                return .requestPlain
//            }
//        case .forgotPassword(let phoneNumber):
//            let parameters = ["mobile" : phoneNumber]
//            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
//        case .postFCMToken(_, let token):
//            parameters["token"] = token
//            parameters["dev"] = "ios"
//            break
//        case .changePassword(_, let oldPassword, let newPassword):
//            parameters["old_password"] = oldPassword
//            parameters["new_password"] = newPassword
//            break
//        case .getTenants(_):
//            return .requestPlain
//        case .getNotifications(_):
//            return .requestPlain
//        case .getInfo(_):
//            return .requestPlain
//        case .getAppVersion(let dev):
//            let parameters = ["dev" : dev, "app": "wholiveplus"]
//            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
//        case .getLatestDiscount:
//            return .requestPlain
//        case .uploadImage(let image):
//            var multipartData = [MultipartFormData]()
//            if let imageData = image.jpegData(compressionQuality: 1.0) {
//                multipartData.append(MultipartFormData(provider: .data(imageData), name: "image", fileName: "\(Date().timeIntervalSinceReferenceDate).jpg", mimeType: "image/jpeg"))
//            }
//            return .uploadMultipart(multipartData)
//        }
//        if let _ = VersionHandler.shared.selectKey, let _ = VersionHandler.shared.selectIV, let aesBase64String = parameters.encryptToAESBase64String {
//            let request = [
//                "request": aesBase64String
//            ]
//            return .requestParameters(parameters: request, encoding: JSONEncoding.default)
//        } else {
//            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
//        }
//    }
//    
//    var headers: [String : String]? {
//        switch self {
//        case .uploadImage:
//            return ["Content-type": "multipart/form-data"]
//        default:
//            return ["Content-type": "application/json"]
//        }
//    }
//    
//    var authorizationType: AuthorizationType? {
//        switch self {
//        case .getLandlord, .signup, .login, .forgotPassword, .getAppVersion, .getLatestDiscount:
//            return .basic
////            return .none
//        default:
//            return .bearer
//        }
//    }
//    
//}
//
//struct ResponseAES: Codable {
//    let response: String
//    enum CodingKeys: String, CodingKey {
//        case response = "response"
//    }
//}
//extension Dictionary where Key == String {
//    var encryptToAESBase64String: String? {
//        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: []), let key = VersionHandler.shared.selectKey, let iv = VersionHandler.shared.selectIV {
//            do {
//                let aes = try AES(key: Array(key.utf8), blockMode: CBC(iv: Array(iv.utf8)), padding: .pkcs7)
//                let ciphertext = try aes.encrypt(jsonData.bytes)
//                return ciphertext.toBase64()
//            } catch {
//            }
//        }
//        return nil
//    }
//    
//    func handleResponse<T: Decodable>(type: T.Type, comment: String? = nil, hasData: Bool = true) -> T? {
//        let ct: String
//        if let comment = comment {
//            ct = "(\(comment))"
//        } else {
//            ct = ""
//        }
//        guard let msg = self["msg"] as? String else { return nil }
//        if msg == "success" {
//            if let jsonData = self["data"] {
//                if AnyUtil.isNative(value: jsonData), let result = jsonData as? T {
//                    return result
//                } else if let data = try? JSONSerialization.data(withJSONObject: jsonData, options: []) {
//                    if let object = try? JSONDecoder().decode(type, from: data) {
//                        return object
//                    } else {
//                        AlertUtil.simpleAlert(title: "伺服器異常\(ct)", msg: "Data為非預期格式")
//                    }
//                }
//            } else if hasData {
//                AlertUtil.simpleAlert(title: "伺服器異常\(ct)", msg: "Data為空")
//            }
//        } else {
//            AlertUtil.simpleAlert(title: "伺服器異常\(ct)", msg: msg)
//        }
//        return nil
//    }
//    
//    func handleResponseWithoutData(comment: String? = nil) -> String? {
//        let ct: String
//        if let comment = comment {
//            ct = "(\(comment))"
//        } else {
//            ct = ""
//        }
//        guard let msg = self["msg"] as? String else { return nil }
//        if msg != "success" {
//            AlertUtil.simpleAlert(title: "伺服器異常\(ct)", msg: msg)
//        } else {
//            return msg
//        }
//        return nil
//    }
//}
//
//
//class VersionHandler: NSObject {
//    static let shared: VersionHandler = VersionHandler()
//    let currentVersion: CurrentValueSubject<String?, Never>
//    let cloudVersionInfo: CurrentValueSubject<WLVersionInfo?, Never>
//    let appChineseName = "Wholive+ 租屋管家"
//    var checkEncrypt: Bool = false
//    var selectKey: String?
//    var selectIV: String?
//    var check: String = "2PW3hhjFm8/r15bgzvlpLAe=="
//    var AESKey: String {
//        return "secret0key000000secret0key000000"
//    }
//    var oldAESKey: String {
//        return "secret0key000000secret0key000000"
//    }
//    var iv: String {
//        return "secret0key000000"
//    }
//    var oldiv: String {
//        return "secret0key000000"
//    }
//    var AESkeyForBankee: String {
//        return "secret0key000000secret0key000000"
//    }
//    var AESivForBankee: String {
//        return "secret0key000000"
//    }
//    
//    var isLatest: Bool {
//        return CompareVersion(current: self.currentVersion.value, compare: self.cloudVersionInfo.value?.latestVersion) ?? 1 == 0
//    }
//    var isForceUpdate: Bool {
//        return CompareVersion(current: currentVersion.value, compare: self.cloudVersionInfo.value?.mandatoryVersion) ?? 0 == 1
//    }
//    
//    override init() {
//        currentVersion = CurrentValueSubject<String?, Never>(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)
//        cloudVersionInfo = CurrentValueSubject<WLVersionInfo?, Never>(nil)
//    }
//    func fetch(completion: ((Bool) -> Void)? = nil) {
////        WLProvider.request(target: .getAppVersion(dev: "ios"), type: .regular)
////        .mapJSON()
////        .flatMap({ (item) -> Single<WLVersionInfo?> in
////            if let dic = item as? [String: Any] {
////                return .just(dic.handleResponse(type: WLVersionInfo.self, comment: "版本") ?? nil)
////            }
////            return .just(nil)
////        })
////        .subscribe(onSuccess: { [weak self] (versionInfo) in
////            guard let self = self, let versionInfo = versionInfo else { return }
////            print("Successfully get cloud app version \(versionInfo)")
////            self.checkEncrypt = true
////            if let apiUrl = versionInfo.apiUrl {
////                WLURL.apiURL = apiUrl
////            }
////            if let checkCode = versionInfo.checkCode {
////                guard let _ = checkCode.decryptStringToDataCheck else {
////                    AlertUtil.showAlert(AlertModel(type: .single, isLock: true, titleString: "需進行更新，請前往App Store更新", confirmButtonString: "前往",confirmButtonAction: {
////                                let lineURL = URL(string: "itms-apps://itunes.apple.com/app/id1565895971")!
////                                UIApplication.shared.open(lineURL, options: [:], completionHandler: nil)
////                            }))
////                    return
////                }
////            } else {
////                self.selectKey = nil
////                self.selectIV = nil
////            }
////            self.cloudVersionInfo.accept(versionInfo)
////            completion?(true)
////        }) { (error) in
////            print("Failed to fetch cloud app version with error:\n\(error)")
////            if let err = (error as? MoyaError), let res = err.response, res.statusCode == 200 {
////                AlertUtil.showAlert(AlertModel(type: .single, isLock: true, titleString: "需進行更新，請前往App Store更新", confirmButtonString: "前往",confirmButtonAction: {
////                            let lineURL = URL(string: "itms-apps://itunes.apple.com/app/id1565895971")!
////                            UIApplication.shared.open(lineURL, options: [:], completionHandler: nil)
////                        }))
////            }
////            completion?(false)
////        }.disposed(by: self.disposeBag)
//    }
//    func CompareVersion(current: String?, compare: String?) -> Int? {
//        guard let current = current, let compare = compare else { return nil }
//        let compareArray = compare.split(separator: ".")
//        let currentArray = current.split(separator: ".")
//        if compareArray.count == currentArray.count {
//            for index in 0..<currentArray.count {
//                if isPurnInt(string: String(currentArray[index])) && isPurnInt(string: String(compareArray[index])) {
//                    if Int(currentArray[index])! < Int(compareArray[index])! {
//                        return 1
//                    } else if Int(currentArray[index])! > Int(compareArray[index])! {
//                        return -1
//                    }
//                } else {
//                    return nil
//                }
//            }
//            return 0
//        } else {
//            return nil
//        }
//    }
//    func isPurnInt(string: String) -> Bool {
//
//        let scan: Scanner = Scanner(string: string)
//
//        var val:Int = 0
//
//        return scan.scanInt(&val) && scan.isAtEnd
//
//    }
//}
//
//extension String {
//    var decryptStringToDataCheck: Data? {
//        if let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) {
//            do {
//                // 用AES方式將Data解密
//                let aesDec: AES = try AES(key: Array(VersionHandler.shared.AESKey.utf8), blockMode: CBC(iv: Array(VersionHandler.shared.iv.utf8)), padding: .pkcs7)
//                let dec = try aesDec.decrypt(data.bytes)
//                var returnData = Data(bytes: dec, count: dec.count)
//                
//                if String(decoding: returnData, as: UTF8.self) == VersionHandler.shared.check {
//                    VersionHandler.shared.selectKey = VersionHandler.shared.AESKey
//                    VersionHandler.shared.selectIV = VersionHandler.shared.iv
//                    return returnData
//                } else {
//                    let aesOldDec: AES = try AES(key: Array(VersionHandler.shared.oldAESKey.utf8), blockMode: CBC(iv: Array(VersionHandler.shared.oldiv.utf8)), padding: .pkcs7)
//                    let oldDec = try aesOldDec.decrypt(data.bytes)
//                    returnData = Data(bytes: oldDec, count: oldDec.count)
//                    if String(decoding: returnData, as: UTF8.self) == VersionHandler.shared.check {
//                        VersionHandler.shared.selectKey = VersionHandler.shared.oldAESKey
//                        VersionHandler.shared.selectIV = VersionHandler.shared.oldiv
//                        return returnData
//                    } else {
//                        VersionHandler.shared.selectKey = nil
//                        VersionHandler.shared.selectIV = nil
//                    }
//                }
//            } catch {
//                return nil
//            }
//        }
//        return nil
//    }
//    var decryptStringToData: Data? {
//        if let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)), let key = VersionHandler.shared.selectKey, let iv = VersionHandler.shared.selectIV {
//            do {
//                // 用AES方式將Data解密
//                let aesDec: AES = try AES(key: Array(key.utf8), blockMode: CBC(iv: Array(iv.utf8)), padding: .pkcs7)
//                let dec = try aesDec.decrypt(data.bytes)
//                return Data(bytes: dec, count: dec.count)
//            } catch {
//                return nil
//            }
//        }
//        return nil
//    }
//}
//class AnyUtil {
//    static func isNative(value: Any) -> Bool {
//        if value is Int {
//            return true
//        } else if value is String  {
//            return true
//        } else if value is Bool  {
//            return true
//        } else if value is Double  {
//            return true
//        } else if value is Float  {
//            return true
//        } else if value is UInt  {
//            return true
//        }
//        return false
//    }
//}
//
//struct WLVersionInfo: Decodable {
//
//    var latestVersion: String
//    var mandatoryVersion: String
//    var checkCode: String?
//    var apiUrl: URL?
//    
//    enum CodingKeys: String, CodingKey {
//        case latestVersion = "latest_version"
//        case mandatoryVersion = "mandatory_version"
//        case checkCode = "check_code"
//        case apiUrl = "api_url"
//    }
//}
//#endif
