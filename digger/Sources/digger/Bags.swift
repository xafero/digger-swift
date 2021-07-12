
import Foundation

class Bags {
    var dig: Digger

    var bagdat1: [_bag] = [_bag(), _bag(), _bag(), _bag(), _bag(), _bag(), _bag(), _bag()]

    var bagdat2: [_bag] = [_bag(), _bag(), _bag(), _bag(), _bag(), _bag(), _bag(), _bag()]

    var bagdat: [_bag] = [_bag(), _bag(), _bag(), _bag(), _bag(), _bag(), _bag(), _bag()]

    var pushcount: Int = 0

    var goldtime: Int = 0

    var wblanim: [Int] = [2, 0, 1, 0]

    init(_ dConst: Digger) {
        var d = dConst

        dig = d
    }

    func bagbits() -> Int {
        var bag: Int = 0
        var b: Int = 0
        var bags: Int = 0

        bag = 1
        b = 2
        while bag < 8 {
            if bagdat[bag].exist {
                bags |= b
            }

            bag += 1
            b <<= 1
        }

        return bags
    }

    func baghitground(_ bagConst: Int) {
        var bag = bagConst

        var bn: Int = 0
        var b: Int = 0
        var clbits: Int = 0

        if bagdat[bag].dir == 6, bagdat[bag].fallh > 1 {
            bagdat[bag].gt = 1
        } else {
            bagdat[bag].fallh = 0
        }

        bagdat[bag].dir = -1
        bagdat[bag].wt = 15
        bagdat[bag].wobbling = false
        clbits = dig.Drawing!.drawgold(bag, 0, bagdat[bag].x, bagdat[bag].y)
        dig.Main!.incpenalty()
        bn = 1
        b = 2
        while bn < 8 {
            if (b & clbits) != 0 {
                removebag(bn)
            }

            bn += 1
            b <<= 1
        }
    }

    func bagy(_ bagConst: Int) -> Int {
        var bag = bagConst

        return bagdat[bag].y
    }

    func cleanupbags() {
        var bpa: Int = 0

        dig.Sound!.soundfalloff()
        bpa = 1
        while bpa < 8 {
            if bagdat[bpa].exist, (bagdat[bpa].h == 7 && bagdat[bpa].v == 9) || bagdat[bpa].xr != 0 || bagdat[bpa].yr != 0 || bagdat[bpa].gt != 0 || bagdat[bpa].fallh != 0 || bagdat[bpa].wobbling
            {
                bagdat[bpa].exist = false
                dig.Sprite!.erasespr(bpa)
            }

            if dig.Main!.getcplayer() == 0 {
                bagdat1[bpa].copyFrom(bagdat[bpa])
            } else {
                bagdat2[bpa].copyFrom(bagdat[bpa])
            }

            bpa += 1
        }
    }

    func dobags() {
        var bag: Int = 0

        var soundfalloffflag: Bool = true
        var soundwobbleoffflag: Bool = true

        bag = 1
        while bag < 8 {
            if bagdat[bag].exist {
                if bagdat[bag].gt != 0 {
                    if bagdat[bag].gt == 1 {
                        dig.Sound!.soundbreak()
                        dig.Drawing!.drawgold(bag, 4, bagdat[bag].x, bagdat[bag].y)
                        dig.Main!.incpenalty()
                    }

                    if bagdat[bag].gt == 3 {
                        dig.Drawing!.drawgold(bag, 5, bagdat[bag].x, bagdat[bag].y)
                        dig.Main!.incpenalty()
                    }

                    if bagdat[bag].gt == 5 {
                        dig.Drawing!.drawgold(bag, 6, bagdat[bag].x, bagdat[bag].y)
                        dig.Main!.incpenalty()
                    }

                    bagdat[bag].gt += 1
                    if bagdat[bag].gt == goldtime {
                        removebag(bag)
                    } else if bagdat[bag].v < 9, bagdat[bag].gt < goldtime - 10 {
                        if (dig.Monster!.getfield(bagdat[bag].h, bagdat[bag].v + 1) & 0x2000) == 0 {
                            bagdat[bag].gt = goldtime - 10
                        }
                    }
                } else {
                    updatebag(bag)
                }
            }

            bag += 1
        }

        bag = 1
        while bag < 8 {
            if bagdat[bag].dir == 6, bagdat[bag].exist {
                soundfalloffflag = false
            }

            if bagdat[bag].dir != 6, bagdat[bag].wobbling, bagdat[bag].exist {
                soundwobbleoffflag = false
            }

            bag += 1
        }

        if soundfalloffflag {
            dig.Sound!.soundfalloff()
        }

        if soundwobbleoffflag {
            dig.Sound!.soundwobbleoff()
        }
    }

    func drawbags() {
        var bag: Int = 0

        bag = 1
        while bag < 8 {
            if dig.Main!.getcplayer() == 0 {
                bagdat[bag].copyFrom(bagdat1[bag])
            } else {
                bagdat[bag].copyFrom(bagdat2[bag])
            }

            if bagdat[bag].exist {
                dig.Sprite!.movedrawspr(bag, bagdat[bag].x, bagdat[bag].y)
            }

            bag += 1
        }
    }

    func getbagdir(_ bagConst: Int) -> Int {
        var bag = bagConst

        if bagdat[bag].exist {
            return bagdat[bag].dir
        }

        return -1
    }

    func getgold(_ bagConst: Int) {
        var bag = bagConst

        var clbits: Int = 0

        clbits = dig.Drawing!.drawgold(bag, 6, bagdat[bag].x, bagdat[bag].y)
        dig.Main!.incpenalty()
        if (clbits & 1) != 0 {
            dig.Scores!.scoregold()
            dig.Sound!.soundgold()
            dig.digtime = 0
        } else {
            dig.Monster!.mongold()
        }

        removebag(bag)
    }

    func getnmovingbags() -> Int {
        var bag: Int = 0
        var n: Int = 0

        bag = 1
        while bag < 8 {
            if bagdat[bag].exist, bagdat[bag].gt < 10, bagdat[bag].gt != 0 || bagdat[bag].wobbling {
                n += 1
            }

            bag += 1
        }

        return n
    }

    func initbags() {
        var bag: Int = 0
        var x: Int = 0
        var y: Int = 0

        pushcount = 0
        goldtime = 150 - dig.Main!.levof10() * 10
        bag = 1
        while bag < 8 {
            bagdat[bag].exist = false
            bag += 1
        }

        bag = 1
        x = 0
        while x < 15 {
            y = 0
            while y < 10 {
                if dig.Main!.getlevch(x, y, dig.Main!.levplan()) == "B" {
                    if bag < 8 {
                        bagdat[bag].exist = true
                        bagdat[bag].gt = 0
                        bagdat[bag].fallh = 0
                        bagdat[bag].dir = -1
                        bagdat[bag].wobbling = false
                        bagdat[bag].wt = 15
                        bagdat[bag].unfallen = true
                        bagdat[bag].x = x * 20 + 12
                        bagdat[bag].y = y * 18 + 18
                        bagdat[bag].h = x
                        bagdat[bag].v = y
                        bagdat[bag].xr = 0
                        bagdat[bag].yr = 0
                        bag += 1
                    }
                }

                y += 1
            }

            x += 1
        }

        if dig.Main!.getcplayer() == 0 {
            var i: Int = 1

            while i < 8 {
                bagdat1[i].copyFrom(bagdat[i])
                i += 1
            }
        } else {
            var i: Int = 1

            while i < 8 {
                bagdat2[i].copyFrom(bagdat[i])
                i += 1
            }
        }
    }

    func pushbag(_ bagConst: Int, _ dirConst: Int) -> Bool {
        var bag = bagConst
        var dir = dirConst

        var x: Int = 0
        var y: Int = 0
        var h: Int = 0
        var v: Int = 0
        var ox: Int = 0
        var oy: Int = 0
        var clbits: Int = 0

        var push: Bool = true

        ox = bagdat[bag].x; x = bagdat[bag].x
        oy = bagdat[bag].y; y = bagdat[bag].y
        h = bagdat[bag].h
        v = bagdat[bag].v
        if bagdat[bag].gt != 0 {
            getgold(bag)
            return true
        }

        if bagdat[bag].dir == 6 && (dir == 4 || dir == 0) {
            clbits = dig.Drawing!.drawgold(bag, 3, x, y)
            dig.Main!.incpenalty()
            if (clbits & 1) != 0, dig.diggery >= y {
                dig.killdigger(1, bag)
            }

            if (clbits & 0x3F00) != 0 {
                dig.Monster!.squashmonsters(bag, clbits)
            }

            return true
        }

        if (x == 292 && dir == 0) || (x == 12 && dir == 4) || (y == 180 && dir == 6) || (y == 18 && dir == 2)
        {
            push = false
        }

        if push {
            switch dir {
            case 0:
                x += 4
            case 4:
                x -= 4
            case 6:
                if bagdat[bag].unfallen {
                    bagdat[bag].unfallen = false
                    dig.Drawing!.drawsquareblob(x, y)
                    dig.Drawing!.drawtopblob(x, y + 21)
                } else {
                    dig.Drawing!.drawfurryblob(x, y)
                }

                dig.Drawing!.eatfield(x, y, dir)
                dig.killemerald(h, v)
                y += 6
            default:
                break
            }

            switch dir {
            case 6:
                clbits = dig.Drawing!.drawgold(bag, 3, x, y)
                dig.Main!.incpenalty()
                if (clbits & 1) != 0, dig.diggery >= y {
                    dig.killdigger(1, bag)
                }

                if (clbits & 0x3F00) != 0 {
                    dig.Monster!.squashmonsters(bag, clbits)
                }

            case 0, 4:
                bagdat[bag].wt = 15
                bagdat[bag].wobbling = false
                clbits = dig.Drawing!.drawgold(bag, 0, x, y)
                dig.Main!.incpenalty()
                pushcount = 1
                if (clbits & 0xFE) != 0 {
                    if !pushbags(dir, clbits) {
                        x = ox
                        y = oy
                        dig.Drawing!.drawgold(bag, 0, ox, oy)
                        dig.Main!.incpenalty()
                        push = false
                    }
                }

                if ((clbits & 1) != 0) || ((clbits & 0x3F00) != 0) {
                    x = ox
                    y = oy
                    dig.Drawing!.drawgold(bag, 0, ox, oy)
                    dig.Main!.incpenalty()
                    push = false
                }

            default:
                break
            }

            if push {
                bagdat[bag].dir = dir
            } else {
                bagdat[bag].dir = dig.reversedir(dir)
            }

            bagdat[bag].x = x
            bagdat[bag].y = y
            bagdat[bag].h = (x - 12) / 20
            bagdat[bag].v = (y - 18) / 18
            bagdat[bag].xr = (x - 12) % 20
            bagdat[bag].yr = (y - 18) % 18
        }

        return push
    }

    func pushbags(_ dirConst: Int, _ bitsConst: Int) -> Bool {
        var dir = dirConst
        var bits = bitsConst

        var bag: Int = 0
        var bit: Int = 0

        var push: Bool = true

        bag = 1
        bit = 2
        while bag < 8 {
            if (bits & bit) != 0 {
                if !pushbag(bag, dir) {
                    push = false
                }
            }

            bag += 1
            bit <<= 1
        }

        return push
    }

    func pushudbags(_ bitsConst: Int) -> Bool {
        var bits = bitsConst

        var bag: Int = 0
        var b: Int = 0

        var push: Bool = true

        bag = 1
        b = 2
        while bag < 8 {
            if (bits & b) != 0 {
                if bagdat[bag].gt != 0 {
                    getgold(bag)
                } else {
                    push = false
                }
            }

            bag += 1
            b <<= 1
        }

        return push
    }

    func removebag(_ bagConst: Int) {
        var bag = bagConst

        if bagdat[bag].exist {
            bagdat[bag].exist = false
            dig.Sprite!.erasespr(bag)
        }
    }

    func removebags(_ bitsConst: Int) {
        var bits = bitsConst

        var bag: Int = 0
        var b: Int = 0

        bag = 1
        b = 2
        while bag < 8 {
            if bagdat[bag].exist, (bits & b) != 0 {
                removebag(bag)
            }

            bag += 1
            b <<= 1
        }
    }

    func updatebag(_ bagConst: Int) {
        var bag = bagConst

        var x: Int = 0
        var h: Int = 0
        var xr: Int = 0
        var y: Int = 0
        var v: Int = 0
        var yr: Int = 0
        var wbl: Int = 0

        x = bagdat[bag].x
        h = bagdat[bag].h
        xr = bagdat[bag].xr
        y = bagdat[bag].y
        v = bagdat[bag].v
        yr = bagdat[bag].yr
        switch bagdat[bag].dir {
        case -1:
            if y < 180, xr == 0 {
                if bagdat[bag].wobbling {
                    if bagdat[bag].wt == 0 {
                        bagdat[bag].dir = 6
                        dig.Sound!.soundfall()
                        break
                    }

                    bagdat[bag].wt -= 1
                    wbl = bagdat[bag].wt % 8
                    if !((wbl & 1) != 0) {
                        dig.Drawing!.drawgold(bag, wblanim[wbl >> 1], x, y)
                        dig.Main!.incpenalty()
                        dig.Sound!.soundwobble()
                    }
                } else if (dig.Monster!.getfield(h, v + 1) & 0xFDF) != 0xFDF {
                    if !dig.checkdiggerunderbag(h, v + 1) {
                        bagdat[bag].wobbling = true
                    }
                }
            } else {
                bagdat[bag].wt = 15
                bagdat[bag].wobbling = false
            }

        case 0, 4:
            if xr == 0 {
                if y < 180, (dig.Monster!.getfield(h, v + 1) & 0xFDF) != 0xFDF {
                    bagdat[bag].dir = 6
                    bagdat[bag].wt = 0
                    dig.Sound!.soundfall()
                } else {
                    baghitground(bag)
                }
            }

        case 6:
            if yr == 0 {
                bagdat[bag].fallh += 1
            }

            if y >= 180 {
                baghitground(bag)
            } else if (dig.Monster!.getfield(h, v + 1) & 0xFDF) == 0xFDF {
                if yr == 0 {
                    baghitground(bag)
                }
            }

            dig.Monster!.checkmonscared(bagdat[bag].h)
        default:
            break
        }

        if bagdat[bag].dir != -1 {
            if bagdat[bag].dir != 6, pushcount != 0 {
                pushcount -= 1
            } else {
                pushbag(bag, bagdat[bag].dir)
            }
        }
    }
}
