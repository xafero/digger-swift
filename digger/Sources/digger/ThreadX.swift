import Foundation

class ThreadX {
    static func sleep(_ ms: Int) {
        let duration = Double(ms) / 1000.0
        Thread.sleep(forTimeInterval: duration)
    }
}
