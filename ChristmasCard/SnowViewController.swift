import UIKit
import SpriteKit
import SceneKit
import AVFoundation

class SnowViewController: UIViewController {
    
    var snowScene: SKScene!
    let snowParticlesFile = Bundle.main.path(forResource: "SnowParticles", ofType: "sks")!
    let blueBackground = SKColor(red: 0.35, green: 0.75, blue: 1.000, alpha: 1.0)
    let musicPlayer = AVPlayer(url: Bundle.main.url(forResource: "Jingle Bells", withExtension: "m4a")!)
    
    @IBOutlet weak var sceneView: SKView!
    @IBOutlet weak var snowflakeOverlayView: UIView!
    @IBOutlet weak var snowflakeSceneView: SCNView!
    @IBOutlet weak var restartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(letItSnow))
        snowflakeOverlayView.addGestureRecognizer(tapRecognizer)
        snowflakeOverlayView.backgroundColor = blueBackground
        
        if let snowflakeImage = Kaleidoscope.lastRender {
            snowflakeSceneView.scene = SnowflakeScene(image: snowflakeImage)
            snowflakeSceneView.scene?.background.contents = blueBackground
        }
        
        setupSnowScene()
    }
    
    func setupSnowScene() {
        snowScene = SKScene(size: sceneView.frame.size)
        snowScene.backgroundColor = blueBackground
        
        let happyChristmas = SKLabelNode(text: "Happy Christmas")
        happyChristmas.position = CGPoint(x: snowScene.frame.midX, y: snowScene.frame.midY)
        snowScene.addChild(happyChristmas)
    }
    
    func letItSnow() {
        snowflakeOverlayView.removeFromSuperview()
        
        if let snowParticles = NSKeyedUnarchiver.unarchiveObject(withFile: snowParticlesFile) as? SKEmitterNode {
            snowParticles.position = CGPoint(x: snowScene.frame.midX, y: snowScene.frame.height)
            snowParticles.name = "snowParticles"
            snowParticles.targetNode = snowScene
            
            if let snowFlakeTexture = Kaleidoscope.texture {
                snowParticles.particleTexture = snowFlakeTexture
            }
            
            snowScene.addChild(snowParticles)
        }
        
        sceneView.presentScene(snowScene)
        musicPlayer.play()
        restartButton.isHidden = false
    }
    
    @IBAction func restart() {
        presentingViewController?.dismiss(animated: true)
    }
}
