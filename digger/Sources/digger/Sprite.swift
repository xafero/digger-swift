
import Foundation

class Sprite {
    var dig: Digger

    var retrflag: Bool = true

    var sprrdrwf: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]

    var sprrecf: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]

    var sprenf: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]

    var sprch: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    var sprmov: [[Int16]?] = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]

    var sprx: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    var spry: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    var sprwid: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    var sprhei: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    var sprbwid: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    var sprbhei: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    var sprnch: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    var sprnwid: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    var sprnhei: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    var sprnbwid: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    var sprnbhei: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    var defsprorder: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]

    var sprorder: [Int] = []

    init(_ dConst: Digger) {
        var d = dConst

        dig = d
        sprorder = defsprorder
    }

    func bcollide(_ bxConst: Int, _ siConst: Int) -> Bool {
        var bx = bxConst
        var si = siConst

        if sprx[bx] >= sprx[si] {
            if sprx[bx] + sprbwid[bx] > sprwid[si] * 4 + sprx[si] - sprbwid[si] - 1 {
                return false
            }
        } else if sprx[si] + sprbwid[si] > sprwid[bx] * 4 + sprx[bx] - sprbwid[bx] - 1 {
            return false
        }

        if spry[bx] >= spry[si] {
            if spry[bx] + sprbhei[bx] <= sprhei[si] + spry[si] - sprbhei[si] - 1 {
                return true
            }

            return false
        }

        if spry[si] + sprbhei[si] <= sprhei[bx] + spry[bx] - sprbhei[bx] - 1 {
            return true
        }

        return false
    }

    func bcollides(_ bxConst: Int) -> Int {
        var bx = bxConst

        var si: Int = bx
        var ax: Int = 0
        var dx: Int = 0

        bx = 0
        repeat {
            if sprenf[bx], bx != si {
                if bcollide(bx, si) {
                    ax |= 1 << dx
                }

                sprx[bx] += 320
                spry[bx] -= 2
                if bcollide(bx, si) {
                    ax |= 1 << dx
                }

                sprx[bx] -= 640
                spry[bx] += 4
                if bcollide(bx, si) {
                    ax |= 1 << dx
                }

                sprx[bx] += 320
                spry[bx] -= 2
            }

            bx += 1
            dx += 1

        } while dx != 16

        return ax
    }

    func clearrdrwf() {
        var i: Int = 0

        clearrecf()
        i = 0
        while i < 17 {
            sprrdrwf[i] = false
            i += 1
        }
    }

    func clearrecf() {
        var i: Int = 0

        i = 0
        while i < 17 {
            sprrecf[i] = false
            i += 1
        }
    }

    func collide(_ bxConst: Int, _ siConst: Int) -> Bool {
        var bx = bxConst
        var si = siConst

        if sprx[bx] >= sprx[si] {
            if sprx[bx] > sprwid[si] * 4 + sprx[si] - 1 {
                return false
            }
        } else if sprx[si] > sprwid[bx] * 4 + sprx[bx] - 1 {
            return false
        }

        if spry[bx] >= spry[si] {
            if spry[bx] <= sprhei[si] + spry[si] - 1 {
                return true
            }

            return false
        }

        if spry[si] <= sprhei[bx] + spry[bx] - 1 {
            return true
        }

        return false
    }

    func createspr(_ nConst: Int, _ chConst: Int, _ movConst: [Int16], _ widConst: Int, _ heiConst: Int, _ bwidConst: Int, _ bheiConst: Int)
    {
        var n = nConst
        var ch = chConst
        var mov = movConst
        var wid = widConst
        var hei = heiConst
        var bwid = bwidConst
        var bhei = bheiConst

        sprnch[n & 15] = ch; sprch[n & 15] = ch
        sprmov[n & 15] = mov
        sprnwid[n & 15] = wid; sprwid[n & 15] = wid
        sprnhei[n & 15] = hei; sprhei[n & 15] = hei
        sprnbwid[n & 15] = bwid; sprbwid[n & 15] = bwid
        sprnbhei[n & 15] = bhei; sprbhei[n & 15] = bhei
        sprenf[n & 15] = false
    }

    func drawmiscspr(_ xConst: Int, _ yConst: Int, _ chConst: Int, _ widConst: Int, _ heiConst: Int)
    {
        var x = xConst
        var y = yConst
        var ch = chConst
        var wid = widConst
        var hei = heiConst

        sprx[16] = x & -4
        spry[16] = y
        sprch[16] = ch
        sprwid[16] = wid
        sprhei[16] = hei
        dig.Pc!.gputim(sprx[16], spry[16], sprch[16], sprwid[16], sprhei[16])
    }

    func drawspr(_ nConst: Int, _ xConst: Int, _ yConst: Int) -> Int {
        var n = nConst
        var x = xConst
        var y = yConst

        var bx: Int = 0
        var t1: Int = 0
        var t2: Int = 0
        var t3: Int = 0
        var t4: Int = 0

        bx = n & 15
        x &= -4
        clearrdrwf()
        setrdrwflgs(bx)
        t1 = sprx[bx]
        t2 = spry[bx]
        t3 = sprwid[bx]
        t4 = sprhei[bx]
        sprx[bx] = x
        spry[bx] = y
        sprwid[bx] = sprnwid[bx]
        sprhei[bx] = sprnhei[bx]
        clearrecf()
        setrdrwflgs(bx)
        sprhei[bx] = t4
        sprwid[bx] = t3
        spry[bx] = t2
        sprx[bx] = t1
        sprrdrwf[bx] = true
        putis()
        sprx[bx] = x
        spry[bx] = y
        sprch[bx] = sprnch[bx]
        sprwid[bx] = sprnwid[bx]
        sprhei[bx] = sprnhei[bx]
        sprbwid[bx] = sprnbwid[bx]
        sprbhei[bx] = sprnbhei[bx]
        dig.Pc!.ggeti(sprx[bx], spry[bx], sprmov[bx]!, sprwid[bx], sprhei[bx])
        putims()
        return bcollides(bx)
    }

    func erasespr(_ nConst: Int) {
        var n = nConst

        var bx: Int = n & 15

        dig.Pc!.gputi(sprx[bx], spry[bx], sprmov[bx]!, sprwid[bx], sprhei[bx], true)
        sprenf[bx] = false
        clearrdrwf()
        setrdrwflgs(bx)
        putims()
    }

    func getis() {
        var i: Int = 0

        i = 0
        while i < 16 {
            if sprrdrwf[i] {
                dig.Pc!.ggeti(sprx[i], spry[i], sprmov[i]!, sprwid[i], sprhei[i])
            }

            i += 1
        }

        putims()
    }

    func initmiscspr(_ xConst: Int, _ yConst: Int, _ widConst: Int, _ heiConst: Int) {
        var x = xConst
        var y = yConst
        var wid = widConst
        var hei = heiConst

        sprx[16] = x
        spry[16] = y
        sprwid[16] = wid
        sprhei[16] = hei
        clearrdrwf()
        setrdrwflgs(16)
        putis()
    }

    func initspr(_ nConst: Int, _ chConst: Int, _ widConst: Int, _ heiConst: Int, _ bwidConst: Int, _ bheiConst: Int)
    {
        var n = nConst
        var ch = chConst
        var wid = widConst
        var hei = heiConst
        var bwid = bwidConst
        var bhei = bheiConst

        sprnch[n & 15] = ch
        sprnwid[n & 15] = wid
        sprnhei[n & 15] = hei
        sprnbwid[n & 15] = bwid
        sprnbhei[n & 15] = bhei
    }

    func movedrawspr(_ nConst: Int, _ xConst: Int, _ yConst: Int) -> Int {
        var n = nConst
        var x = xConst
        var y = yConst

        var bx: Int = n & 15

        sprx[bx] = x & -4
        spry[bx] = y
        sprch[bx] = sprnch[bx]
        sprwid[bx] = sprnwid[bx]
        sprhei[bx] = sprnhei[bx]
        sprbwid[bx] = sprnbwid[bx]
        sprbhei[bx] = sprnbhei[bx]
        clearrdrwf()
        setrdrwflgs(bx)
        putis()
        let sprm = sprmov[bx]!
        dig.Pc!.ggeti(sprx[bx], spry[bx], sprm, sprwid[bx], sprhei[bx])
        sprenf[bx] = true
        sprrdrwf[bx] = true
        putims()
        return bcollides(bx)
    }

    func putims() {
        var i: Int = 0
        var j: Int = 0

        i = 0
        while i < 16 {
            j = sprorder[i]
            if sprrdrwf[j] {
                dig.Pc!.gputim(sprx[j], spry[j], sprch[j], sprwid[j], sprhei[j])
            }

            i += 1
        }
    }

    func putis() {
        var i: Int = 0

        i = 0
        while i < 16 {
            if sprrdrwf[i] {
                dig.Pc!.gputi(sprx[i], spry[i], sprmov[i]!, sprwid[i], sprhei[i])
            }

            i += 1
        }
    }

    func setrdrwflgs(_ nConst: Int) {
        var n = nConst

        var i: Int = 0

        if !sprrecf[n] {
            sprrecf[n] = true
            i = 0
            while i < 16 {
                if sprenf[i], i != n {
                    if collide(i, n) {
                        sprrdrwf[i] = true
                        setrdrwflgs(i)
                    }

                    sprx[i] += 320
                    spry[i] -= 2
                    if collide(i, n) {
                        sprrdrwf[i] = true
                        setrdrwflgs(i)
                    }

                    sprx[i] -= 640
                    spry[i] += 4
                    if collide(i, n) {
                        sprrdrwf[i] = true
                        setrdrwflgs(i)
                    }

                    sprx[i] += 320
                    spry[i] -= 2
                }

                i += 1
            }
        }
    }

    func setretr(_ fConst: Bool) {
        var f = fConst

        retrflag = f
    }

    func setsprorder(_ newsprorderConst: [Int]) {
        var newsprorder = newsprorderConst

        if newsprorder == nil {
            sprorder = defsprorder
        } else {
            sprorder = newsprorder
        }
    }
}
