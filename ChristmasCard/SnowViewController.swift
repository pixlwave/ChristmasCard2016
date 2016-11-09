import UIKit
import SpriteKit

class SnowViewController: UIViewController {
    
    var snowScene: SKScene!
    
    @IBOutlet weak var sceneView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        snowScene = SKScene(size: sceneView.frame.size)
        snowScene.backgroundColor = SKColor(red: 0.35, green: 0.75, blue: 1.000, alpha: 1.0)
        
        let snowParticlesPath = Bundle.main.path(forResource: "SnowParticles", ofType: "sks")
        let snowParticles = NSKeyedUnarchiver.unarchiveObject(withFile: snowParticlesPath!) as? SKEmitterNode
        snowParticles?.position = CGPoint(x: snowScene.frame.midX, y: snowScene.frame.height)
        snowParticles?.name = "snowParticles"
        snowParticles?.targetNode = snowScene
        if let snowFlake = Kaleidoscope.texture {
            snowParticles?.particleTexture = snowFlake
        }
        snowScene.addChild(snowParticles!)
        
        sceneView.presentScene(snowScene)
    }
    
    @IBAction func restart() {
        presentingViewController?.dismiss(animated: true)
    }
}
