
import Foundation

class Monster {
    var dig: Digger

    var mondat: [_monster] = [_monster(), _monster(), _monster(), _monster(), _monster(), _monster()]

    var nextmonster: Int = 0

    var totalmonsters: Int = 0

    var maxmononscr: Int = 0

    var nextmontime: Int = 0

    var mongaptime: Int = 0

    var unbonusflag: Bool = false

    var mongotgold: Bool = false

    init(_ dConst: Digger) {
        var d = dConst

        dig = d
    }

    func checkcoincide(_ monConst: Int, _ bitsConst: Int) {
        var mon = monConst
        var bits = bitsConst

        var m: Int = 0
        var b: Int = 0

        m = 0
        b = 256
        while m < 6 {
            if (bits & b) != 0, mondat[mon].dir == mondat[m].dir, mondat[m].stime == 0, mondat[mon].stime == 0
            {
                mondat[m].dir = dig.reversedir(mondat[m].dir)
            }

            m += 1
            b <<= 1
        }
    }

    func checkmonscared(_ hConst: Int) {
        var h = hConst

        var m: Int = 0

        m = 0
        while m < 6 {
            if h == mondat[m].h, mondat[m].dir == 2 {
                mondat[m].dir = 6
            }

            m += 1
        }
    }

    func createmonster() {
        var i: Int = 0

        i = 0
        while i < 6 {
            if !mondat[i].flag {
                mondat[i].flag = true
                mondat[i].alive = true
                mondat[i].t = 0
                mondat[i].nob = true
                mondat[i].hnt = 0
                mondat[i].h = 14
                mondat[i].v = 0
                mondat[i].x = 292
                mondat[i].y = 18
                mondat[i].xr = 0
                mondat[i].yr = 0
                mondat[i].dir = 4
                mondat[i].hdir = 4
                nextmonster += 1
                nextmontime = mongaptime
                mondat[i].stime = 5
                dig.Sprite!.movedrawspr(i + 8, mondat[i].x, mondat[i].y)
                break
            }

            i += 1
        }
    }

    func domonsters() {
        var i: Int = 0

        if nextmontime > 0 {
            nextmontime -= 1
        } else {
            if nextmonster < totalmonsters, nmononscr() < maxmononscr, dig.digonscr, !dig.bonusmode
            {
                createmonster()
            }

            if unbonusflag, nextmonster == totalmonsters, nextmontime == 0 {
                if dig.digonscr {
                    unbonusflag = false
                    dig.createbonus()
                }
            }
        }

        i = 0
        while i < 6 {
            if mondat[i].flag {
                if mondat[i].hnt > 10 - dig.Main!.levof10() {
                    if mondat[i].nob {
                        mondat[i].nob = false
                        mondat[i].hnt = 0
                    }
                }

                if mondat[i].alive {
                    if mondat[i].t == 0 {
                        monai(i)
                        if dig.Main!.randno(15 - dig.Main!.levof10()) == 0, mondat[i].nob {
                            monai(i)
                        }
                    } else {
                        mondat[i].t -= 1
                    }
                } else {
                    mondie(i)
                }
            }

            i += 1
        }
    }

    func erasemonsters() {
        var i: Int = 0

        i = 0
        while i < 6 {
            if mondat[i].flag {
                dig.Sprite!.erasespr(i + 8)
            }

            i += 1
        }
    }

    func fieldclear(_ dirConst: Int, _ xConst: Int, _ yConst: Int) -> Bool {
        var dir = dirConst
        var x = xConst
        var y = yConst

        switch dir {
        case 0:
            if x < 14 {
                if (getfield(x + 1, y) & 0x2000) == 0 {
                    if (getfield(x + 1, y) & 1) == 0 || (getfield(x, y) & 0x10) == 0 {
                        return true
                    }
                }
            }

        case 4:
            if x > 0 {
                if (getfield(x - 1, y) & 0x2000) == 0 {
                    if (getfield(x - 1, y) & 0x10) == 0 || (getfield(x, y) & 1) == 0 {
                        return true
                    }
                }
            }

        case 2:
            if y > 0 {
                if (getfield(x, y - 1) & 0x2000) == 0 {
                    if (getfield(x, y - 1) & 0x800) == 0 || (getfield(x, y) & 0x40) == 0 {
                        return true
                    }
                }
            }

        case 6:
            if y < 9 {
                if (getfield(x, y + 1) & 0x2000) == 0 {
                    if (getfield(x, y + 1) & 0x40) == 0 || (getfield(x, y) & 0x800) == 0 {
                        return true
                    }
                }
            }

        default:
            break
        }

        return false
    }

    func getfield(_ xConst: Int, _ yConst: Int) -> Int {
        var x = xConst
        var y = yConst

        return dig.Drawing!.field[y * 15 + x]
    }

    func incmont(_ nConst: Int) {
        var n = nConst

        var m: Int = 0

        if n > 6 {
            n = 6
        }

        m = 1
        while m < n {
            mondat[m].t += 1
            m += 1
        }
    }

    func incpenalties(_ bitsConst: Int) {
        var bits = bitsConst

        var m: Int = 0
        var b: Int = 0

        m = 0
        b = 256
        while m < 6 {
            if (bits & b) != 0 {
                dig.Main!.incpenalty()
            }

            b <<= 1

            m += 1
            b <<= 1
        }
    }

    func initmonsters() {
        var i: Int = 0

        i = 0
        while i < 6 {
            mondat[i].flag = false
            i += 1
        }

        nextmonster = 0
        mongaptime = 45 - (dig.Main!.levof10() << 1)
        totalmonsters = dig.Main!.levof10() + 5
        switch dig.Main!.levof10() {
        case 1:
            maxmononscr = 3
        case 2, 3, 4, 5, 6, 7:
            maxmononscr = 4
        case 8, 9, 10:
            maxmononscr = 5
        default:
            break
        }

        nextmontime = 10
        unbonusflag = true
    }

    func killmon(_ monConst: Int) {
        var mon = monConst

        if mondat[mon].flag {
            mondat[mon].flag = false; mondat[mon].alive = false
            dig.Sprite!.erasespr(mon + 8)
            if dig.bonusmode {
                totalmonsters += 1
            }
        }
    }

    func killmonsters(_ bitsConst: Int) -> Int {
        var bits = bitsConst

        var m: Int = 0
        var b: Int = 0
        var n: Int = 0

        m = 0
        b = 256
        while m < 6 {
            if (bits & b) != 0 {
                killmon(m)
                n += 1
            }

            m += 1
            b <<= 1
        }

        return n
    }

    func monai(_ monConst: Int) {
        var mon = monConst

        var clbits: Int = 0
        var monox: Int = 0
        var monoy: Int = 0
        var dir: Int = 0
        var mdirp1: Int = 0
        var mdirp2: Int = 0
        var mdirp3: Int = 0
        var mdirp4: Int = 0
        var t: Int = 0

        var push: Bool = false

        monox = mondat[mon].x
        monoy = mondat[mon].y
        if mondat[mon].xr == 0 && mondat[mon].yr == 0 {
            if mondat[mon].hnt > 30 + (dig.Main!.levof10() << 1) {
                if !mondat[mon].nob {
                    mondat[mon].hnt = 0
                    mondat[mon].nob = true
                }
            }

            if abs(dig.diggery - mondat[mon].y) > abs(dig.diggerx - mondat[mon].x) {
                if dig.diggery < mondat[mon].y {
                    mdirp1 = 2
                    mdirp4 = 6
                } else {
                    mdirp1 = 6
                    mdirp4 = 2
                }
                if dig.diggerx < mondat[mon].x {
                    mdirp2 = 4
                    mdirp3 = 0
                } else {
                    mdirp2 = 0
                    mdirp3 = 4
                }
            } else {
                if dig.diggerx < mondat[mon].x {
                    mdirp1 = 4
                    mdirp4 = 0
                } else {
                    mdirp1 = 0
                    mdirp4 = 4
                }

                if dig.diggery < mondat[mon].y {
                    mdirp2 = 2
                    mdirp3 = 6
                } else {
                    mdirp2 = 6
                    mdirp3 = 2
                }
            }
 
            if dig.bonusmode {
                t = mdirp1
                mdirp1 = mdirp4
                mdirp4 = t
                t = mdirp2
                mdirp2 = mdirp3
                mdirp3 = t
            }

            dir = dig.reversedir(mondat[mon].dir)
            if dir == mdirp1 {
                mdirp1 = mdirp2
                mdirp2 = mdirp3
                mdirp3 = mdirp4
                mdirp4 = dir
            }

            if dir == mdirp2 {
                mdirp2 = mdirp3
                mdirp3 = mdirp4
                mdirp4 = dir
            }

            if dir == mdirp3 {
                mdirp3 = mdirp4
                mdirp4 = dir
            }

 
            if dig.Main!.randno(dig.Main!.levof10() + 5) == 1, dig.Main!.levof10() < 6 {
                t = mdirp1
                mdirp1 = mdirp3
                mdirp3 = t
            }

 
            if fieldclear(mdirp1, mondat[mon].h, mondat[mon].v) {
                dir = mdirp1
            } else if fieldclear(mdirp2, mondat[mon].h, mondat[mon].v) {
                dir = mdirp2
            } else if fieldclear(mdirp3, mondat[mon].h, mondat[mon].v) {
                dir = mdirp3
            } else if fieldclear(mdirp4, mondat[mon].h, mondat[mon].v) {
                dir = mdirp4
            }

 
            if !mondat[mon].nob {
                dir = mdirp1
            }

            if mondat[mon].dir != dir {
                mondat[mon].t += 1
            }

            mondat[mon].dir = dir
        }

        if (mondat[mon].x == 292 && mondat[mon].dir == 0) || (mondat[mon].x == 12 && mondat[mon].dir == 4) || (mondat[mon].y == 180 && mondat[mon].dir == 6) || (mondat[mon].y == 18 && mondat[mon].dir == 2)
        {
            mondat[mon].dir = -1
        }

        if mondat[mon].dir == 4 || mondat[mon].dir == 0 {
            mondat[mon].hdir = mondat[mon].dir
        }

        if !mondat[mon].nob {
            dig.Drawing!.eatfield(mondat[mon].x, mondat[mon].y, mondat[mon].dir)
        }

        switch mondat[mon].dir {
        case 0:
            if !mondat[mon].nob {
                dig.Drawing!.drawrightblob(mondat[mon].x, mondat[mon].y)
            }

            mondat[mon].x += 4
        case 4:
            if !mondat[mon].nob {
                dig.Drawing!.drawleftblob(mondat[mon].x, mondat[mon].y)
            }

            mondat[mon].x -= 4
        case 2:
            if !mondat[mon].nob {
                dig.Drawing!.drawtopblob(mondat[mon].x, mondat[mon].y)
            }

            mondat[mon].y -= 3
        case 6:
            if !mondat[mon].nob {
                dig.Drawing!.drawbottomblob(mondat[mon].x, mondat[mon].y)
            }

            mondat[mon].y += 3
        default:
            break
        }

        if !mondat[mon].nob {
            dig.hitemerald((mondat[mon].x - 12) / 20, (mondat[mon].y - 18) / 18, (mondat[mon].x - 12) % 20, (mondat[mon].y - 18) % 18, mondat[mon].dir)
        }

        if !dig.digonscr {
            mondat[mon].x = monox
            mondat[mon].y = monoy
        }

        if mondat[mon].stime != 0 {
            mondat[mon].stime -= 1
            mondat[mon].x = monox
            mondat[mon].y = monoy
        }

        if !mondat[mon].nob, mondat[mon].hnt < 100 {
            mondat[mon].hnt += 1
        }

        push = true
        clbits = dig.Drawing!.drawmon(mon, mondat[mon].nob, mondat[mon].hdir, mondat[mon].x, mondat[mon].y)
        dig.Main!.incpenalty()
        if (clbits & 0x3F00) != 0 {
            mondat[mon].t += 1
            checkcoincide(mon, clbits)
            incpenalties(clbits)
        }

        if (clbits & dig.Bags!.bagbits()) != 0 {
            mondat[mon].t += 1
            mongotgold = false
            if mondat[mon].dir == 4 || mondat[mon].dir == 0 {
                push = dig.Bags!.pushbags(mondat[mon].dir, clbits)
                mondat[mon].t += 1
            } else if !dig.Bags!.pushudbags(clbits) {
                push = false
            }

            if mongotgold {
                mondat[mon].t = 0
            }

            if !mondat[mon].nob, mondat[mon].hnt > 1 {
                dig.Bags!.removebags(clbits)
            }
        }

        if mondat[mon].nob, (clbits & 0x3F00) != 0, dig.digonscr {
            mondat[mon].hnt += 1
        }

        if !push {
            mondat[mon].x = monox
            mondat[mon].y = monoy
            dig.Drawing!.drawmon(mon, mondat[mon].nob, mondat[mon].hdir, mondat[mon].x, mondat[mon].y)
            dig.Main!.incpenalty()
            if mondat[mon].nob {
                mondat[mon].hnt += 1
            }

            if mondat[mon].dir == 2 || mondat[mon].dir == 6, mondat[mon].nob {
                mondat[mon].dir = dig.reversedir(mondat[mon].dir)
            }
        }

        if (clbits & 1) != 0, dig.digonscr {
            if dig.bonusmode {
                killmon(mon)
                dig.Scores!.scoreeatm()
                dig.Sound!.soundeatm()
            } else {
                dig.killdigger(3, 0)
            }
        }

        mondat[mon].h = (mondat[mon].x - 12) / 20
        mondat[mon].v = (mondat[mon].y - 18) / 18
        mondat[mon].xr = (mondat[mon].x - 12) % 20
        mondat[mon].yr = (mondat[mon].y - 18) % 18
    }

    func mondie(_ monConst: Int) {
        var mon = monConst

        switch mondat[mon].death {
        case 1:
            if dig.Bags!.bagy(mondat[mon].bag) + 6 > mondat[mon].y {
                mondat[mon].y = dig.Bags!.bagy(mondat[mon].bag)
            }

            dig.Drawing!.drawmondie(mon, mondat[mon].nob, mondat[mon].hdir, mondat[mon].x, mondat[mon].y)
            dig.Main!.incpenalty()
            if dig.Bags!.getbagdir(mondat[mon].bag) == -1 {
                mondat[mon].dtime = 1
                mondat[mon].death = 4
            }

        case 4:
            if mondat[mon].dtime != 0 {
                mondat[mon].dtime -= 1
            } else {
                killmon(mon)
                dig.Scores!.scorekill()
            }

        default:
            break
        }
    }

    func mongold() {
        mongotgold = true
    }

    func monleft() -> Int {
        return nmononscr() + totalmonsters - nextmonster
    }

    func nmononscr() -> Int {
        var i: Int = 0
        var n: Int = 0

        i = 0
        while i < 6 {
            if mondat[i].flag {
                n += 1
            }

            i += 1
        }

        return n
    }

    func squashmonster(_ monConst: Int, _ deathConst: Int, _ bagConst: Int) {
        var mon = monConst
        var death = deathConst
        var bag = bagConst

        mondat[mon].alive = false
        mondat[mon].death = death
        mondat[mon].bag = bag
    }

    func squashmonsters(_ bagConst: Int, _ bitsConst: Int) {
        var bag = bagConst
        var bits = bitsConst

        var m: Int = 0
        var b: Int = 0

        m = 0
        b = 256
        while m < 6 {
            if (bits & b) != 0 {
                if mondat[m].y >= dig.Bags!.bagy(bag) {
                    squashmonster(m, 1, bag)
                }
            }

            m += 1
            b <<= 1
        }
    }
}
