
import Foundation

class Input {
    var dig: Digger

    var leftpressed: Bool = false

    var rightpressed: Bool = false

    var uppressed: Bool = false

    var downpressed: Bool = false

    var f1pressed: Bool = false

    var firepressed: Bool = false

    var minuspressed: Bool = false

    var pluspressed: Bool = false

    var f10pressed: Bool = false

    var escape: Bool = false

    var keypressed: Int = 0

    var akeypressed: Int = 0

    var dynamicdir: Int = -1

    var staticdir: Int = -1

    var joyx: Int = 0

    var joyy: Int = 0

    var joybut1: Bool = false

    var joybut2: Bool = false

    var keydir: Int = 0

    var jleftthresh: Int = 0

    var jupthresh: Int = 0

    var jrightthresh: Int = 0

    var jdownthresh: Int = 0

    var joyanax: Int = 0

    var joyanay: Int = 0

    var firepflag: Bool = false

    var joyflag: Bool = false

    init(_ dConst: Digger) {
        var d = dConst

        dig = d
    }

    func checkkeyb() {
        if pluspressed {
            if dig.frametime > Digger.MIN_RATE {
                dig.frametime -= 5
            }
        }

        if minuspressed {
            if dig.frametime < Digger.MAX_RATE {
                dig.frametime += 5
            }
        }

        if f10pressed {
            escape = true
        }
    }

    func detectjoy() {
        joyflag = false
        staticdir = -1; dynamicdir = -1
    }

    func getasciikey(_ makeConst: Int) -> Int {
        var make = makeConst

        var k: Int = 0

        if (make == " ".charAt(0))
            || ((make >= "a".charAt(0)) && (make <= "z".charAt(0)))
            || ((make >= "0".charAt(0)) && (make <= "9".charAt(0)))
        {
            return make
        } else {
            return 0
        }
    }

    func getdir() -> Int {
        var bp2: Int = keydir

        return bp2
    }

    func initkeyb() {}

    func Key_downpressed() {
        downpressed = true
        dynamicdir = 6; staticdir = 6
    }

    func Key_downreleased() {
        downpressed = false
        if dynamicdir == 6 {
            setdirec()
        }
    }

    func Key_f1pressed() {
        firepressed = true
        f1pressed = true
    }

    func Key_f1released() {
        f1pressed = false
    }

    func Key_leftpressed() {
        leftpressed = true
        dynamicdir = 4; staticdir = 4
    }

    func Key_leftreleased() {
        leftpressed = false
        if dynamicdir == 4 {
            setdirec()
        }
    }

    func Key_rightpressed() {
        rightpressed = true
        dynamicdir = 0; staticdir = 0
    }

    func Key_rightreleased() {
        rightpressed = false
        if dynamicdir == 0 {
            setdirec()
        }
    }

    func Key_uppressed() {
        uppressed = true
        dynamicdir = 2; staticdir = 2
    }

    func Key_upreleased() {
        uppressed = false
        if dynamicdir == 2 {
            setdirec()
        }
    }

    func processkey(_ keyConst: Int) {
        var key = keyConst

        keypressed = key
        if key > 0x80 {
            akeypressed = key & 0x7F
        }

        switch key {
        case 0x4B:
            Key_leftpressed()
        case 0xCB:
            Key_leftreleased()
        case 0x4D:
            Key_rightpressed()
        case 0xCD:
            Key_rightreleased()
        case 0x48:
            Key_uppressed()
        case 0xC8:
            Key_upreleased()
        case 0x50:
            Key_downpressed()
        case 0xD0:
            Key_downreleased()
        case 0x3B:
            Key_f1pressed()
        case 0xBB:
            Key_f1released()
        case 0x78:
            f10pressed = true
        case 0xF8:
            f10pressed = false
        case 0x2B:
            pluspressed = true
        case 0xAB:
            pluspressed = false
        case 0x2D:
            minuspressed = true
        case 0xAD:
            minuspressed = false
        default:
            break
        }
    }

    func readdir() {
        keydir = staticdir
        if dynamicdir != -1 {
            keydir = dynamicdir
        }

        staticdir = -1
        if f1pressed || firepressed {
            firepflag = true
        } else {
            firepflag = false
        }

        firepressed = false
    }

    func readjoy() {}

    func setdirec() {
        dynamicdir = -1
        if uppressed {
            dynamicdir = 2; staticdir = 2
        }

        if downpressed {
            dynamicdir = 6; staticdir = 6
        }

        if leftpressed {
            dynamicdir = 4; staticdir = 4
        }

        if rightpressed {
            dynamicdir = 0; staticdir = 0
        }
    }

    func teststart() -> Bool {
        var startf: Bool = false

        if keypressed != 0, (keypressed & 0x80) == 0, keypressed != 27 {
            startf = true
            joyflag = false
            keypressed = 0
        }

        if !startf {
            return false
        }

        return true
    }
}
