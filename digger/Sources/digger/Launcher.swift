import Foundation
import GdkPixbuf
import Gtk

@main
enum Launcher {
    static func main() {
        let status = Application.run(startupHandler: nil) { app in
            let pgtk = GtkDigger(nil)
            let game = Digger(pgtk)
            pgtk._digger = game
            pgtk.set_focusable(true)
            game.´init´()
            game.start()

            let win = ApplicationWindowRef(application: app)
            win.title = "Digger Remastered"
            win.onDestroy { _ in
                mainQuit()
            }
            let w = Int(Double(game.width) * 4.03)
            let h = Int(Double(game.height) * 4.15)
            win.setDefaultSize(width: w, height: h)
            win.set(position: WindowPosition.center)

            let icon = GtkResources.LoadDiggerIcon()
            win.set(icon: icon)

            win.add(widget: pgtk.area)
            win.showAll()

            win.onKeyPressEvent(handler: Keyboard.Press(game))
            win.onKeyReleaseEvent(handler: Keyboard.Release(game))
        }

        guard let status = status else {
            fatalError("Unable to create window!")
        }

        guard status == 0 else {
            fatalError("Application exited with status \(status)")
        }
    }
}
