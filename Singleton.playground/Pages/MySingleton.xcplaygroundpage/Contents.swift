public class MySingleton {
    static let shared = MySingleton()
    private init() { }
}

let mySingleton = MySingleton.shared
