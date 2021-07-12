
import Foundation

class Scores {
    var dig: Digger

    var scores = [ScoreTuple](repeating: ScoreTuple("...", 0), count: 11)

    var substr: String = ""

    var highbuf: [Character] = [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]

    var scorehigh: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    var scoreinit: [String] = ["", "", "", "", "", "", "", "", "", "", ""]

    var scoret: Int = 0

    var score1: Int = 0

    var score2: Int = 0

    var nextbs1: Int = 0

    var nextbs2: Int = 0

    var hsbuf: String = ""

    var scorebuf: [Character] = [" ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "]

    var bonusscore: Int = 20000

    var gotinitflag: Bool = false

    init(_ dConst: Digger) {
        var d = dConst

        dig = d
    }

    func submit(_ nConst: String, _ sConst: Int) -> [ScoreTuple] {
        var n = nConst
        var s = sConst

        if dig.subaddr != nil {}

        return scores
    }

    func updatescores(_ oConst: [ScoreTuple]) {
        var o = oConst

        if o == nil {
            return
        }

        var inx = [String](repeating: "", count: 12)

        var scx = [Int](repeating: 0, count: 12)

        var i: Int = 0

        while i < 10 {
            inx[i] = o[i].name
            scx[i] = o[i].score

            i += 1
        }

        while i < 10 {
            scoreinit[i + 1] = inx[i]
            scorehigh[i + 2] = scx[i]

            i += 1
        }
    }

    func addscore(_ scoreConst: Int) {
        var score = scoreConst

        if dig.Main!.getcplayer() == 0 {
            score1 += score
            if score1 > 999_999 {
                score1 = 0
            }

            writenum(score1, 0, 0, 6, 1)
            if score1 >= nextbs1 {
                if dig.Main!.getlives(1) < 5 {
                    dig.Main!.addlife(1)
                    dig.Drawing!.drawlives()
                }

                nextbs1 += bonusscore
            }
        } else {
            score2 += score
            if score2 > 999_999 {
                score2 = 0
            }

            if score2 < 100_000 {
                writenum(score2, 236, 0, 6, 1)
            } else {
                writenum(score2, 248, 0, 6, 1)
            }

            if score2 > nextbs2 {
                if dig.Main!.getlives(2) < 5 {
                    dig.Main!.addlife(2)
                    dig.Drawing!.drawlives()
                }

                nextbs2 += bonusscore
            }
        }

        dig.Main!.incpenalty()
        dig.Main!.incpenalty()
        dig.Main!.incpenalty()
    }

    func drawscores() {
        writenum(score1, 0, 0, 6, 3)
        if dig.Main!.nplayers == 2 {
            if score2 < 100_000 {
                writenum(score2, 236, 0, 6, 3)
            } else {
                writenum(score2, 248, 0, 6, 3)
            }
        }
    }

    func endofgame() {
        var i: Int = 0
        var j: Int = 0
        var z: Int = 0

        addscore(0)
        if dig.Main!.getcplayer() == 0 {
            scoret = score1
        } else {
            scoret = score2
        }

        if scoret > scorehigh[11] {
            dig.Pc!.gclear()
            drawscores()
            dig.Main!.pldispbuf = "PLAYER "
            if dig.Main!.getcplayer() == 0 {
                dig.Main!.pldispbuf += "1"
            } else {
                dig.Main!.pldispbuf += "2"
            }

            dig.Drawing!.outtext(dig.Main!.pldispbuf, 108, 0, 2, true)
            dig.Drawing!.outtext(" NEW HIGH SCORE ", 64, 40, 2, true)
            getinitials()
            updatescores(submit(scoreinit[0], scoret))
            shufflehigh()
            ScoreStorage.writeToStorage(self);
        } else {
            dig.Main!.cleartopline()
            dig.Drawing!.outtext("GAME OVER", 104, 0, 3, true)
            updatescores(submit("...", scoret))
            dig.Sound!.killsound()
            j = 0
            while j < 20 {
                i = 0
                while i < 2 {
                    dig.Sprite!.setretr(true)
                    dig.Pc!.gpal(1 - (j & 1))
                    dig.Sprite!.setretr(false)
                    z = 0
                    while z < 111 {
                        z += 1
                    }

                    dig.Pc!.gpal(0)
                    dig.Pc!.ginten(1 - i & 1)
                    dig.newframe()

                    i += 1
                }

                j += 1
            }

            dig.Sound!.setupsound()
            dig.Drawing!.outtext("         ", 104, 0, 3, true)
            dig.Sprite!.setretr(true)
        }
    }

    func flashywait(_ nConst: Int) {
        var n = nConst

        ThreadX.sleep(n * 2)
    }

    func getinitial(_ xConst: Int, _ yConst: Int) -> Int {
        var x = xConst
        var y = yConst

        var i: Int = 0
        var j: Int = 0

        dig.Input!.keypressed = 0
        dig.Pc!.gwrite(x, y, "_".charAt(0), 3, true)
        j = 0
        while j < 5 {
            i = 0
            while i < 40 {
                if (dig.Input!.keypressed & 0x80) == 0, dig.Input!.keypressed != 0 {
                    return dig.Input!.keypressed
                }

                flashywait(15)

                i += 1
            }

            i = 0
            while i < 40 {
                if (dig.Input!.keypressed & 0x80) == 0, dig.Input!.keypressed != 0 {
                    dig.Pc!.gwrite(x, y, "_".charAt(0), 3, true)
                    return dig.Input!.keypressed
                }

                flashywait(15)

                i += 1
            }

            j += 1
        }

        gotinitflag = true
        return 0
    }

    func getinitials() {
        var k: Int = 0
        var i: Int = 0

        dig.Drawing!.outtext("ENTER YOUR", 100, 70, 3, true)
        dig.Drawing!.outtext(" INITIALS", 100, 90, 3, true)
        dig.Drawing!.outtext("_ _ _", 128, 130, 3, true)
        scoreinit[0] = "..."
        dig.Sound!.killsound()
        gotinitflag = false
        i = 0
        while i < 3 {
            k = 0
            while k == 0, !gotinitflag {
                k = getinitial(i * 24 + 128, 130)
                if i != 0, k == 8 {
                    i -= 1
                }

                k = dig.Input!.getasciikey(k)
            }

            if k != 0 {
                dig.Pc!.gwrite(i * 24 + 128, 130, k, 3, true)
                var sb = StringBuffer(scoreinit[0])

                sb.setCharAt(i, k)
                scoreinit[0] = sb.toString()
            }

            i += 1
        }

        dig.Input!.keypressed = 0
        i = 0
        while i < 20 {
            flashywait(15)
            i += 1
        }

        dig.Sound!.setupsound()
        dig.Pc!.gclear()
        dig.Pc!.gpal(0)
        dig.Pc!.ginten(0)
        dig.newframe()
        dig.Sprite!.setretr(true)
    }

    func initscores() {
        addscore(0)
    }

    func loadscores() {
        var p: Int = 1
        var i: Int = 0
        var x: Int = 0

        i = 1
        while i < 11 {
            x = 0
            while x < 3 {
                scoreinit[i] = "..."
                x += 1
            }

            p += 2
            x = 0
            while x < 6 {
                highbuf[x] = scorebuf[p]
                p += 1
                x += 1
            }

            scorehigh[i + 1] = 0

            i += 1
        }

        if scorebuf[0] != "s" {
            i = 0
            while i < 11 {
                scorehigh[i + 1] = 0
                scoreinit[i] = "..."

                i += 1
            }
        }
    }

    func numtostring(_ nConst: Int) -> String {
        var n = nConst

        var x: Int = 0

        var p: String = ""

        x = 0
        while x < 6 {
            p = String.valueOf(n % 10) + p
            n /= 10
            if n == 0 {
                x += 1
                break
            }

            x += 1
        }

        while x < 6 {
            p = " " + p
            x += 1
        }

        return p
    }

    func  `init`() {
	    if (!ScoreStorage.readFromStorage(self)){
		    ScoreStorage.createInStorage(self);
        }
    }

    func scorebonus() {
        addscore(1000)
    }

    func scoreeatm() {
        addscore(dig.eatmsc * 200)
        dig.eatmsc <<= 1
    }

    func scoreemerald() {
        addscore(25)
    }

    func scoregold() {
        addscore(500)
    }

    func scorekill() {
        addscore(250)
    }

    func scoreoctave() {
        addscore(250)
    }

    func showtable() {
        var i: Int = 0
        var col: Int = 0

        dig.Drawing!.outtext("HIGH SCORES", 16, 25, 3)
        col = 2
        i = 1
        while i < 11 {
            hsbuf = scoreinit[i] + "  " + numtostring(scorehigh[i + 1])
            dig.Drawing!.outtext(hsbuf, 16, 31 + 13 * i, col)
            col = 1

            i += 1
        }
    }

    func shufflehigh() {
        var i: Int = 0
        var j: Int = 0

        j = 10
        while j > 1 {
            if scoret < scorehigh[j] {
                break
            }

            j -= 1
        }

        i = 10
        while i > j {
            scorehigh[i + 1] = scorehigh[i]
            scoreinit[i] = scoreinit[i - 1]

            i -= 1
        }

        scorehigh[j + 1] = scoret
        scoreinit[j] = scoreinit[0]
    }

    func writecurscore(_ bp6Const: Int) {
        var bp6 = bp6Const

        if dig.Main!.getcplayer() == 0 {
            writenum(score1, 0, 0, 6, bp6)
        } else if score2 < 100_000 {
            writenum(score2, 236, 0, 6, bp6)
        } else {
            writenum(score2, 248, 0, 6, bp6)
        }
    }

    func writenum(_ nConst: Int, _ xConst: Int, _ yConst: Int, _ wConst: Int, _ cConst: Int) {
        var n = nConst
        var x = xConst
        var y = yConst
        var w = wConst
        var c = cConst

        var d: Int = 0
        var xp: Int = (w - 1) * 12 + x

        while w > 0 {
            d = (n % 10)
            if w > 1 || d > 0 {
                dig.Pc!.gwrite(xp, y, d + "0".charAt(0), c, false)
            }

            n /= 10
            w -= 1
            xp -= 12
        }
    }

    func zeroscores() {
        score2 = 0
        score1 = 0
        scoret = 0
        nextbs1 = bonusscore
        nextbs2 = bonusscore
    }
}
