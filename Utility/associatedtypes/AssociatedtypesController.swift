import UIKit

class AssociatedtypesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tree = Product(name: "tree", color: .green, size: .large)
        let frog = Product(name: "frog", color: .green, size: .small)
        let strawberry = Product(name: "strawberry", color: .red, size: .small)

        let small = SizeSpecification(size: .small)

        let result = ProductFilter().filter(items: [tree, frog, strawberry], specs: small)
        print(result)
        
        let small2 = SizeSpecificationGeneric<Product>(size: .small)
        let result2 = GenericFilter().filter(items: [tree, frog, strawberry], specs: small2)
        print(result2)
        
        let red = ColorSpecificationGeneric<Product>(color: .red)
        let specs = AndSpecification(specA: red, specB: small2)

        let result3 = GenericFilter().filter(items: [tree, frog, strawberry], specs: specs)
        print(result3)
    }

}

struct AndSpecification<T, SpecA: Specification, SpecB: Specification> : Specification where T == SpecA.T, SpecA.T == SpecB.T {

    var specA: SpecA
    var specB: SpecB

    init(specA: SpecA, specB: SpecB) {
        self.specA = specA
        self.specB = specB
    }

    func isSatisfied(item: T) -> Bool {
        return specA.isSatisfied(item: item) && specB.isSatisfied(item: item)
    }
}

// MARK: 使用靜態初始化設置關聯類型
protocol Sized {
    var size: Size { get set }
}

protocol Colored {
    var color: Color { get set }
}

//MARK: Have type you want to filter conform to protocols
extension Product : Colored, Sized { }


//MARK: Refactor Specification entities to work with any type that has the necessary property
struct ColorSpecificationGeneric<T: Colored> : Specification {

    var color: Color

    func isSatisfied(item: T) -> Bool {
        return item.color == color
    }
}

struct SizeSpecificationGeneric<T: Sized> : Specification {

    var size: Size

    func isSatisfied(item: T) -> Bool {
        return item.size == size
    }
}

struct GenericFilter<T> : Filter {

    func filter<Spec: Specification>(items: [T], specs: Spec) -> [T]
        where T == Spec.T {
            var output = [T]()
            for item in items {
                if specs.isSatisfied(item: item) {
                    output.append(item)
                }
            }
            return output
    }
}


// MARK: typealias 設置 associatedtypes, 檢查通用實例的條件
protocol Filter {
    associatedtype T

    func filter<Spec: Specification>(items: [T], specs: Spec) -> [T]
    where Spec.T == T
}

struct ProductFilter : Filter {
    typealias T = Product
//    func filter(items: [Product], by spec: Specification) -> [Product] {
//        return []
//    }
    func filter<Spec: Specification>(items: [Product], specs: Spec) -> [Product]
        where ProductFilter.T == Spec.T {
            var output = [T]()
            for item in items {
                if specs.isSatisfied(item: item) {
                    output.append(item)
                }
            }
            return output
    }
}
// MARK:
protocol Specification {
    associatedtype T

    func isSatisfied(item: T) -> Bool
}

struct ColorSpecification: Specification {
    typealias T = Product

    var color: Color

    func isSatisfied(item: Product) -> Bool {
        return item.color == color
    }
}

struct SizeSpecification: Specification {
    typealias T = Product

    var size: Size

    func isSatisfied(item: Product) -> Bool {
        return item.size == size
    }
}

// MARK: Model
enum Size {
    case small
    case medium
    case large
}

enum Color {
    case red
    case green
    case blue
}

struct Product {

    var name: String
    var color: Color
    var size: Size

}
