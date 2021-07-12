import Foundation
import Gdk
import GdkPixbuf
import GLib
import Gtk

class GtkResources {
    static func LoadDiggerIcon() -> Pixbuf {
        let fn = "Assets/Icons/digger.png"
        let fileManager = FileManager.default
        let dir = fileManager.currentDirectoryPath
        let full = dir + "/" + fn

        do {
            let img = try GdkPixbuf.Pixbuf.newFrom(file: full)
            let icon = img!
            return icon
        } catch {
            print(error)
        }

        abort()
    }
}
