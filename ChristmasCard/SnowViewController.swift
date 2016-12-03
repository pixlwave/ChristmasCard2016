import UIKit
import SpriteKit

class SnowViewController: UIViewController {
    
    var snowScene: SKScene!
    let snowParticlesFile = Bundle.main.path(forResource: "SnowParticles", ofType: "sks")!
    
    @IBOutlet weak var sceneView: SKView!
    @IBOutlet weak var snowflakeOverlayView: UIView!
    @IBOutlet weak var snowflakeImageView: UIImageView!
    @IBOutlet weak var restartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(letItSnow))
        snowflakeOverlayView.addGestureRecognizer(tapRecognizer)
        
        snowflakeImageView.image = Kaleidoscope.lastRender
        setupSnowScene()
    }
    
    func setupSnowScene() {
        snowScene = SKScene(size: sceneView.frame.size)
        snowScene.backgroundColor = SKColor(red: 0.35, green: 0.75, blue: 1.000, alpha: 1.0)
        
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
        restartButton.isHidden = false
    }
    
    @IBAction func restart() {
        presentingViewController?.dismiss(animated: true)
    }
}
