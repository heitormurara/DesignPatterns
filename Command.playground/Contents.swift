import Foundation

// MARK: - Receiver

public class Door {
    var isOpen = false
}


// MARK: - Command

class DoorCommand {
    let door: Door
    
    init(_ door: Door) {
        self.door = door
    }
    
    func execute() { }
}

class OpenCommand: DoorCommand {
    
    override func execute() {
        print("Opening the door...")
        door.isOpen = true
    }
}

class CloseCommand: DoorCommand {
    
    override func execute() {
        print("Closing the door...")
        door.isOpen = false
    }
}


// MARK: - Invoker

class Doorman {
    
    let commands: [DoorCommand]
    let door: Door
    
    init(door: Door) {
        let commandCount = arc4random_uniform(10) + 1
        self.commands = (0 ..< commandCount).map { index in
            return index % 2 == 0 ? OpenCommand(door) : CloseCommand(door)
        }
        self.door = door
    }
    
    func execute() {
        print("Doorman is...")
        commands.forEach { $0.execute() }
    }
}


// MARK: - Example

let isOpen = true
print("You predict the door will be \(isOpen ? "open" : "closed")")
print("")

let door = Door()
let doorman = Doorman(door: door)
doorman.execute()
print("")

if door.isOpen == isOpen {
    print("You were right!")
} else {
    print("You were wrong!")
}
print("The door is \(door.isOpen ? "open" : "closed")")
