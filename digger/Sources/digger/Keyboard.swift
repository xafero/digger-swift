import Gdk
import Glibc
import Gtk

enum Keyboard {
    static func Press(_ d: Digger) -> ((WidgetRef, EventKeyRef) -> Bool) {
        return { _, ev in
            let key_event = ev.keyval
            let num = Keyboard.convert_to_legacy(key_event)
            if num >= 0 {
                d.keyDown(Int(num))
            }
            return true
        }
    }

    static func Release(_ d: Digger) -> ((WidgetRef, EventKeyRef) -> Bool) {
        return { _, ev in
            let key_event = ev.keyval
            let num = Keyboard.convert_to_legacy(key_event)
            if num >= 0 {
                d.keyUp(Int(num))
            }
            return true
        }
    }

    static func convert_to_legacy(_ net_code: UInt32) -> UInt32 {
        switch net_code {
        case 65362: return 1004 // UP
        case 65364: return 1005 // DOWN
        case 65361: return 1006 // LEFT
        case 65363: return 1007 // RIGHT
        case 65470: return 1008 // F1
        case 65479: return 1021 // F10
        case 65451: return 1031 // PLUS
        case 65453: return 1032 // MINUS
        default: break
        }
        return net_code
    }
}
