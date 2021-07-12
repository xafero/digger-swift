
import Foundation

class Pc {
    var dig: Digger

    var source: [GtkRefresher] = [GtkRefresher(), GtkRefresher()]

    var currentSource = GtkRefresher()

    var width: Int = 320

    var height: Int = 200

    var size: Int { return width * height }

    var pixels: [Int] = []

    var pal: [[[UInt8]]] = [[[0, 0x00, 0xAA, 0xAA], [0, 0xAA, 0x00, 0x54], [0, 0x00, 0x00, 0x00]], [[0, 0x54, 0xFF, 0xFF], [0, 0xFF, 0x54, 0xFF], [0, 0x54, 0x54, 0x54]]]

    init(_ dConst: Digger) {
        var d = dConst

        dig = d
    }

    func gclear() {
        var i: Int = 0

        while i < size {
            pixels[i] = 0
            i += 1
        }

        currentSource.newPixels()
    }

    func gethrt() -> Int {
        return System.currentTimeMillis()
    }

    func getkips() -> Int {
        return 0
    }

    func ggeti(_ xConst: Int, _ yConst: Int, _ pConst: [Int16], _ wConst: Int, _ hConst: Int) {
        var x = xConst
        var y = yConst
        var p = pConst
        var w = wConst
        var h = hConst

        var src: Int = 0

        var dest: Int = y * width + (x & 0xFFFC)

        var i: Int = 0

        while i < h {
            var d: Int = dest

            var j: Int = 0

            while j < w {
                let pVal = ((((((pixels[d] << 2) | pixels[d + 1]) << 2)
                        | pixels[d + 2]) << 2) | pixels[d + 3])
                p[src] = Int16(pVal)
                src += 1
                d += 4
                if src == p.count {
                    return
                }

                j += 1
            }

            dest += width

            i += 1
        }
    }

    func ggetpix(_ xConst: Int, _ yConst: Int) -> Int {
        var x = xConst
        var y = yConst

        var ofs: Int = width * y + x & 0xFFFC

        return (((((pixels[ofs] << 2) | pixels[ofs + 1]) << 2) | pixels[ofs + 2]) << 2) | pixels[ofs + 3]
    }

    func ginit() {}

    func ginten(_ intenConst: Int) {
        var inten = intenConst

        currentSource = source[inten & 1]
        currentSource.newPixels()
    }

    func gpal(_ palConst: Int) {
        var pal = palConst
    }

    func gputi(_ xConst: Int, _ yConst: Int, _ pConst: [Int16], _ wConst: Int, _ hConst: Int) {
        var x = xConst
        var y = yConst
        var p = pConst
        var w = wConst
        var h = hConst

        gputi(x, y, p, w, h, true)
    }

    func gputi(_ xConst: Int, _ yConst: Int, _ pConst: [Int16], _ wConst: Int, _ hConst: Int, _ bConst: Bool)
    {
        var x = xConst
        var y = yConst
        var p = pConst
        var w = wConst
        var h = hConst
        var b = bConst

        var src: Int = 0

        var dest: Int = y * width + (x & 0xFFFC)

        var i: Int = 0

        while i < h {
            var d: Int = dest

            var j: Int = 0

            while j < w {
                var px: Int16 = p[src]
                src += 1

                pixels[d + 3] = Int(px & 3)
                px >>= 2
                pixels[d + 2] = Int(px & 3)
                px >>= 2
                pixels[d + 1] = Int(px & 3)
                px >>= 2
                pixels[d] = Int(px & 3)
                d += 4
                if src == p.count {
                    return
                }

                j += 1
            }

            dest += width

            i += 1
        }
    }

    func gputim(_ xConst: Int, _ yConst: Int, _ chConst: Int, _ wConst: Int, _ hConst: Int) {
        var x = xConst
        var y = yConst
        var ch = chConst
        var w = wConst
        var h = hConst

        var spr: [Int16] = CgaGrafx.cgatable[ch * 2]

        var msk: [Int16] = CgaGrafx.cgatable[ch * 2 + 1]

        var src: Int = 0

        var dest: Int = y * width + (x & 0xFFFC)

        var i: Int = 0

        while i < h {
            var d: Int = dest

            var j: Int = 0

            while j < w {
                var px: Int16 = spr[src]

                var mx: Int16 = msk[src]

                src += 1
                if (mx & 3) == 0 {
                    pixels[d + 3] = Int(px & 3)
                }

                px >>= 2
                if (mx & (3 << 2)) == 0 {
                    pixels[d + 2] = Int(px & 3)
                }

                px >>= 2
                if (mx & (3 << 4)) == 0 {
                    pixels[d + 1] = Int(px & 3)
                }

                px >>= 2
                if (mx & (3 << 6)) == 0 {
                    pixels[d] = Int(px & 3)
                }

                d += 4
                if src == spr.count || src == msk.count {
                    return
                }

                j += 1
            }

            dest += width

            i += 1
        }
    }

    func gtitle() {
        var src: Int = 0
        var dest: Int = 0
        var plus: Int = 0

        while true {
            if src >= CgaGrafx.cgatitledat.count {
                break
            }

            var b = Int(CgaGrafx.cgatitledat[src])
            src += 1
            var l: Int = 0
            var c: Int = 0

            if b == 0xFE {
                l = Int(CgaGrafx.cgatitledat[src])
                src += 1
                if l == 0 {
                    l = 256
                }

                c = Int(CgaGrafx.cgatitledat[src])
                src += 1
            } else {
                l = 1
                c = b
            }

            var i: Int = 0

            while i < l {
                var px: Int = c
                var adst: Int = 0

                if dest < 32768 {
                    adst = (dest / 320) * 640 + dest % 320
                } else {
                    adst = 320 + ((dest - 32768) / 320) * 640 + (dest - 32768) % 320
                }

                pixels[adst + 3] = px & 3
                px >>= 2
                pixels[adst + 2] = px & 3
                px >>= 2
                pixels[adst + 1] = px & 3
                px >>= 2
                pixels[adst + 0] = px & 3
                dest += 4
                if dest >= 65535 {
                    break
                }

                i += 1
            }

            if dest >= 65535 {
                break
            }
        }
    }

    func gwrite(_ xConst: Int, _ yConst: Int, _ chConst: Int, _ cConst: Int) {
        var x = xConst
        var y = yConst
        var ch = chConst
        var c = cConst

        gwrite(x, y, ch, c, false)
    }

    func gwrite(_ xConst: Int, _ yConst: Int, _ chConst: Int, _ cConst: Int, _ updConst: Bool) {
        var x = xConst
        var y = yConst
        var ch = chConst
        var c = cConst
        var upd = updConst

        var dest: Int = x + y * width
        var ofs: Int = 0
        var color: Int = c & 3

        ch -= 32
        if (ch < 0) || (ch > 0x5F) {
            return
        }

        var chartab: [Int16] = Alpha.ascii2cga[ch]!

        if chartab == nil {
            return
        }

        var i: Int = 0

        while i < 12 {
            var d: Int = dest

            var j: Int = 0

            while j < 3 {
                var px = Int(chartab[ofs])
                ofs += 1

                pixels[d + 3] = px & color
                px >>= 2
                pixels[d + 2] = px & color
                px >>= 2
                pixels[d + 1] = px & color
                px >>= 2
                pixels[d] = px & color
                d += 4

                j += 1
            }

            dest += width

            i += 1
        }

        if upd {
            currentSource.newPixels(x, y, 12, 12)
        }
    }
}
