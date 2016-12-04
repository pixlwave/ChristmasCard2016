import UIKit
import SpriteKit
import SceneKit
import AVFoundation

class SnowViewController: UIViewController {
    
    var snowScene: SKScene!
    let snowParticlesFile = Bundle.main.path(forResource: "SnowParticles", ofType: "sks")!
    let blueBackground = SKColor(red: 0.35, green: 0.75, blue: 1.000, alpha: 1.0)
    let musicPlayer = AVPlayer(url: Bundle.main.url(forResource: "Jingle Bells", withExtension: "m4a")!)
    
    @IBOutlet weak var snowSceneView: SKView!
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
        
        if AppDelegate.hasSeenSnow { restartButton.isHidden = false }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSnowScene()    // after view has been layed out
    }
    
    func setupSnowScene() {
        snowScene = SKScene(size: snowSceneView.frame.size)
        snowScene.backgroundColor = blueBackground
        snowScene.scaleMode = .aspectFill
        
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
            snowParticles.particlePositionRange.dx = snowSceneView.frame.width
            snowParticles.particleBirthRate = snowSceneView.frame.width / 10
            
            if let snowFlakeTexture = Kaleidoscope.texture {
                snowParticles.particleTexture = snowFlakeTexture
            }
            
            if snowSceneView.frame.height > 750 {
                snowParticles.particleLifetime = 12
            }
            
            snowScene.addChild(snowParticles)
        }
        
        snowSceneView.presentScene(snowScene)
        musicPlayer.play()
        AppDelegate.hasSeenSnow = true
        restartButton.isHidden = false
    }
    
    @IBAction func restart() {
        musicPlayer.pause()
        presentingViewController?.dismiss(animated: true)
    }
}
