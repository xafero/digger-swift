
import Foundation

class Sound {
    var dig: Digger

    var wavetype: Int = 0

    var t2val: Int = 0

    var t0val: Int = 0

    var musvol: Int = 0

    var spkrmode: Int = 0

    var timerrate: Int = 0x7D0

    var timercount: Int = 0

    var pulsewidth: Int = 1

    var volume: Int = 0

    var timerclock: Int = 0

    var soundflag: Bool = true

    var musicflag: Bool = true

    var sndflag: Bool = false

    var soundpausedflag: Bool = false

    var soundlevdoneflag: Bool = false

    var nljpointer: Int = 0

    var nljnoteduration: Int = 0

    var newlevjingle: [Int] = [0x8E8, 0x712, 0x5F2, 0x7F0, 0x6AC, 0x54C, 0x712, 0x5F2, 0x4B8, 0x474, 0x474]

    var soundfallflag: Bool = false

    var soundfallf: Bool = false

    var soundfallvalue: Int = 0

    var soundfalln: Int = 0

    var soundbreakflag: Bool = false

    var soundbreakduration: Int = 0

    var soundbreakvalue: Int = 0

    var soundwobbleflag: Bool = false

    var soundwobblen: Int = 0

    var soundfireflag: Bool = false

    var soundfirevalue: Int = 0

    var soundfiren: Int = 0

    var soundexplodeflag: Bool = false

    var soundexplodevalue: Int = 0

    var soundexplodeduration: Int = 0

    var soundbonusflag: Bool = false

    var soundbonusn: Int = 0

    var soundemflag: Bool = false

    var soundemeraldflag: Bool = false

    var soundemeraldduration: Int = 0

    var emerfreq: Int = 0

    var soundemeraldn: Int = 0

    var soundgoldflag: Bool = false

    var soundgoldf: Bool = false

    var soundgoldvalue1: Int = 0

    var soundgoldvalue2: Int = 0

    var soundgoldduration: Int = 0

    var soundeatmflag: Bool = false

    var soundeatmvalue: Int = 0

    var soundeatmduration: Int = 0

    var soundeatmn: Int = 0

    var soundddieflag: Bool = false

    var soundddien: Int = 0

    var soundddievalue: Int = 0

    var sound1upflag: Bool = false

    var sound1upduration: Int = 0

    var musicplaying: Bool = false

    var musicp: Int = 0

    var tuneno: Int = 0

    var noteduration: Int = 0

    var notevalue: Int = 0

    var musicmaxvol: Int = 0

    var musicattackrate: Int = 0

    var musicsustainlevel: Int = 0

    var musicdecayrate: Int = 0

    var musicnotewidth: Int = 0

    var musicreleaserate: Int = 0

    var musicstage: Int = 0

    var musicn: Int = 0

    var soundt0flag: Bool = false

    var int8flag: Bool = false

    init(_ dConst: Digger) {
        var d = dConst

        dig = d
    }

    func initsound() {
        wavetype = 2
        t0val = 12000
        musvol = 8
        t2val = 40
        soundt0flag = true
        sndflag = true
        spkrmode = 0
        int8flag = false
        setsoundt2()
        soundstop()
        startint8()
        timerrate = 0x4000
    }

    func killsound() {}

    func music(_ tuneConst: Int) {
        var tune = tuneConst

        tuneno = tune
        musicp = 0
        noteduration = 0
        switch tune {
        case 0:
            musicmaxvol = 50
            musicattackrate = 20
            musicsustainlevel = 20
            musicdecayrate = 10
            musicreleaserate = 4
        case 1:
            musicmaxvol = 50
            musicattackrate = 50
            musicsustainlevel = 8
            musicdecayrate = 15
            musicreleaserate = 1
        case 2:
            musicmaxvol = 50
            musicattackrate = 50
            musicsustainlevel = 25
            musicdecayrate = 5
            musicreleaserate = 1
        default:
            break
        }

        musicplaying = true
        if tune == 2 {
            soundddieoff()
        }
    }

    func musicoff() {
        musicplaying = false
        musicp = 0
    }

    func musicupdate() {
        if !musicplaying {
            return
        }

        if noteduration != 0 {
            noteduration -= 1
        } else {
            musicstage = 0; musicn = 0
            switch tuneno {
            case 0:
                musicnotewidth = noteduration - 3
                musicp += 2
            case 1:
                musicnotewidth = 12
                musicp += 2
            case 2:
                musicnotewidth = noteduration - 10
                musicp += 2
            default:
                break
            }
        }

        musicn += 1
        wavetype = 1
        t0val = notevalue
        if musicn >= musicnotewidth {
            musicstage = 2
        }

        switch musicstage {
        case 0:
            if musvol + musicattackrate >= musicmaxvol {
                musicstage = 1
                musvol = musicmaxvol
                break
            }

            musvol += musicattackrate
        case 1:
            if musvol - musicdecayrate <= musicsustainlevel {
                musvol = musicsustainlevel
                break
            }

            musvol -= musicdecayrate
        case 2:
            if musvol - musicreleaserate <= 1 {
                musvol = 1
                break
            }

            musvol -= musicreleaserate
        default:
            break
        }

        if musvol == 1 {
            t0val = 0x7D00
        }
    }

    func s0fillbuffer() {}

    func s0killsound() {
        setsoundt2()
        stopint8()
    }

    func s0setupsound() {
        startint8()
    }

    func setsoundmode() {
        spkrmode = wavetype
        if !soundt0flag, sndflag {
            soundt0flag = true
        }
    }

    func setsoundt2() {
        if soundt0flag {
            spkrmode = 0
            soundt0flag = false
        }
    }

    func sett0() {
        if sndflag {
            if t0val < 1000, wavetype == 1 || wavetype == 2 {
                t0val = 1000
            }

            timerrate = t0val
            if musvol < 1 {
                musvol = 1
            }

            if musvol > 50 {
                musvol = 50
            }

            pulsewidth = musvol * volume
            setsoundmode()
        }
    }

    func sett2val(_ t2vConst: Int) {
        var t2v = t2vConst
    }

    func setupsound() {}

    func sound1up() {
        sound1upduration = 96
        sound1upflag = true
    }

    func sound1upoff() {
        sound1upflag = false
    }

    func sound1upupdate() {
        if sound1upflag {
            if (sound1upduration / 3) % 2 != 0 {
                t2val = ((sound1upduration << 2) + 600)
            }

            sound1upduration -= 1
            if sound1upduration < 1 {
                sound1upflag = false
            }
        }
    }

    func soundbonus() {
        soundbonusflag = true
    }

    func soundbonusoff() {
        soundbonusflag = false
        soundbonusn = 0
    }

    func soundbonusupdate() {
        if soundbonusflag {
            soundbonusn += 1
            if soundbonusn > 15 {
                soundbonusn = 0
            }

            if soundbonusn >= 0, soundbonusn < 6 {
                t2val = 0x4CE
            }

            if soundbonusn >= 8, soundbonusn < 14 {
                t2val = 0x5E9
            }
        }
    }

    func soundbreak() {
        soundbreakduration = 3
        if soundbreakvalue < 15000 {
            soundbreakvalue = 15000
        }

        soundbreakflag = true
    }

    func soundbreakoff() {
        soundbreakflag = false
    }

    func soundbreakupdate() {
        if soundbreakflag {
            if soundbreakduration != 0 {
                soundbreakduration -= 1
                t2val = soundbreakvalue
            } else {
                soundbreakflag = false
            }
        }
    }

    func soundddie() {
        soundddien = 0
        soundddievalue = 20000
        soundddieflag = true
    }

    func soundddieoff() {
        soundddieflag = false
    }

    func soundddieupdate() {
        if soundddieflag {
            soundddien += 1
            if soundddien == 1 {
                musicoff()
            }

            if soundddien >= 1, soundddien <= 10 {
                soundddievalue = 20000 - soundddien * 1000
            }

            if soundddien > 10 {
                soundddievalue += 500
            }

            if soundddievalue > 30000 {
                soundddieoff()
            }

            t2val = (soundddievalue)
        }
    }

    func soundeatm() {
        soundeatmduration = 20
        soundeatmn = 3
        soundeatmvalue = 2000
        soundeatmflag = true
    }

    func soundeatmoff() {
        soundeatmflag = false
    }

    func soundeatmupdate() {
        if soundeatmflag {
            if soundeatmn != 0 {
                if soundeatmduration != 0 {
                    if (soundeatmduration % 4) == 1 {
                        t2val = (soundeatmvalue)
                    }

                    if (soundeatmduration % 4) == 3 {
                        t2val = (soundeatmvalue - (soundeatmvalue >> 4))
                    }

                    soundeatmduration -= 1
                    soundeatmvalue -= (soundeatmvalue >> 4)
                } else {
                    soundeatmduration = 20
                    soundeatmn -= 1
                    soundeatmvalue = 2000
                }
            } else {
                soundeatmflag = false
            }
        }
    }

    func soundem() {
        soundemflag = true
    }

    func soundemerald(_ emocttimeConst: Int) {
        var emocttime = emocttimeConst

        if emocttime != 0 {
            switch emerfreq {
            case 0x8E8:
                emerfreq = 0x7F0
            case 0x7F0:
                emerfreq = 0x712
            case 0x712:
                emerfreq = 0x6AC
            case 0x6AC:
                emerfreq = 0x5F2
            case 0x5F2:
                emerfreq = 0x54C
            case 0x54C:
                emerfreq = 0x4B8
            case 0x4B8:
                emerfreq = 0x474
                dig.Scores!.scoreoctave()
            case 0x474:
                emerfreq = 0x8E8
            default:
                break
            }
        } else {
            emerfreq = 0x8E8
        }

        soundemeraldduration = 7
        soundemeraldn = 0
        soundemeraldflag = true
    }

    func soundemeraldoff() {
        soundemeraldflag = false
    }

    func soundemeraldupdate() {
        if soundemeraldflag {
            if soundemeraldduration != 0 {
                if soundemeraldn == 0 || soundemeraldn == 1 {
                    t2val = (emerfreq)
                }

                soundemeraldn += 1
                if soundemeraldn > 7 {
                    soundemeraldn = 0
                    soundemeraldduration -= 1
                }
            } else {
                soundemeraldoff()
            }
        }
    }

    func soundemoff() {
        soundemflag = false
    }

    func soundemupdate() {
        if soundemflag {
            t2val = 1000
            soundemoff()
        }
    }

    func soundexplode() {
        soundexplodevalue = 1500
        soundexplodeduration = 10
        soundexplodeflag = true
        soundfireoff()
    }

    func soundexplodeoff() {
        soundexplodeflag = false
    }

    func soundexplodeupdate() {
        if soundexplodeflag {
            if soundexplodeduration != 0 {
                soundexplodevalue = soundexplodevalue - (soundexplodevalue >> 3); 
                t2val = (soundexplodevalue - (soundexplodevalue >> 3))
                soundexplodeduration -= 1
            } else {
                soundexplodeflag = false
            }
        }
    }

    func soundfall() {
        soundfallvalue = 1000
        soundfallflag = true
    }

    func soundfalloff() {
        soundfallflag = false
        soundfalln = 0
    }

    func soundfallupdate() {
        if soundfallflag {
            if soundfalln < 1 {
                soundfalln += 1
                if soundfallf {
                    t2val = (soundfallvalue)
                }
            } else {
                soundfalln = 0
                if soundfallf {
                    soundfallvalue += 50
                    soundfallf = false
                } else {
                    soundfallf = true
                }
            }
        }
    }

    func soundfire() {
        soundfirevalue = 500
        soundfireflag = true
    }

    func soundfireoff() {
        soundfireflag = false
        soundfiren = 0
    }

    func soundfireupdate() {
        if soundfireflag {
            if soundfiren == 1 {
                soundfiren = 0
                soundfirevalue += soundfirevalue / 55
                t2val = (soundfirevalue + dig.Main!.randno(soundfirevalue >> 3))
                if soundfirevalue > 30000 {
                    soundfireoff()
                }
            } else {
                soundfiren += 1
            }
        }
    }

    func soundgold() {
        soundgoldvalue1 = 500
        soundgoldvalue2 = 4000
        soundgoldduration = 30
        soundgoldf = false
        soundgoldflag = true
    }

    func soundgoldoff() {
        soundgoldflag = false
    }

    func soundgoldupdate() {
        if soundgoldflag {
            if soundgoldduration != 0 {
                soundgoldduration -= 1
            } else {
                soundgoldflag = false
            }

            if soundgoldf {
                soundgoldf = false
                t2val = (soundgoldvalue1)
            } else {
                soundgoldf = true
                t2val = (soundgoldvalue2)
            }

            soundgoldvalue1 += (soundgoldvalue1 >> 4)
            soundgoldvalue2 -= (soundgoldvalue2 >> 4)
        }
    }

    func soundint() {
        timerclock += 1
        if soundflag, !sndflag {
            sndflag = true; musicflag = true
        }

        if !soundflag, sndflag {
            sndflag = false
            setsoundt2()
        }

        if sndflag, !soundpausedflag {
            t0val = 0x7D00
            t2val = 40
            if musicflag {
                musicupdate()
            }

            soundemeraldupdate()
            soundwobbleupdate()
            soundddieupdate()
            soundbreakupdate()
            soundgoldupdate()
            soundemupdate()
            soundexplodeupdate()
            soundfireupdate()
            soundeatmupdate()
            soundfallupdate()
            sound1upupdate()
            soundbonusupdate()
            if t0val == 0x7D00 || t2val != 40 {
                setsoundt2()
            } else {
                setsoundmode()
                sett0()
            }

            sett2val(Int(t2val))
        }
    }

    func soundlevdone() {
        ThreadX.sleep(1000)
    }

    func soundlevdoneoff() {
        soundlevdoneflag = false; soundpausedflag = false
    }

    func soundlevdoneupdate() {
        if sndflag {
            if nljpointer < 11 {
                t2val = (newlevjingle[nljpointer])
            }

            t0val = Int(t2val + 35)
            musvol = 50
            setsoundmode()
            sett0()
            sett2val(Int(t2val))
            if nljnoteduration > 0 {
                nljnoteduration -= 1
            } else {
                nljnoteduration = 20
                nljpointer += 1
                if nljpointer > 10 {
                    soundlevdoneoff()
                }
            }
        } else {
            soundlevdoneflag = false
        }
    }

    func soundoff() {}

    func soundpause() {
        soundpausedflag = true
    }

    func soundpauseoff() {
        soundpausedflag = false
    }

    func soundstop() {
        soundfalloff()
        soundwobbleoff()
        soundfireoff()
        musicoff()
        soundbonusoff()
        soundexplodeoff()
        soundbreakoff()
        soundemoff()
        soundemeraldoff()
        soundgoldoff()
        soundeatmoff()
        soundddieoff()
        sound1upoff()
    }

    func soundwobble() {
        soundwobbleflag = true
    }

    func soundwobbleoff() {
        soundwobbleflag = false
        soundwobblen = 0
    }

    func soundwobbleupdate() {
        if soundwobbleflag {
            soundwobblen += 1
            if soundwobblen > 63 {
                soundwobblen = 0
            }

            switch soundwobblen {
            case 0:
                t2val = 0x7D0
            case 16, 48:
                t2val = 0x9C4
            case 32:
                t2val = 0xBB8
            default:
                break
            }
        }
    }

    func startint8() {
        if !int8flag {
            timerrate = 0x4000
            int8flag = true
        }
    }

    func stopint8() {
        if int8flag {
            int8flag = false
        }

        sett2val(40)
    }
}
