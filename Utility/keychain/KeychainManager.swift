import UIKit

class KeychainManager: NSObject {
    static let keychainQuery: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: "uuid",
        kSecAttrService as String: "uuid",
        kSecReturnAttributes as String: true,
        kSecReturnData as String: true
    ]
    
    class func create(_ saveStr: String) -> Bool {
        let saveData = saveStr.data(using: .utf8)!
        var keychainQuery = keychainQuery
        keychainQuery[kSecValueData as String] = saveData

        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    class func read() -> String? {
        var item: CFTypeRef?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &item)
        if status != errSecSuccess {
            return nil
        }

        if let itemDict = item as? [String: Any],
           let saveData = itemDict[kSecValueData as String] as? Data,
           let saveStr = String(data: saveData, encoding: .utf8) {
            return saveStr
        } else {
            return nil
        }
    }
    
    class func update(_ saveStr: String) -> Bool {
        let saveData = saveStr.data(using: .utf8)!
        var keychainQuery = keychainQuery
        keychainQuery.removeValue(forKey: kSecReturnAttributes as String)
        keychainQuery.removeValue(forKey: kSecReturnData as String)
        let updateQuery: [String: Any] = [
            kSecValueData as String: saveData
        ]

        let status = SecItemUpdate(keychainQuery as CFDictionary, updateQuery as CFDictionary)
        return status == errSecSuccess
    }
    
    class func delete() -> Bool {
        let status = SecItemDelete(keychainQuery as CFDictionary)
        return status == errSecSuccess
    }
    
    
    // TODO: 创建查询条件
    class func createQuaryMutableDictionary(identifier:String)->NSMutableDictionary{
        // 创建一个条件字典
        let keychainQuaryMutableDictionary = NSMutableDictionary.init(capacity: 0)
        // 设置条件存储的类型
        keychainQuaryMutableDictionary.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
        // 设置存储数据的标记
        keychainQuaryMutableDictionary.setValue(identifier, forKey: kSecAttrService as String)
        keychainQuaryMutableDictionary.setValue(identifier, forKey: kSecAttrAccount as String)
        // 设置数据访问属性
        keychainQuaryMutableDictionary.setValue(kSecAttrAccessibleAfterFirstUnlock, forKey: kSecAttrAccessible as String)
        // 返回创建条件字典
        return keychainQuaryMutableDictionary
    }
    
    // TODO: 存储数据
    class func keyChainSaveData(data:Any ,withIdentifier identifier:String = "KeyChain")->Bool {
        // 获取存储数据的条件
        let keyChainSaveMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // 删除旧的存储数据
        SecItemDelete(keyChainSaveMutableDictionary)
        // 设置数据
        keyChainSaveMutableDictionary.setValue(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as String)
        // 进行存储数据
        let saveState = SecItemAdd(keyChainSaveMutableDictionary, nil)
        if saveState == noErr  {
            return true
        }
        return false
    }
    
    // TODO: 更新数据
    class func keyChainUpdata(data:Any ,withIdentifier identifier:String = "KeyChain")->Bool {
        // 获取更新的条件
        let keyChainUpdataMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // 创建数据存储字典
        let updataMutableDictionary = NSMutableDictionary.init(capacity: 0)
        // 设置数据
        updataMutableDictionary.setValue(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as String)
        // 更新数据
        let updataStatus = SecItemUpdate(keyChainUpdataMutableDictionary, updataMutableDictionary)
        if updataStatus == noErr {
            return true
        }
        return false
    }
    
    
    // TODO: 获取数据
    class func keyChainReadData(identifier:String = "KeyChain")-> Any? {
        var idObject:Any?
        // 获取查询条件
        let keyChainReadmutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // 提供查询数据的两个必要参数
        keyChainReadmutableDictionary.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        keyChainReadmutableDictionary.setValue(kSecMatchLimitOne, forKey: kSecMatchLimit as String)
        // 创建获取数据的引用
        var queryResult: AnyObject?
        // 通过查询是否存储在数据
        let readStatus = withUnsafeMutablePointer(to: &queryResult) { SecItemCopyMatching(keyChainReadmutableDictionary, UnsafeMutablePointer($0))}
        if readStatus == errSecSuccess {
            if let data = queryResult as! NSData? {
                idObject = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as Any
                return idObject as Any
            }
        }
        return nil
    }
    
    
    
    // TODO: 删除数据
    class func keyChianDelete(identifier:String = "KeyChain")->Void{
        // 获取删除的条件
        let keyChainDeleteMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // 删除数据
        SecItemDelete(keyChainDeleteMutableDictionary)
    }
}

//        // 存储数据
//        let saveBool = KeychainManager.keyChainSaveData(data: "我期待的女孩" as Any, withIdentifier: identify)
//        if saveBool {
//            print("存储成功")
//        }else{
//            print("存储失败")
//        }
//        // 获取数据
//        if let getString = KeychainManager.keyChainReadData(identifier: identify) {
//            print(getString as! String)
//        } else {
//            print("nil")
//        }
//
//
//        // 更新数据
//        let updataBool = KeychainManager.keyChainUpdata(data: "眼睛像云朵", withIdentifier: identify)
//        if updataBool {
//            print("更新成功")
//        }else{
//            print("更新失败")
//        }
//        // 获取更新后的数据
//        let getUpdataString = KeychainManager.keyChainReadData(identifier: identify) as! String
//        print(getUpdataString)
//
//
//        // 删除数据
//        KeychainManager.keyChianDelete(identifier: identify)
//        // 获取删除后的数据
//        let getDeleteString = KeychainManager.keyChainReadData(identifier: identify)
//        print(getDeleteString)
