/*
 This pattern works best for "information only" delegate calls - Multiple delegates would be asked to provide the data, which could result in duplicated information or wasted processing.
 */

class MulticastDelegate<ProtocolType> {
    
    private class DelegateWrapper {
        
        weak var delegate: AnyObject?
        
        init(_ delegate: AnyObject?) {
            self.delegate = delegate
        }
    }
    
    private var delegateWrappers: [DelegateWrapper]
    
    public var delegates: [ProtocolType] {
        delegateWrappers = delegateWrappers.filter { $0.delegate != nil }
        return delegateWrappers.map { $0.delegate! } as! [ProtocolType]
    }
    
    init(delegates: [ProtocolType] = []) {
        delegateWrappers = delegates.map {
            DelegateWrapper($0 as AnyObject)
        }
    }
    
    func addDelegate(_ delegate: ProtocolType) {
        let wrapper = DelegateWrapper(delegate as AnyObject)
        delegateWrappers.append(wrapper)
    }
    
    func removeDelegate(_ delegate: ProtocolType) {
        guard let index = delegateWrappers.firstIndex(where: { $0.delegate === (delegate as AnyObject) }) else {
            return
        }
        delegateWrappers.remove(at: index)
    }
    
    func invokeDelegates(_ closure: (ProtocolType) -> ()) {
        delegates.forEach { closure($0) }
    }
}


protocol EmergencyResponding {
    func notifyFire(at location: String)
    func notifyCarCrash(at location: String)
}

class FireStation: EmergencyResponding {
    
    func notifyFire(at location: String) {
        print("Firefighters were notified about a fire at " + location)
    }
    
    func notifyCarCrash(at location: String) {
        print("Firefighters were notified about a car crash at " + location)
    }
}

class PoliceStation: EmergencyResponding {
    
    func notifyFire(at location: String) {
        print("Police were notified about a fire at " + location)
    }
    
    func notifyCarCrash(at location: String) {
        print("Police were notified about a car crash at " + location)
    }
}

class DispatchSystem {
    let multicastDelegate = MulticastDelegate<EmergencyResponding>()
}


let dispatch = DispatchSystem()
var policeStation: PoliceStation! = PoliceStation()
var fireStation: FireStation! = FireStation()

dispatch.multicastDelegate.addDelegate(policeStation)
dispatch.multicastDelegate.addDelegate(fireStation)

dispatch.multicastDelegate.invokeDelegates {
    $0.notifyFire(at: "Ray's house!")
}

print("")
fireStation = nil

dispatch.multicastDelegate.invokeDelegates {
    $0.notifyCarCrash(at: "Ray's garage!")
}
