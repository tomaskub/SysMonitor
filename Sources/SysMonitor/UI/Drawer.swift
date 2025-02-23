import Termbox

protocol Drawing: AnyObject {
    func draw(message: String)
    func prepareForDrawing()
}

class Drawer: Drawing {

init() {
        prepareForDrawing()
    }

    func draw(message: String) {
        let size = getSize()
        let centerY = size.height / 2
        let centerX = size.width / 2
        for (c, x) in zip(message, centerX ..< size.width) {
            printChatAt(x: x, y: centerY, c: c)
        }
        Termbox.present()
    }

    func prepareForDrawing() {
        initializeTermbox()
    }

    private func initializeTermbox() {
        do {
            try Termbox.initialize()
        } catch let error {
            print("Error while initializing termbox: \(error) - \(error.localizedDescription)")
        }
    }

    private func getSize() -> Size {
        Size(width: Termbox.width,
            height: Termbox.height)
    }

    private func printChatAt(x: Int32,
        y: Int32,
        c: Character) {
        guard let unicodeChar = UnicodeScalar.init(String(c)) else { return }
        Termbox.put(x: x, y: y, character: unicodeChar)
    }
}

struct Size {
    let width: Int32
    let height: Int32
}
