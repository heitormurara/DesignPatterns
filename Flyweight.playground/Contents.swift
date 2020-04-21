/// Use flyweight where you would use a Singleton, but you need multiple shared instances with different configurations.

import UIKit

let red = UIColor.red
let red2 = UIColor.red
print("UIColor's Flyweight equality: \(red === red2)")

let color = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
let color2 = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
print("UIColor's custom colors equality: \(color === color2)")


extension UIColor {
    
    public static var colorStore: [String: UIColor] = [:]
    
    public class func rgba(_ red: CGFloat,
                           _ green: CGFloat,
                           _ blue: CGFloat,
                           _ alpha: CGFloat) -> UIColor {
        let key = "\(red)\(green)\(blue)\(alpha)"
        if let color = colorStore[key] {
            return color
        }
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        colorStore[key] = color
        return color
    }
}


let flyColor = UIColor.rgba(1, 0, 0, 1)
let flyColor2 = UIColor.rgba(1, 0, 0, 1)
print("Flyweight Colors equality: \(flyColor === flyColor2)")
