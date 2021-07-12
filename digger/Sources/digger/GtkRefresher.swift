import GLib
import Gtk

class GtkRefresher {
    static var _area: GtkDigger?
    var Model: ColorModel?

    init(_ area: GtkDigger, _ model: ColorModel) {
        GtkRefresher._area = area
        Model = model
    }

    init() {
        Model = nil
    }

    func get_model() -> ColorModel {
        return Model!
    }

    func newPixels(_: Int, _: Int, _: Int, _: Int) {
        newPixels()
    }

    func newPixels() {
        timeout(add: 0) {
            if let d = GtkRefresher._area {
                d.area.queueDraw()
            }
            return false
        }
    }

    func get_color(_ index: Int) -> (Double, Double, Double) {
        return Model!.get_color(index)
    }

    func set_animated(_: Bool) {}
}
