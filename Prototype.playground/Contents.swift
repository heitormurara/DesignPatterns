
protocol Copying : class {
    init(_ prototype: Self)
}

extension Copying {
    func copy() -> Self {
        return type(of: self).init(self)
    }
}


class Monster: Copying {
    
    var health: Int
    var level: Int
    
    init(health: Int, level: Int) {
        self.health = health
        self.level = level
    }
    
    required convenience init(_ monster: Monster) {
        self.init(health: monster.health, level: monster.level)
    }
}

class EyeballMonster: Monster {
    var redness = 0
    
    init(health: Int, level: Int, redness: Int) {
        self.redness = redness
        super.init(health: health, level: level)
    }
    
    required convenience init(_ prototype: Monster) {
        let eyeballMonster = prototype as! EyeballMonster
        self.init(health: eyeballMonster.health,
                  level: eyeballMonster.level,
                  redness: eyeballMonster.redness)
    }
}
