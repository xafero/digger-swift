import Foundation

enum System {
    static func currentTimeMillis() -> Int {
        let nowDouble = NSDate().timeIntervalSince1970
        return Int(nowDouble * 1000)
    }
}
