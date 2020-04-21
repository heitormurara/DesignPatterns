import Foundation

// MARK: - Structures

struct Customer {
    let identifier: String
    var address: String
    var name: String
}

extension Customer: Hashable {
    
    var hashValue: Int {
        return identifier.hashValue
    }
    
    public static func ==(lhs: Customer,
                          rhs: Customer) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

struct Product {
    let identifier: String
    var name: String
    var cost: Double
}

extension Product: Hashable {
    var hashValue: Int {
        return identifier.hashValue
    }
    
    public static func ==(lhs: Product,
                          rhs: Product) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}


// MARK: - Databases

class InventoryDatabase {
    
    var inventory: [Product: Int] = [:]
    
    init(inventory: [Product: Int]) {
        self.inventory = inventory
    }
}

class ShippingDatabase {
    
    var pendingShipments: [Customer: [Product]] = [:]
}


// MARK: - Facade

class OrderFacade {
    
    let inventoryDatabase: InventoryDatabase
    let shippingDatabase: ShippingDatabase
    
    init(inventoryDatabase: InventoryDatabase,
         shippingDatabase: ShippingDatabase) {
        self.inventoryDatabase = inventoryDatabase
        self.shippingDatabase = shippingDatabase
    }
    
    func placeOrder(for product: Product,
                    by customer: Customer) {
        print("Place order for \(product.name) by \(customer.name)")
        
        let count = inventoryDatabase.inventory[product, default: 0]
        guard count > 0 else {
            print("\(product.name) is out of stock!")
            return
        }
        
        inventoryDatabase.inventory[product] = count - 1
        
        var shipments = shippingDatabase.pendingShipments[customer, default: []]
        shipments.append(product)
        shippingDatabase.pendingShipments[customer] = shipments
        
        print("Order placed for \(product.name) by \(customer.name)")
    }
}


// MARK: - Example

let rayDoodle = Product(identifier: "product-001", name: "Ray's Doodle", cost: 0.25)
let vickiPoodle = Product(identifier: "product-002", name: "Vicki's prized poodle", cost: 1000)

let inventoryDatabase = InventoryDatabase(inventory: [rayDoodle: 50, vickiPoodle: 1])

let orderFacade = OrderFacade(inventoryDatabase: inventoryDatabase, shippingDatabase: ShippingDatabase())

let customer = Customer(identifier: "customer-001", address: "1600 Pennsylvania Ave, Wahington, DC 20006", name: "Johnny Applesed")

orderFacade.placeOrder(for: vickiPoodle, by: customer)
