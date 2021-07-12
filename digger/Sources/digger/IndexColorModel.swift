
class IndexColorModel {
    var bits: Int
    var size: Int
    var red: [UInt8]
    var green: [UInt8]
    var blue: [UInt8]

    init(_ bits: Int, _ size: Int, _ red: [UInt8], _ green: [UInt8], _ blue: [UInt8]) {
        self.bits = bits
        self.size = size
        self.red = red
        self.green = green
        self.blue = blue
    }

    func get_color(_ index: Int) -> (Double, Double, Double) {
        let red = Double(self.red[index]) / 255.0
        let green = Double(self.green[index]) / 255.0
        let blue = Double(self.blue[index]) / 255.0
        let tup = (red, green, blue)
        return tup
    }
}
