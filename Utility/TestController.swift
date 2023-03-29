import UIKit
import SnapKit
import Combine
import SwiftUI
class RefType {
    var i: Int
    required init(_ i : Int) {
        self.i = i
    }
//    required init(_ i: Int) {
//        self.i = i
//    }
}

class RefType2: RefType {
    var d: Int
    init(_ d: Int, i : Int) {
        self.d = d
        super.init(i)
    }
    
    required init(_ i: Int) {
        self.d = 2
        super.init(i)
    }
}

@available(iOS 13.0, *)
class TestController: UIViewController {
    var data: ((Int) -> Bool)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            
            
        
        var node3 = Node(value: 3)
        var node5 = Node(value: 5, next: node3)
        var node4 = Node(value: 4, next: node5)
        var node2 = Node(value: 2, next: node4)
        var head = Node(value: 1, next: node2)
        var newHeads = sortLinkList(head)
//        while newHeads != nil {
//            print(newHeads?.value)
//            newHeads = newHeads?.next
//        }

//        var newHeads = sortLinkedList(head: head)
//        while newHeads != nil {
//            print(newHeads?.value)
//            newHeads = newHeads?.next
//        }
        view.backgroundColor = .white
        let array = [1,2,3,4,5]
//        print(array.indices)
//        var i: RefType = RefType(0)
//        DispatchQueue.global().async {
//            for _ in 1...10000 {
//                i.i += 1
//            }
//        }
//        DispatchQueue.global().async {
//            for _ in 1...20000 {
//                i.i += 1
//            }
//        }
//        DispatchQueue.global().async {
//            for _ in 1...30000 {
//                i.i += 1
//            }
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            print(i.i)
//        }
//        MemoryManager.run()
//        doSome { we in
//            return we == 2
//        }
    }
    // 1 2 4 5 3
    // 1 new
    //
    func sortLinkList(_ head: Node) -> Node? {
//        var nodes = [Node]()
//        var head: Node? = head
//        repeat {
//            nodes.append(head!)
//            head = head?.next
//        } while head != nil
//
//        nodes.sort { n1, n2 in
//            return n1.value > n2.value
//        }
//        for (i, _) in nodes.enumerated() {
//            if nodes.indices.contains(i + 1) {
//                nodes[i].next = nodes[i + 1]
//            } else {
//                nodes[i].next = nil
//            }
//        }
//        printNode(nodes[0])
        var newNode: Node = head

        var current: Node? = head.next
        var previous: Node? = head
        repeat {
            var nextNode = newNode
            if current!.value > nextNode.value {
                previous!.next = current!.next
                current!.next = nextNode
                nextNode = current!
                newNode = nextNode
                current = current!.next
            } else if current!.value < nextNode.value {
                print("tark")
                print(nextNode.value)
                print(current!.value)
                print(previous!.value)
//                while nextNode.next != nil {
//                    nextNode = nextNode.next!
//                    if current!.value > nextNode.value {
//                        previous!.next = current!.next
//                        current!.next = nextNode
//                        nextNode = current!
//                    }
//                }
            }
            previous = current
            current = current!.next
            printNode(newNode)
        } while current!.next != nil
        
        return nil
    }
    
    func printNode(_ head: Node) {
        var head: Node? = head
        var i: String = ""
        repeat {
            i += "\(head!.value) -> "
            head = head?.next
        } while head != nil
        print(i)
    }
    
    func doSome(_ closure: (Int) -> Bool) {
        print(closure(2))
    }
    
    func sortLinkedList(head: Node?) -> Node? {
        guard let head = head else {
            return nil
        }
        
        var newHead: Node? = nil
        var currentNode: Node? = head
        
        while currentNode != nil {
            let nextNode = currentNode!.next
            
            // 將當前節點插入到新鏈表的正確位置
            if newHead == nil || currentNode!.value > newHead!.value {
                currentNode!.next = newHead
                newHead = currentNode
            } else {
                var prevNode: Node? = newHead
                while prevNode!.next != nil && currentNode!.value <= prevNode!.next!.value {
                    prevNode = prevNode!.next
                }
                currentNode!.next = prevNode!.next
                prevNode!.next = currentNode
            }
            
            currentNode = nextNode
        }
        
        return newHead
    }

}

@available(iOS 13.0, *)
extension TestController {
    func setupButton() {
        UIButton().VS({
            $0.setTitle("Test", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.addTarget(self, action: #selector(self.testAction), for: .touchUpInside)
        }, view) { make in
            make.size.equalTo(60)
            make.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    @objc func testAction() {
        
    }
}
class Node {
    var value: Int
    var next: Node?
    
    init(value: Int, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}
