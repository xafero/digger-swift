
import Foundation

class BagData {
    var x: Int = 0

    var y: Int = 0

    var h: Int = 0

    var v: Int = 0

    var xr: Int = 0

    var yr: Int = 0

    var dir: Int = 0

    var wt: Int = 0

    var gt: Int = 0

    var fallh: Int = 0

    var wobbling: Bool = false

    var unfallen: Bool = false

    var exist: Bool = false

    func copyFrom(_ tConst: BagData) {
        var t = tConst

        x = t.x
        y = t.y
        h = t.h
        v = t.v
        xr = t.xr
        yr = t.yr
        dir = t.dir
        wt = t.wt
        gt = t.gt
        fallh = t.fallh
        wobbling = t.wobbling
        unfallen = t.unfallen
        exist = t.exist
    }
}
