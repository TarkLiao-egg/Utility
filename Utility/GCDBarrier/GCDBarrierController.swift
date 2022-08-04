import UIKit

class GCDBarrierController: UIViewController {
//    https://blog.csdn.net/HelloMagina/article/details/118609747
//    https://blog.csdn.net/Hello_Hwc/article/details/50037505?utm_medium=distribute.pc_relevant.none-task-blog-2~default~baidujs_baidulandingword~default-0-50037505-blog-118609747.pc_relevant_show_downloadRating&spm=1001.2101.3001.4242.1&utm_relevant_index=3
    let contacts = [("Leijun", "leijun@mi.com"), ("Luoyonghao", "luoyonghao@smartisan.com"), ("Yuchengdong", "yuchengdong@huawei.com"), ("Goodguy", "Goodguy@gmail.com")]
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let person = Person(name: "unknown", email: "unknown")
        updateContact(person: person, contacts: contacts)
        
        
        let threadPerson = ThreadSafePerson(name: "unknown", email: "unknown")
        updateContact(person: threadPerson, contacts: contacts)
    }

    
    func updateContact(person: Person, contacts: [(String, String)]){
        let isSafe: String
        if let _ = person as? ThreadSafePerson {
            isSafe = "safe:"
        } else {
            isSafe = "non-safe:"
        }
        let dispatchQueue = DispatchQueue(label: "test", attributes: .concurrent)
//        let dispatchQueue = DispatchQueue.global()
        for (name, email) in contacts {
            dispatchQueue.async(group: dispatchGroup) {
                person.setProperty(name: name, email: email)
                print(isSafe + person.description)
            }
        }
        
        dispatchGroup.notify(queue: dispatchQueue) {
            print(isSafe + "Final person: \(person.description)")
        }
    }
    
//    func updateContractBarrier(person: Person, contacts: [(String, String)]){
//        let dispatchQueue = DispatchQueue(label: "test", attributes: .concurrent)
//        for (name, email) in contacts {
//            dispatchQueue.async(group: dispatchGroup, flags: DispatchWorkItemFlags.barrier) {
//                person.setProperty(name: name, email: email)
//                print("Current person: \(person.name), \(person.email)")
//            }
//        }
//
//        dispatchGroup.notify(queue: dispatchQueue) {
//            print("Final person: \(person.name), \(person.email)")
//        }
//    }
}

class Person: NSObject {
    var name: String
    var email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
    func setProperty(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
    override var description: String {
        return "\(name), \(email)"
    }
}

class ThreadSafePerson: Person {
    let isolationQueue = DispatchQueue(label: "com.crafttang.isolationQueue", attributes: .concurrent)
    override func setProperty(name: String, email: String) {
        isolationQueue.async(flags: .barrier) {
            super.setProperty(name: name, email: email)
        }
    }
    
    override var description: String {
        return isolationQueue.sync { "\(super.name), \(super.email)" }
    }
    
    var Dname: String {
        get {
            return isolationQueue.sync { super.name }
        }
    }
    var Demail: String {
        get {
            return isolationQueue.sync { super.email }
        }
    }
}
