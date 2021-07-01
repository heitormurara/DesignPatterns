/// Use a Singleton when having more than one instance would cause problems
class Singleton {
    
    static let shared = Singleton()
    
    private init() {}
}

let singleton = Singleton.shared

/// Use a Singleton Plus if a shared instance is useful _most_ of the time, but you also want custom instances
class SingletonPlus {
    
    static let shared = SingletonPlus()
    
    init() {}
}

let singletonPlus1 = SingletonPlus.shared
let singletonPlus2 = SingletonPlus()
