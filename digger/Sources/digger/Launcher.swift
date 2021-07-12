import Foundation
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

            // let icon = gtkcore.LoadGtkImage("icons/digger.png")
            // win.SetIcon(icon)

            win.add(widget: pgtk.area)
            win.showAll()

            win.onKeyPressEvent(handler: K.Press(game))
            win.onKeyReleaseEvent(handler: K.Release(game))
        }

        guard let status = status else {
            fatalError("Unable to create window!")
        }

        guard status == 0 else {
            fatalError("Application exited with status \(status)")
        }
    }
}
