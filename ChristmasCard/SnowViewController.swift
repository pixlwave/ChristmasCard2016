import UIKit
import SpriteKit
import SceneKit
import AVFoundation

class SnowViewController: UIViewController {
    
    var snowScene: SnowScene!
    let musicPlayer = AVPlayer(url: Bundle.main.url(forResource: "Jingle Bells", withExtension: "m4a")!)
    
    @IBOutlet weak var snowSceneView: SKView!
    @IBOutlet weak var snowflakeOverlayView: UIView!
    @IBOutlet weak var snowflakeSceneView: SCNView!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(letItSnow))
        snowflakeOverlayView.addGestureRecognizer(tapRecognizer)
        snowflakeOverlayView.backgroundColor = SKColor.blueBackground
        
        if let snowflakeImage = Snowflake.lastRender {
            snowflakeSceneView.scene = SnowflakeScene(image: snowflakeImage)
            snowflakeSceneView.scene?.background.contents = SKColor.blueBackground
        }
        
        if AppDelegate.hasSeenSnow {
            restartButton.isHidden = false
            shareButton.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.layoutIfNeeded()   // make sure snowSceneView has the correct frame size
        if snowScene == nil { setupSnowScene() }
    }
    
    func setupSnowScene() {
        snowScene = SnowScene(size: snowSceneView.frame.size)
        snowSceneView.presentScene(snowScene)
    }
    
    func letItSnow() {
        snowflakeOverlayView.removeFromSuperview()
        
        snowScene.letItSnow()
        musicPlayer.play()
        
        AppDelegate.hasSeenSnow = true
        restartButton.isHidden = false
        shareButton.isHidden = false
    }
    
    @IBAction func share() {
        if let snowflakeImage = Snowflake.shareImage {
            let activityVC = UIActivityViewController(activityItems: [snowflakeImage, "I've just made my own snowflake using #DougsChrismasCard xmas.pixlwave.uk"], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = shareButton
            present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func restart() {
        musicPlayer.pause()
        presentingViewController?.dismiss(animated: true)
    }
}
