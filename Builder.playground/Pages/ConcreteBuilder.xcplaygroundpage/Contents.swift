import XCTest

protocol Builder {
    func producePartA()
    func producePartB()
    func producePartC()
}

class ConcreteBuilder1: Builder {
    private var product = Product1()
    
    func reset() {
        product = Product1()
    }
    
    func producePartA() {
        product.add(part: "Part A1")
    }
    
    func producePartB() {
        product.add(part: "Part B1")
    }
    
    func producePartC() {
        product.add(part: "Part C1")
    }
    
    func retrieveProduct() -> Product1 {
        let result = self.product
        reset()
        return result
    }
}

class Director {
    private var builder: Builder?
    
    func update(builder: Builder) {
        self.builder = builder
    }
    
    func buildMinimalValuableProduct() {
        builder?.producePartA()
    }
    
    func buildFullFeaturedProduct() {
        builder?.producePartA()
        builder?.producePartB()
        builder?.producePartC()
    }
}

class Client {
    static func someClientCode(director: Director) {
        let builder = ConcreteBuilder1()
        director.update(builder: builder)
        
        print("Standard basic product:")
        director.buildMinimalValuableProduct()
        print(builder.retrieveProduct().listParts())
        
        print("Standard full featured product:")
        director.buildFullFeaturedProduct()
        print(builder.retrieveProduct().listParts())
        
        print("Custom product:")
        builder.producePartA()
        builder.producePartC()
        print(builder.retrieveProduct().listParts())
    }
}

class Product1 {
    private var parts = [String]()
    
    func add(part: String) {
        self.parts.append(part)
    }
    
    func listParts() -> String {
        return "Product parts: \(parts.joined(separator: ", "))\n"
    }
}

Client.someClientCode(director: Director())
