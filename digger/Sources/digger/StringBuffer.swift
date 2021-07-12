
class StringBuffer {
    var x: [Character]

    init(_ x: String) {
        self.x = [Character](x)
    }

    func setCharAt(_ index: Int, _ txt: String) {
        setCharAt(index, txt[index])
    }

    func setCharAt(_ index: Int, _ letter: Int) {
        setCharAt(index, Character(UnicodeScalar(letter)!))
    }

    func setCharAt(_ index: Int, _ letter: Character) {
        x[index] = letter
    }

    func toString() -> String {
        return String(x)
    }
}
