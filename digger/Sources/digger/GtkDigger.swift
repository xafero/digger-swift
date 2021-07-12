import Cairo
import CCairo
import Gtk

class GtkDigger {
    var area: DrawingArea
    var _digger: Digger?

    init(_ digger: Digger?) {
        _digger = digger
        area = DrawingArea()
        area.onDraw(handler: on_drawn)
    }

    func set_focusable(_: Bool) {}

    func on_drawn(_ _: WidgetRef, _ g: ContextRef) -> Bool {
        // width = da.get_allocated_width()
        // height = da.get_allocated_height()

        g.setSource(red: 0, green: 0, blue: 0)
        g.rectangle(x: 0, y: 0, width: 3840, height: 2160)
        g.fill()

        let pc = _digger!.Pc!

        let w = pc.width
        let h = pc.height
        let data = pc.pixels

        if let model = pc.currentSource.Model {
            let shift = 1.0
            let scale = 4.0

            for x in 0 ... w {
                for y in 0 ... h {
                    let array_index = y * w + x
                    let (sr, sg, sb) = model.get_color(data[array_index])
                    g.setSource(red: sr, green: sg, blue: sb)
                    let rx = shift + (Double(x) * scale)
                    let ry = shift + (Double(y) * scale)
                    g.rectangle(x: rx, y: ry, width: scale, height: scale)
                    g.fill()
                }
            }
        }

        return false
    }

    func do_key_up(_ key: Int) -> Bool {
        return _digger!.keyUp(key)
    }

    func do_key_down(_ key: Int) -> Bool {
        return _digger!.keyDown(key)
    }

    func create_refresher(_: Digger, _ model: IndexColorModel) -> GtkRefresher {
        return GtkRefresher(self, model)
    }

    func requestFocus() {}

    func setFocusable(_: Bool) {}

    func getSubmitParameter() -> String {
        return ""
    }

    func getSpeedParameter() -> Int {
        return 66
    }
}
