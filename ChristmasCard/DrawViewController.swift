import UIKit

class DrawViewController: UIViewController {
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var okButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(lineDrawn), name: NSNotification.Name(rawValue: "LineDrawn"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(snowflakeDidRender), name: NSNotification.Name(rawValue: "SnowflakeDidRender"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        okButton.isEnabled = false
        drawView.image = Kaleidoscope.lastRender
        NotificationCenter.default.removeObserver(self)
    }
    
    func lineDrawn() {
        okButton.isEnabled = true
    }
    
    @IBAction func renderSnowflake() {
        SVProgressHUD.show(withStatus: "Please wait")
        if let image = drawView.image {
            Kaleidoscope.render(from: image)
        }
    }
    
    func snowflakeDidRender() {
        performSegue(withIdentifier: "SnowSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SnowSegue" {
            SVProgressHUD.dismiss()
        }
    }

    @IBAction func clearDrawing() {
        okButton.isEnabled = false
        drawView.image = nil
        Kaleidoscope.lastRender = nil
    }

}

