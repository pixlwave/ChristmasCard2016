import UIKit

class DrawViewController: UIViewController {
    @IBOutlet weak var drawView: DrawView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func clearDrawing(_ sender: Any) {
        drawView.image = nil
        Kaleidoscope.lastRender = nil
    }

}

