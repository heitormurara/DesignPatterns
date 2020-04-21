import Foundation

@objcMembers public class KVOUser: NSObject {
    dynamic var name: String
    
    public init(name: String) {
        self.name = name
    }
}

print("-- KVO Example --")
let kvoUser = KVOUser(name: "Ray")
var kvoObserver: NSKeyValueObservation? = kvoUser.observe(\.name, options: [.initial, .new]) { (user, change) in
    print("User's name is: \(user.name)")
}

kvoUser.name = "Ray 2"
kvoObserver = nil
kvoUser.name = "Ray 3"
