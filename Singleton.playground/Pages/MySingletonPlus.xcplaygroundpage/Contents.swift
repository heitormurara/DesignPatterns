public class MySingletonPlus {
    static let shared = MySingletonPlus()
    public init() { }
}

let singletonPlus1 = MySingletonPlus.shared
let singletonPlus2 = MySingletonPlus()
