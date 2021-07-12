
import Foundation

class Main {
    var dig: Digger

    var digsprorder: [Int] = [14, 13, 7, 6, 5, 4, 3, 2, 1, 12, 11, 10, 9, 8, 15, 0]

    var gamedat: [GameData] = [GameData(), GameData()]

    var pldispbuf: String = ""

    var curplayer: Int = 0

    var nplayers: Int = 0

    var penalty: Int = 0

    var levnotdrawn: Bool = false

    var flashplayer: Bool = false

    var levfflag: Bool = false

    var biosflag: Bool = false

    var speedmul: Int = 40

    var delaytime: Int = 0

    var randv: Int = 0

    var leveldat: [[String]] = [["S   B     HHHHS", "V  CC  C  V B  ", "VB CC  C  V    ", "V  CCB CB V CCC", "V  CC  C  V CCC", "HH CC  C  V CCC", " V    B B V    ", " HHHH     V    ", "C   V     V   C", "CC  HHHHHHH  CC"], ["SHHHHH  B B  HS", " CC  V       V ", " CC  V CCCCC V ", "BCCB V CCCCC V ", "CCCC V       V ", "CCCC V B  HHHH ", " CC  V CC V    ", " BB  VCCCCV CC ", "C    V CC V CC ", "CC   HHHHHH    "], ["SHHHHB B BHHHHS", "CC  V C C V BB ", "C   V C C V CC ", " BB V C C VCCCC", "CCCCV C C VCCCC", "CCCCHHHHHHH CC ", " CC  C V C  CC ", " CC  C V C     ", "C    C V C    C", "CC   C H C   CC"], ["SHBCCCCBCCCCBHS", "CV  CCCCCCC  VC", "CHHH CCCCC HHHC", "C  V  CCC  V  C", "   HHH C HHH   ", "  B  V B V  B  ", "  C  VCCCV  C  ", " CCC HHHHH CCC ", "CCCCC CVC CCCCC", "CCCCC CHC CCCCC"], ["SHHHHHHHHHHHHHS", "VBCCCCBVCCCCCCV", "VCCCCCCV CCBC V", "V CCCC VCCBCCCV", "VCCCCCCV CCCC V", "V CCCC VBCCCCCV", "VCCBCCCV CCCC V", "V CCBC VCCCCCCV", "VCCCCCCVCCCCCCV", "HHHHHHHHHHHHHHH"], ["SHHHHHHHHHHHHHS", "VCBCCV V VCCBCV", "VCCC VBVBV CCCV", "VCCCHH V HHCCCV", "VCC V CVC V CCV", "VCCHH CVC HHCCV", "VC V CCVCC V CV", "VCHHBCCVCCBHHCV", "VCVCCCCVCCCCVCV", "HHHHHHHHHHHHHHH"], ["SHCCCCCVCCCCCHS", " VCBCBCVCBCBCV ", "BVCCCCCVCCCCCVB", "CHHCCCCVCCCCHHC", "CCV CCCVCCC VCC", "CCHHHCCVCCHHHCC", "CCCCV CVC VCCCC", "CCCCHH V HHCCCC", "CCCCCV V VCCCCC", "CCCCCHHHHHCCCCC"], ["HHHHHHHHHHHHHHS", "V CCBCCCCCBCC V", "HHHCCCCBCCCCHHH", "VBV CCCCCCC VBV", "VCHHHCCCCCHHHCV", "VCCBV CCC VBCCV", "VCCCHHHCHHHCCCV", "VCCCC V V CCCCV", "VCCCCCV VCCCCCV", "HHHHHHHHHHHHHHH"]]

    init(_ dConst: Digger) {
        var d = dConst

        dig = d
    }

    func addlife(_ plConst: Int) {
        var pl = plConst

        gamedat[pl - 1].lives += 1
        dig.Sound!.sound1up()
    }

    func calibrate() {
        dig.Sound!.volume = (dig.Pc!.getkips() / 291)
        if dig.Sound!.volume == 0 {
            dig.Sound!.volume = 1
        }
    }

    func checklevdone() {
        if dig.countem() == 0 || dig.Monster!.monleft() == 0, dig.digonscr {
            gamedat[curplayer].levdone = true
        } else {
            gamedat[curplayer].levdone = false
        }
    }

    func cleartopline() {
        dig.Drawing!.outtext("                          ", 0, 0, 3)
        dig.Drawing!.outtext(" ", 308, 0, 3)
    }

    func drawscreen() {
        dig.Drawing!.creatembspr()
        dig.Drawing!.drawstatics()
        dig.Bags!.drawbags()
        dig.drawemeralds()
        dig.initdigger()
        dig.Monster!.initmonsters()
    }

    func getcplayer() -> Int {
        return curplayer
    }

    func getlevch(_ xConst: Int, _ yConst: Int, _ lConst: Int) -> Int {
        var x = xConst
        var y = yConst
        var l = lConst

        if l == 0 {
            l += 1
        }

        return leveldat[l - 1][y].charAt(x)
    }

    func getlives(_ plConst: Int) -> Int {
        var pl = plConst

        return gamedat[pl - 1].lives
    }

    func incpenalty() {
        penalty += 1
    }

    func initchars() {
        dig.Drawing!.initmbspr()
        dig.initdigger()
        dig.Monster!.initmonsters()
    }

    func initlevel() {
        gamedat[curplayer].levdone = false
        dig.Drawing!.makefield()
        dig.makeemfield()
        dig.Bags!.initbags()
        levnotdrawn = true
    }

    func levno() -> Int {
        return gamedat[curplayer].level
    }

    func levof10() -> Int {
        if gamedat[curplayer].level > 10 {
            return 10
        }

        return gamedat[curplayer].level
    }

    func levplan() -> Int {
        var l: Int = levno()

        if l > 8 {
            l = (l & 3) + 5
        }

        return l
    }

    func main() {
        var frame: Int = 0
        var t: Int = 0
        var x: Int = 0

        var start: Bool = false

        randv = dig.Pc!.gethrt()
        calibrate()
        dig.ftime = speedmul * 2000
        dig.Sprite!.setretr(false)
        dig.Pc!.ginit()
        dig.Sprite!.setretr(true)
        dig.Pc!.gpal(0)
        dig.Input!.initkeyb()
        dig.Input!.detectjoy()
        dig.Scores!.loadscores()
        dig.Sound!.initsound()
        dig.Scores!.run()
        // dig.Scores!.updatescores(dig.Scores!.scores)
        nplayers = 1
        repeat {
            dig.Sound!.soundstop()
            dig.Sprite!.setsprorder(digsprorder)
            dig.Drawing!.creatembspr()
            dig.Input!.detectjoy()
            dig.Pc!.gclear()
            dig.Pc!.gtitle()
            dig.Drawing!.outtext("D I G G E R", 100, 0, 3)
            shownplayers()
            dig.Scores!.showtable()
            start = false
            frame = 0
            dig.time = dig.Pc!.gethrt()
            while !start {
                start = dig.Input!.teststart()
                if dig.Input!.akeypressed == 27 {
                    switchnplayers()
                    shownplayers()
                    dig.Input!.akeypressed = 0
                    dig.Input!.keypressed = 0
                }

                if frame == 0 {
                    t = 54
                    while t < 174 {
                        dig.Drawing!.outtext("            ", 164, t, 0)
                        t += 12
                    }
                }

                if frame == 50 {
                    dig.Sprite!.movedrawspr(8, 292, 63)
                    x = 292
                }

                if frame > 50, frame <= 77 {
                    x -= 4
                    dig.Drawing!.drawmon(0, true, 4, x, 63)
                }

                if frame > 77 {
                    dig.Drawing!.drawmon(0, true, 0, 184, 63)
                }

                if frame == 83 {
                    dig.Drawing!.outtext("NOBBIN", 216, 64, 2)
                }

                if frame == 90 {
                    dig.Sprite!.movedrawspr(9, 292, 82)
                    dig.Drawing!.drawmon(1, false, 4, 292, 82)
                    x = 292
                }

                if frame > 90, frame <= 117 {
                    x -= 4
                    dig.Drawing!.drawmon(1, false, 4, x, 82)
                }

                if frame > 117 {
                    dig.Drawing!.drawmon(1, false, 0, 184, 82)
                }

                if frame == 123 {
                    dig.Drawing!.outtext("HOBBIN", 216, 83, 2)
                }

                if frame == 130 {
                    dig.Sprite!.movedrawspr(0, 292, 101)
                    dig.Drawing!.drawdigger(4, 292, 101, true)
                    x = 292
                }

                if frame > 130, frame <= 157 {
                    x -= 4
                    dig.Drawing!.drawdigger(4, x, 101, true)
                }

                if frame > 157 {
                    dig.Drawing!.drawdigger(0, 184, 101, true)
                }

                if frame == 163 {
                    dig.Drawing!.outtext("DIGGER", 216, 102, 2)
                }

                if frame == 178 {
                    dig.Sprite!.movedrawspr(1, 184, 120)
                    dig.Drawing!.drawgold(1, 0, 184, 120)
                }

                if frame == 183 {
                    dig.Drawing!.outtext("GOLD", 216, 121, 2)
                }

                if frame == 198 {
                    dig.Drawing!.drawemerald(184, 141)
                }

                if frame == 203 {
                    dig.Drawing!.outtext("EMERALD", 216, 140, 2)
                }

                if frame == 218 {
                    dig.Drawing!.drawbonus(184, 158)
                }

                if frame == 223 {
                    dig.Drawing!.outtext("BONUS", 216, 159, 2)
                }

                dig.newframe()
                frame += 1
                if frame > 250 {
                    frame = 0
                }
            }

            gamedat[0].level = 1
            gamedat[0].lives = 3
            if nplayers == 2 {
                gamedat[1].level = 1
                gamedat[1].lives = 3
            } else {
                gamedat[1].lives = 0
            }

            dig.Pc!.gclear()
            curplayer = 0
            initlevel()
            curplayer = 1
            initlevel()
            dig.Scores!.zeroscores()
            dig.bonusvisible = true
            if nplayers == 2 {
                flashplayer = true
            }

            curplayer = 0
            while gamedat[0].lives != 0 || gamedat[1].lives != 0, !dig.Input!.escape {
                gamedat[curplayer].dead = false
                while !gamedat[curplayer].dead, gamedat[curplayer].lives != 0, !dig.Input!.escape {
                    dig.Drawing!.initmbspr()
                    play()
                }

                if gamedat[1 - curplayer].lives != 0 {
                    curplayer = 1 - curplayer
                    flashplayer = true; levnotdrawn = true
                }
            }

            dig.Input!.escape = false

        } while !false
    }

    func play() {
        var t: Int = 0
        var c: Int = 0

        if levnotdrawn {
            levnotdrawn = false
            drawscreen()
            dig.time = dig.Pc!.gethrt()
            if flashplayer {
                flashplayer = false
                pldispbuf = "PLAYER "
                if curplayer == 0 {
                    pldispbuf += "1"
                } else {
                    pldispbuf += "2"
                }

                cleartopline()
                t = 0
                while t < 15 {
                    c = 1
                    while c <= 3 {
                        dig.Drawing!.outtext(pldispbuf, 108, 0, c)
                        dig.Scores!.writecurscore(c)
                        dig.newframe()
                        if dig.Input!.escape {
                            return
                        }

                        c += 1
                    }

                    t += 1
                }

                dig.Scores!.drawscores()
                dig.Scores!.addscore(0)
            }
        } else {
            initchars()
        }

        dig.Input!.keypressed = 0
        dig.Drawing!.outtext("        ", 108, 0, 3)
        dig.Scores!.initscores()
        dig.Drawing!.drawlives()
        dig.Sound!.music(1)
        dig.Input!.readdir()
        dig.time = dig.Pc!.gethrt()
 
        while !gamedat[curplayer].dead, !gamedat[curplayer].levdone, !dig.Input!.escape {
            penalty = 0
            dig.dodigger()
            dig.Monster!.domonsters()
            dig.Bags!.dobags()
            if penalty > 8 {
                dig.Monster!.incmont(penalty - 8)
            }

            testpause()
            checklevdone()
        }

        dig.erasedigger()
        dig.Sound!.musicoff()
        t = 20
        while dig.Bags!.getnmovingbags() != 0 || t != 0, !dig.Input!.escape {
            if t != 0 {
                t -= 1
            }

            penalty = 0
            dig.Bags!.dobags()
            dig.dodigger()
            dig.Monster!.domonsters()
            if penalty < 8 {
                t = 0
            }
        }

        dig.Sound!.soundstop()
        dig.killfire()
        dig.erasebonus()
        dig.Bags!.cleanupbags()
        dig.Drawing!.savefield()
        dig.Monster!.erasemonsters()
        dig.newframe()
        if gamedat[curplayer].levdone {
            dig.Sound!.soundlevdone()
        }

        if dig.countem() == 0 {
            gamedat[curplayer].level += 1
            if gamedat[curplayer].level > 1000 {
                gamedat[curplayer].level = 1000
            }

            initlevel()
        }

        if gamedat[curplayer].dead {
            gamedat[curplayer].lives -= 1
            dig.Drawing!.drawlives()
            if gamedat[curplayer].lives == 0, !dig.Input!.escape {
                dig.Scores!.endofgame()
            }
        }

        if gamedat[curplayer].levdone {
            gamedat[curplayer].level += 1
            if gamedat[curplayer].level > 1000 {
                gamedat[curplayer].level = 1000
            }

            initlevel()
        }
    }

    func randno(_ nConst: Int) -> Int {
        var n = nConst

        let randNum = Int.random(in: 2516820..<2146795942)
        self.randv = randNum

        return (self.randv) % n
    }

    func setdead(_ bp6Const: Bool) {
        var bp6 = bp6Const

        gamedat[curplayer].dead = bp6
    }

    func shownplayers() {
        if nplayers == 1 {
            dig.Drawing!.outtext("ONE", 220, 25, 3)
            dig.Drawing!.outtext(" PLAYER ", 192, 39, 3)
        } else {
            dig.Drawing!.outtext("TWO", 220, 25, 3)
            dig.Drawing!.outtext(" PLAYERS", 184, 39, 3)
        }
    }

    func switchnplayers() {
        nplayers = 3 - nplayers
    }

    func testpause() {
        if dig.Input!.akeypressed == 32 {
            dig.Input!.akeypressed = 0
            dig.Sound!.soundpause()
            dig.Sound!.sett2val(40)
            dig.Sound!.setsoundt2()
            cleartopline()
            dig.Drawing!.outtext("PRESS ANY KEY", 80, 0, 1)
            dig.newframe()
            dig.Input!.keypressed = 0
            while true {
                ThreadX.sleep(50)

                if dig.Input!.keypressed != 0 {
                    break
                }
            }

            cleartopline()
            dig.Scores!.drawscores()
            dig.Scores!.addscore(0)
            dig.Drawing!.drawlives()
            dig.newframe()
            dig.time = dig.Pc!.gethrt() - dig.frametime
            dig.Input!.keypressed = 0
        } else {
            dig.Sound!.soundpauseoff()
        }
    }
}
