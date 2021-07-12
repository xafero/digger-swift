import Foundation

extension String {
    func charAt(_ i: Int) -> Int {
        let letter = self[i]
        let asci = letter.asciiValue
        let num = Int(asci!)
        return num
    }

    subscript(_ i: Int) -> Character {
        let array = Array(self)
        let char = array[i]
        return char
    }

    static func valueOf(_ i: Int) -> String {
        let str = String(i)
        return str
    }

    func length() -> Int {
        let array = Array(self)
        return array.count
    }
}

extension Int {
    static func == (_ a: Int, _ b: String) -> Bool {
        let bb = b.charAt(0)
        return a == bb
    }
}
