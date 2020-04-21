// MARK: - Mediator Generic Class

class Mediator<ColleagueType> {
    
    // MARK: - InnerClass ColleagueWrapper
    
    private class ColleagueWrapper {
        
        var strongColleague: AnyObject?
        weak var weakColleague: AnyObject?
        
        var colleague: ColleagueType? {
            return (weakColleague ?? strongColleague) as? ColleagueType
        }
        
        init(weakColleague: ColleagueType) {
            self.strongColleague = nil
            self.weakColleague = weakColleague as AnyObject
        }
        
        init(strongColleague: ColleagueType) {
            self.weakColleague = nil
            self.strongColleague = strongColleague as AnyObject
        }
    }
    
    // MARK: - Properties
    
    private var colleagueWrappers: [ColleagueWrapper] = []
    
    var colleagues: [ColleagueType] {
        var colleagues: [ColleagueType] = []
        colleagueWrappers = colleagueWrappers.filter {
            guard let colleague = $0.colleague else { return false }
            colleagues.append(colleague)
            return true
        }
        return colleagues
    }
    
    // MARK: - Object Lifecycle
    
    init() { }
    
    // MARK: - Colleague Management
    
    func addColleague(_ colleague: ColleagueType,
                      strongReference: Bool = true) {
        
        let wrapper: ColleagueWrapper
        if strongReference {
            wrapper = ColleagueWrapper(strongColleague: colleague)
        } else {
            wrapper = ColleagueWrapper(weakColleague: colleague)
        }
        colleagueWrappers.append(wrapper)
    }
    
    func removeColleague(_ colleague: ColleagueType) {
        
        guard let index = colleagues.firstIndex(where: {
            ($0 as AnyObject) === (colleague as AnyObject)
        }) else { return }
        
        colleagueWrappers.remove(at: index)
    }
    
    func invokeColleagues(closure: (ColleagueType) -> Void) {
        colleagues.forEach(closure)
    }
    
    func invokeColleagues(by colleague: ColleagueType,
                          closure: (ColleagueType) -> Void) {
        
        colleagues.forEach {
            guard ($0 as AnyObject) !== (colleague as AnyObject) else { return }
            closure($0)
        }
    }
}


// MARK: - Colleague Protocol

protocol Colleague: class {
    func colleague(_ colleague: Colleague?,
                   didSendMessage message: String)
}


// MARK: - Mediator Protocol

protocol MediatorProtocol: class {
    func addColleague(_ colleague: Colleague)
    func sendMessage(_ message: String, by colleague: Colleague)
}


// MARK: - Colleague

class Musketeer {
    
    var name: String
    weak var mediator: MediatorProtocol?
    
    init(mediator: MediatorProtocol, name: String) {
        self.mediator = mediator
        self.name = name
        mediator.addColleague(self)
    }
    
    func sendMessage(_ message: String) {
        print("\(name) sent: \(message)")
        mediator?.sendMessage(message, by: self)
    }
}

extension Musketeer: Colleague {
    
    func colleague(_ colleague: Colleague?, didSendMessage message: String) {
        print("\(name) received: \(message)")
    }
}


// MARK: - Mediator

class MusketeerMediator: Mediator<Colleague> {
    
}

extension MusketeerMediator: MediatorProtocol {
    
    func addColleague(_ colleague: Colleague) {
        self.addColleague(colleague, strongReference: true)
    }
    
    func sendMessage(_ message: String, by colleague: Colleague) {
        invokeColleagues(by: colleague) {
            $0.colleague(colleague, didSendMessage: message)
        }
    }
}


// MARK: - Example

let mediator = MusketeerMediator()
let athos = Musketeer(mediator: mediator, name: "Athos")
let porthos = Musketeer(mediator: mediator, name: "Porthos")
let aramis = Musketeer(mediator: mediator, name: "Aramis")

athos.sendMessage("One for all...")
print("")

porthos.sendMessage("and all for one...!")
print("")

aramis.sendMessage("Unus pro omnibus, omnes pro uno!")
print("")

mediator.invokeColleagues {
    $0.colleague(nil, didSendMessage: "Charge!")
}
