
import Foundation

class Digger {
    static var MAX_RATE: Int = 200

    static var MIN_RATE: Int = 40

    var width: Int = 320

    var height: Int = 200

    var frametime: Int = 66

    var gamethread: Thread?

    var pgtk: GtkDigger?

    var subaddr: String = ""

    var pic: Image?

    var picg: Graphics?

    var Bags: Bags?

    var Main: Main?

    var Sound: Sound?

    var Monster: Monster?

    var Scores: Scores?

    var Sprite: Sprite?

    var Drawing: Drawing?

    var Input: Input?

    var Pc: Pc?

    var diggerx: Int = 0

    var diggery: Int = 0

    var diggerh: Int = 0

    var diggerv: Int = 0

    var diggerrx: Int = 0

    var diggerry: Int = 0

    var digmdir: Int = 0

    var digdir: Int = 0

    var digtime: Int = 0

    var rechargetime: Int = 0

    var firex: Int = 0

    var firey: Int = 0

    var firedir: Int = 0

    var expsn: Int = 0

    var deathstage: Int = 0

    var deathbag: Int = 0

    var deathani: Int = 0

    var deathtime: Int = 0

    var startbonustimeleft: Int = 0

    var bonustimeleft: Int = 0

    var eatmsc: Int = 0

    var emocttime: Int = 0

    var emmask: UInt8 = 0

    var emfield: [UInt8] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    var digonscr: Bool = false

    var notfiring: Bool = false

    var bonusvisible: Bool = false

    var bonusmode: Bool = false

    var diggervisible: Bool = false

    var time: Int = 0

    var ftime: Int = 50

    var embox: [Int] = [8, 12, 12, 9, 16, 12, 6, 9]

    var deatharc: [Int] = [3, 5, 6, 6, 5, 3, 0]

    init(_ pgtk: GtkDigger?) {
        Bags = digger.Bags(self)
        Main = digger.Main(self)
        Sound = digger.Sound(self)
        Monster = digger.Monster(self)
        Scores = digger.Scores(self)
        Sprite = digger.Sprite(self)
        Drawing = digger.Drawing(self)
        Input = digger.Input(self)
        Pc = digger.Pc(self)

        self.pgtk = pgtk
    }

    func checkdiggerunderbag(_ hConst: Int, _ vConst: Int) -> Bool {
        var h = hConst
        var v = vConst

        if digmdir == 2 || digmdir == 6 {
            if (diggerx - 12) / 20 == h {
                if (diggery - 18) / 18 == v || (diggery - 18) / 18 + 1 == v {
                    return true
                }
            }
        }

        return false
    }

    func countem() -> Int {
        var x: Int = 0
        var y: Int = 0
        var n: Int = 0

        x = 0
        while x < 15 {
            y = 0
            while y < 10 {
                if (emfield[y * 15 + x] & emmask) != 0 {
                    n += 1
                }

                y += 1
            }

            x += 1
        }

        return n
    }

    func createbonus() {
        bonusvisible = true
        Drawing!.drawbonus(292, 18)
    }

    func destroy() {
        if gamethread != nil {
            gamethread!.cancel()
        }
    }

    func diggerdie() {
        var clbits: Int = 0

        switch deathstage {
        case 1:
            if Bags!.bagy(deathbag) + 6 > diggery {
                diggery = Bags!.bagy(deathbag) + 6
            }

            Drawing!.drawdigger(15, diggerx, diggery, false)
            Main!.incpenalty()
            if Bags!.getbagdir(deathbag) + 1 == 0 {
                Sound!.soundddie()
                deathtime = 5
                deathstage = 2
                deathani = 0
                diggery -= 6
            }

        case 2:
            if deathtime != 0 {
                deathtime -= 1
                break
            }

            if deathani == 0 {
                Sound!.music(2)
            }

            clbits = Drawing!.drawdigger(14 - deathani, diggerx, diggery, false)
            Main!.incpenalty()
            if deathani == 0 && ((clbits & 0x3F00) != 0) {
                Monster!.killmonsters(clbits)
            }

            if deathani < 4 {
                deathani += 1
                deathtime = 2
            } else {
                deathstage = 4
                if Sound!.musicflag {
                    deathtime = 60
                } else {
                    deathtime = 10
                }
            }

        case 3:
            deathstage = 5
            deathani = 0
            deathtime = 0
        case 5:
            if deathani >= 0 && deathani <= 6 {
                Drawing!.drawdigger(15, diggerx, diggery - deatharc[deathani], false)
                if deathani == 6 {
                    Sound!.musicoff()
                }

                Main!.incpenalty()
                deathani += 1
                if deathani == 1 {
                    Sound!.soundddie()
                }

                if deathani == 7 {
                    deathtime = 5
                    deathani = 0
                    deathstage = 2
                }
            }

        case 4:
            if deathtime != 0 {
                deathtime -= 1
            } else {
                Main!.setdead(true)
            }

        default:
            break
        }
    }

    func dodigger() {
        newframe()
        if expsn != 0 {
            drawexplosion()
        } else {
            updatefire()
        }

        if diggervisible {
            if digonscr {
                if digtime != 0 {
                    Drawing!.drawdigger(digmdir, diggerx, diggery, notfiring && rechargetime == 0)
                    Main!.incpenalty()
                    digtime -= 1
                } else {
                    updatedigger()
                }
            } else {
                diggerdie()
            }
        }

        if bonusmode, digonscr {
            if bonustimeleft != 0 {
                bonustimeleft -= 1
                if startbonustimeleft != 0 || bonustimeleft < 20 {
                    startbonustimeleft -= 1
                    if (bonustimeleft & 1) != 0 {
                        Pc!.ginten(0)
                        Sound!.soundbonus()
                    } else {
                        Pc!.ginten(1)
                        Sound!.soundbonus()
                    }

                    if startbonustimeleft == 0 {
                        Sound!.music(0)
                        Sound!.soundbonusoff()
                        Pc!.ginten(1)
                    }
                }
            } else {
                endbonusmode()
                Sound!.soundbonusoff()
                Sound!.music(1)
            }
        }

        if bonusmode, !digonscr {
            endbonusmode()
            Sound!.soundbonusoff()
            Sound!.music(1)
        }

        if emocttime > 0 {
            emocttime -= 1
        }
    }

    func drawemeralds() {
        var x: Int = 0
        var y: Int = 0

        emmask = 1 << Main!.getcplayer()
        x = 0
        while x < 15 {
            y = 0
            while y < 10 {
                if (emfield[y * 15 + x] & emmask) != 0 {
                    Drawing!.drawemerald(x * 20 + 12, y * 18 + 21)
                }

                y += 1
            }

            x += 1
        }
    }

    func drawexplosion() {
        switch expsn {
        case 1:
            Sound!.soundexplode()
        case 2, 3:
            Drawing!.drawfire(firex, firey, expsn)
            Main!.incpenalty()
            expsn += 1
        default:
            killfire()
            expsn = 0
        }
    }

    func endbonusmode() {
        bonusmode = false
        Pc!.ginten(0)
    }

    func erasebonus() {
        if bonusvisible {
            bonusvisible = false
            Sprite!.erasespr(14)
        }

        Pc!.ginten(0)
    }

    func erasedigger() {
        Sprite!.erasespr(0)
        diggervisible = false
    }

    func getAppletInfo() -> String {
        return "The Digger Remastered -- http://www.digger.org, Copyright (c) Andrew Jenner & Marek Futrega / MAF"
    }

    func getfirepflag() -> Bool {
        return Input!.firepflag
    }

    func hitemerald(_ xConst: Int, _ yConst: Int, _ rxConst: Int, _ ryConst: Int, _ dirConst: Int) -> Bool
    {
        var x = xConst
        var y = yConst
        var rx = rxConst
        var ry = ryConst
        var dir = dirConst

        var hit: Bool = false

        var r: Int = 0

        if dir < 0 || dir > 6 || ((dir & 1) != 0) {
            return hit
        }

        if dir == 0 && rx != 0 {
            x += 1
        }

        if dir == 6 && ry != 0 {
            y += 1
        }

        if dir == 0 || dir == 4 {
            r = rx
        } else {
            r = ry
        }

        if (emfield[y * 15 + x] & emmask) != 0 {
            if r == embox[dir] {
                Drawing!.drawemerald(x * 20 + 12, y * 18 + 21)
                Main!.incpenalty()
            }

            if r == embox[dir + 1] {
                Drawing!.eraseemerald(x * 20 + 12, y * 18 + 21)
                Main!.incpenalty()
                hit = true
                emfield[y * 15 + x] &= ~emmask
            }
        }

        return hit
    }

    func ´init´() {
        if gamethread != nil {
            gamethread!.cancel()
        }

        subaddr = pgtk!.getSubmitParameter()
        frametime = pgtk!.getSpeedParameter()

        if frametime > Digger.MAX_RATE {
            frametime = Digger.MAX_RATE
        } else if frametime < Digger.MIN_RATE {
            frametime = Digger.MIN_RATE
        }

        Pc!.pixels = [Int](repeating: 0, count: 65536)

        var i: Int = 0
        while i < 2 {
            let model = IndexColorModel(8, 4, Pc!.pal[i][0], Pc!.pal[i][1], Pc!.pal[i][2])
            Pc!.source[i] = pgtk!.create_refresher(self, model)
            Pc!.source[i].set_animated(true)
            Pc!.source[i].newPixels()

            i += 1
        }

        Pc!.currentSource = Pc!.source[0]

        gamethread = Thread(block: run)
        gamethread!.start()
    }

    func initbonusmode() {
        bonusmode = true
        erasebonus()
        Pc!.ginten(1)
        bonustimeleft = 250 - Main!.levof10() * 20
        startbonustimeleft = 20
        eatmsc = 1
    }

    func initdigger() {
        diggerv = 9
        digmdir = 4
        diggerh = 7
        diggerx = diggerh * 20 + 12
        digdir = 0
        diggerrx = 0
        diggerry = 0
        digtime = 0
        digonscr = true
        deathstage = 1
        diggervisible = true
        diggery = diggerv * 18 + 18
        Sprite!.movedrawspr(0, diggerx, diggery)
        notfiring = true
        emocttime = 0
        bonusvisible = false; bonusmode = false
        Input!.firepressed = false
        expsn = 0
        rechargetime = 0
    }

    func keyDown(_ keyConst: Int) -> Bool {
        var key = keyConst

        switch key {
        case 1006:
            Input!.processkey(0x4B)
        case 1007:
            Input!.processkey(0x4D)
        case 1004:
            Input!.processkey(0x48)
        case 1005:
            Input!.processkey(0x50)
        case 1008:
            Input!.processkey(0x3B)
        default:
            key &= 0x7F
            if key >= 65, key <= 90 {
                key += (97 - 65)
            }

            Input!.processkey(key)
        }

        return true
    }

    func keyUp(_ keyConst: Int) -> Bool {
        var key = keyConst

        switch key {
        case 1006:
            Input!.processkey(0xCB)
        case 1007:
            Input!.processkey(0xCD)
        case 1004:
            Input!.processkey(0xC8)
        case 1005:
            Input!.processkey(0xD0)
        case 1008:
            Input!.processkey(0xBB)
        default:
            key &= 0x7F
            if key >= 65, key <= 90 {
                key += (97 - 65)
            }

            Input!.processkey(0x80 | key)
        }

        return true
    }

    func killdigger(_ stageConst: Int, _ bagConst: Int) {
        var stage = stageConst
        var bag = bagConst

        if deathstage < 2 || deathstage > 4 {
            digonscr = false
            deathstage = stage
            deathbag = bag
        }
    }

    func killemerald(_ xConst: Int, _ yConst: Int) {
        var x = xConst
        var y = yConst

        if (emfield[y * 15 + x + 15] & emmask) != 0 {
            emfield[y * 15 + x + 15] &= ~emmask
            Drawing!.eraseemerald(x * 20 + 12, (y + 1) * 18 + 21)
        }
    }

    func killfire() {
        if !notfiring {
            notfiring = true
            Sprite!.erasespr(15)
            Sound!.soundfireoff()
        }
    }

    func makeemfield() {
        var x: Int = 0
        var y: Int = 0

        emmask = 1 << Main!.getcplayer()
        x = 0
        while x < 15 {
            y = 0
            while y < 10 {
                if Main!.getlevch(x, y, Main!.levplan()) == "C" {
                    emfield[y * 15 + x] |= emmask
                } else {
                    emfield[y * 15 + x] &= ~emmask
                }

                y += 1
            }

            x += 1
        }
    }

    func newframe() {
        Input!.checkkeyb()
        time += frametime
        var l: Int = time - Pc!.gethrt()

        if l > 0 {
            ThreadX.sleep(l)
        }

        Pc!.currentSource.newPixels()
    }

    func paint(_ gConst: Graphics) {
        var g = gConst

        update(g)
    }

    func reversedir(_ dirConst: Int) -> Int {
        var dir = dirConst

        switch dir {
        case 0:
            return 4
        case 4:
            return 0
        case 2:
            return 6
        case 6:
            return 2
        default:
            break
        }

        return dir
    }

    func run() {
        Main!.main()
    }

    func start() {
        pgtk!.requestFocus()
    }

    func update(_ gConst: Graphics) {
        var g = gConst

        // g.drawImage(Pc!.currentImage, 0, 0, self)
    }

    func updatedigger() {
        var dir: Int = 0
        var ddir: Int = 0
        var clbits: Int = 0
        var diggerox: Int = 0
        var diggeroy: Int = 0
        var nmon: Int = 0

        var push: Bool = false

        Input!.readdir()
        dir = Input!.getdir()
        if dir == 0 || dir == 2 || dir == 4 || dir == 6 {
            ddir = dir
        } else {
            ddir = -1
        }

        if diggerrx == 0 && (ddir == 2 || ddir == 6) {
            digdir = ddir; digmdir = ddir
        }

        if diggerry == 0 && (ddir == 4 || ddir == 0) {
            digdir = ddir; digmdir = ddir
        }

        if dir == -1 {
            digmdir = -1
        } else {
            digmdir = digdir
        }

        if (diggerx == 292 && digmdir == 0) || (diggerx == 12 && digmdir == 4) || (diggery == 180 && digmdir == 6) || (diggery == 18 && digmdir == 2)
        {
            digmdir = -1
        }

        diggerox = diggerx
        diggeroy = diggery
        if digmdir != -1 {
            Drawing!.eatfield(diggerox, diggeroy, digmdir)
        }

        switch digmdir {
        case 0:
            Drawing!.drawrightblob(diggerx, diggery)
            diggerx += 4
        case 4:
            Drawing!.drawleftblob(diggerx, diggery)
            diggerx -= 4
        case 2:
            Drawing!.drawtopblob(diggerx, diggery)
            diggery -= 3
        case 6:
            Drawing!.drawbottomblob(diggerx, diggery)
            diggery += 3
        default:
            break
        }

        if hitemerald((diggerx - 12) / 20, (diggery - 18) / 18, (diggerx - 12) % 20, (diggery - 18) % 18, digmdir)
        {
            Scores!.scoreemerald()
            Sound!.soundem()
            Sound!.soundemerald(emocttime)
            emocttime = 9
        }

        clbits = Drawing!.drawdigger(digdir, diggerx, diggery, notfiring && rechargetime == 0)
        Main!.incpenalty()
        if (Bags!.bagbits() & clbits) != 0 {
            if digmdir == 0 || digmdir == 4 {
                push = Bags!.pushbags(digmdir, clbits)
                digtime += 1
            } else if !Bags!.pushudbags(clbits) {
                push = false
            }

            if !push {
                diggerx = diggerox
                diggery = diggeroy
                Drawing!.drawdigger(digmdir, diggerx, diggery, notfiring && rechargetime == 0)
                Main!.incpenalty()
                digdir = reversedir(digmdir)
            }
        }

        if (clbits & 0x3F00) != 0, bonusmode {
            nmon = Monster!.killmonsters(clbits)
            while nmon != 0 {
                Sound!.soundeatm()
                Scores!.scoreeatm()

                nmon -= 1
            }
        }

        if (clbits & 0x4000) != 0 {
            Scores!.scorebonus()
            initbonusmode()
        }

        diggerh = (diggerx - 12) / 20
        diggerrx = (diggerx - 12) % 20
        diggerv = (diggery - 18) / 18
        diggerry = (diggery - 18) % 18
    }

    func updatefire() {
        var clbits: Int = 0
        var b: Int = 0
        var mon: Int = 0
        var pix: Int = 0

        if notfiring {
            if rechargetime != 0 {
                rechargetime -= 1
            } else if getfirepflag() {
                if digonscr {
                    rechargetime = Main!.levof10() * 3 + 60
                    notfiring = false
                    switch digdir {
                    case 0:
                        firex = diggerx + 8
                        firey = diggery + 4
                    case 4:
                        firex = diggerx
                        firey = diggery + 4
                    case 2:
                        firex = diggerx + 4
                        firey = diggery
                    case 6:
                        firex = diggerx + 4
                        firey = diggery + 8
                    default:
                        break
                    }

                    firedir = digdir
                    Sprite!.movedrawspr(15, firex, firey)
                    Sound!.soundfire()
                }
            }
        } else {
            switch firedir {
            case 0:
                firex += 8
                pix = Pc!.ggetpix(firex, firey + 4) | Pc!.ggetpix(firex + 4, firey + 4)
            case 4:
                firex -= 8
                pix = Pc!.ggetpix(firex, firey + 4) | Pc!.ggetpix(firex + 4, firey + 4)
            case 2:
                firey -= 7
                pix = (Pc!.ggetpix(firex + 4, firey) | Pc!.ggetpix(firex + 4, firey + 1) | Pc!.ggetpix(firex + 4, firey + 2) | Pc!.ggetpix(firex + 4, firey + 3) | Pc!.ggetpix(firex + 4, firey + 4) | Pc!.ggetpix(firex + 4, firey + 5) | Pc!.ggetpix(firex + 4, firey + 6)) & 0xC0
            case 6:
                firey += 7
                pix = (Pc!.ggetpix(firex, firey) | Pc!.ggetpix(firex, firey + 1) | Pc!.ggetpix(firex, firey + 2) | Pc!.ggetpix(firex, firey + 3) | Pc!.ggetpix(firex, firey + 4) | Pc!.ggetpix(firex, firey + 5) | Pc!.ggetpix(firex, firey + 6)) & 3
            default:
                break
            }

            clbits = Drawing!.drawfire(firex, firey, 0)
            Main!.incpenalty()
            if (clbits & 0x3F00) != 0 {
                mon = 0
                b = 256
                while mon < 6 {
                    if (clbits & b) != 0 {
                        Monster!.killmon(mon)
                        Scores!.scorekill()
                        expsn = 1
                    }

                    mon += 1
                    b <<= 1
                }
            }

            if (clbits & 0x40FE) != 0 {
                expsn = 1
            }

            switch firedir {
            case 0:
                if firex > 296 {
                    expsn = 1
                } else if pix != 0, clbits == 0 {
                    expsn = 1
                    firex -= 8
                    Drawing!.drawfire(firex, firey, 0)
                }

            case 4:
                if firex < 16 {
                    expsn = 1
                } else if pix != 0, clbits == 0 {
                    expsn = 1
                    firex += 8
                    Drawing!.drawfire(firex, firey, 0)
                }

            case 2:
                if firey < 15 {
                    expsn = 1
                } else if pix != 0, clbits == 0 {
                    expsn = 1
                    firey += 7
                    Drawing!.drawfire(firex, firey, 0)
                }

            case 6:
                if firey > 183 {
                    expsn = 1
                } else if pix != 0, clbits == 0 {
                    expsn = 1
                    firey -= 7
                    Drawing!.drawfire(firex, firey, 0)
                }

            default:
                break
            }
        }
    }
}
