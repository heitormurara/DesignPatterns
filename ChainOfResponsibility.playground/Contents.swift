import Foundation

// MARK: - Models
class Coin {
    
    class var standardDiameter: Double {
        return 0
    }
    
    class var standardWeight: Double {
        return 0
    }
    
    var centValue: Int { return 0 }
    final var dollarValue: Double { return Double(centValue) / 100 }
    
    final let diameter: Double
    final let weight: Double
    
    required init(diameter: Double, weight: Double) {
        self.diameter = diameter
        self.weight = weight
    }
    
    convenience init() {
        let diameter = type(of: self).standardDiameter
        let weight = type(of: self).standardWeight
        self.init(diameter: diameter, weight: weight)
    }
}

extension Coin: CustomStringConvertible {
    
    var description: String {
        return String(format: "%@ {diameter: %0.3f, dollarValue: $%0.2f, weight: %0.3f}", "\(type(of: self))", diameter, dollarValue, weight)
    }
}

// MARK: - Concrete Coin Types
class Penny: Coin {
    
    override class var standardDiameter: Double {
        return 0.75
    }
    
    override class var standardWeight: Double {
        return 2.5
    }
    
    override var centValue: Int {
        return 1
    }
}

class Nickel: Coin {
    
    override class var standardDiameter: Double {
        return 0.835
    }
    
    override class var standardWeight: Double {
        return 5.0
    }
    
    override var centValue: Int {
        return 5
    }
}

class Dime: Coin {
    
    override class var standardDiameter: Double {
        return 0.705
    }
    
    override class var standardWeight: Double {
        return 2.268
    }
    
    override var centValue: Int {
        return 10
    }
}

class Quarter: Coin {
    
    override class var standardDiameter: Double {
        return 0.955
    }
    
    override class var standardWeight: Double {
        return 5.670
    }
    
    override var centValue: Int {
        return 25
    }
}

// MARK: - Handler Protocol
protocol CoinHandlerProtocol {
    var next: CoinHandlerProtocol? { get }
    func handleCoinValidator(_ unknownCoin: Coin) -> Coin?
}

// MARK: - Concrete Handler
class CoinHandler {
    
    var next: CoinHandlerProtocol?
    let coinType: Coin.Type
    let diameterRange: ClosedRange<Double>
    let weightRange: ClosedRange<Double>
    
    init(coinType: Coin.Type,
         diameterVariation: Double = 0.01,
         weightVariation: Double = 0.05) {
        
        self.coinType = coinType
        
        let standardDiameter = coinType.standardDiameter
        self.diameterRange = (1 - diameterVariation) * standardDiameter ... (1 + diameterVariation) * standardDiameter
        
        let standardWeight = coinType.standardWeight
        self.weightRange = (1 - weightVariation) * standardWeight ... (1 + weightVariation) * standardWeight
    }
}

extension CoinHandler: CoinHandlerProtocol {
    
    func handleCoinValidator(_ unknownCoin: Coin) -> Coin? {
        guard let coin = createCoin(from: unknownCoin) else {
            return next?.handleCoinValidator(unknownCoin)
        }
        return coin
    }
    
    private func createCoin(from unknownCoin: Coin) -> Coin? {
        print("Attempt to create \(coinType)")
        guard diameterRange.contains(unknownCoin.diameter) else {
            print("Invalid diameter")
            return nil
        }
        
        guard weightRange.contains(unknownCoin.weight) else {
            print("Invalid weight")
            return nil
        }
        
        let coin = coinType.init(diameter: unknownCoin.diameter, weight: unknownCoin.weight)
        print("Created \(coin)")
        return coin
    }
}

// MARK: - Client
class VendingMachine {
    let coinHandler: CoinHandler
    var coins: [Coin] = []
    
    init(coinHandler: CoinHandler) {
        self.coinHandler = coinHandler
    }

    func insertCoin(_ unknownCoin: Coin) {
        guard let coin = coinHandler.handleCoinValidator(unknownCoin) else {
            print("Coin rejected: \(unknownCoin)")
            return
        }
        
        print("Coin accepted: \(coin)")
        coins.append(coin)
        
        let dollarValue = coins.reduce(0, { $0 + $1.dollarValue })
        print("Coins Total Value: $\(dollarValue)")
        
        let weight = coins.reduce(0, { $0 + $1.dollarValue })
        print("Coins Total Weight: \(weight)g")
        print("")
    }
}

// MARK: - Example
let pennyHandler = CoinHandler(coinType: Penny.self)
let nickleHandler = CoinHandler(coinType: Nickel.self)
let dimeHandler = CoinHandler(coinType: Dime.self)
let quarterHandler = CoinHandler(coinType: Quarter.self)

pennyHandler.next = nickleHandler
nickleHandler.next = dimeHandler
dimeHandler.next = quarterHandler

let vendingMachine = VendingMachine(coinHandler: pennyHandler)

vendingMachine.insertCoin(Penny())
vendingMachine.insertCoin(Quarter())

let invalidDime = Coin(diameter: Quarter.standardDiameter, weight: Dime.standardWeight)
vendingMachine.insertCoin(invalidDime)
