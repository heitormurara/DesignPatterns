import Foundation

// MARK: - Originator
public class Game: Codable {
    
    public class State: Codable {
      public var attemptsRemaining: Int = 3
      public var level: Int = 1
      public var score: Int = 0
    }
    
    public var state = State()
    
    public func rackUpMassivePoints() {
      state.score += 9002
    }
    
    public func monstersEatPlayer() {
      state.attemptsRemaining -= 1
    }
}

// MARK: - Memento
typealias GameMemento = Data

// MARK: - Care Taker
public class GameSystem {
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let userDefaults = UserDefaults.standard

    public func save(_ game: Game, title: String) throws {
        let data = try encoder.encode(game)
        userDefaults.set(data, forKey: title)
    }

    public func load(title: String) throws -> Game {
        guard let data = userDefaults.data(forKey: title), let game = try? decoder.decode(Game.self, from: data) else {
            throw Error.gameNotFound
        }
        
        return game
    }
    
    public enum Error: String, Swift.Error {
        case gameNotFound
    }
}

// MARK: - Testing
var game = Game()
game.monstersEatPlayer()
game.rackUpMassivePoints()

let gameSystem = GameSystem()
try gameSystem.save(game, title: "Best Game Ever")

game = Game()
print("New Game Score: \(game.state.score)")

game = try gameSystem.load(title: "Best Game Ever")
print("Loaded Game Score: \(game.state.score)")
