import UIKit
import SpriteKit
import SceneKit
import AVFoundation

class SnowViewController: UIViewController {
    
    var snowScene: SKScene!
    let snowParticlesFile = Bundle.main.path(forResource: "SnowParticles", ofType: "sks")!
    let topLabelNode = SKLabelNode(text: "Wishing you a")
    let bottomLabelNode = SKLabelNode(text: "Merry Christmas")
    let messageNode = SKNode()
    var labelScriptIndex = 0
    var labelActionSequence = SKAction()
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
        snowScene.scaleMode = .aspectFill   // probably not needed now
        
        topLabelNode.position = CGPoint(x: 0, y: snowSceneView.frame.width / 17.5)
        topLabelNode.fontSize = snowSceneView.frame.width / 14
        messageNode.addChild(topLabelNode)
        
        bottomLabelNode.position = CGPoint(x: 0, y: snowSceneView.frame.width / -21)
        bottomLabelNode.fontSize = snowSceneView.frame.width / 10.5
        messageNode.addChild(bottomLabelNode)
        
        messageNode.position = CGPoint(x: snowScene.frame.midX, y: snowScene.frame.midY)
        messageNode.alpha = 0
        snowScene.addChild(messageNode)
        
        let waitAction = SKAction.wait(forDuration: 9)
        let fadeInAction = SKAction.fadeIn(withDuration: 2)
        let holdAction = SKAction.wait(forDuration: 3)
        let fadeOutAction = SKAction.fadeOut(withDuration: 2)
        let changeTextAction = SKAction.run { self.updateText() }
        let pauseAction = SKAction.wait(forDuration: 1)
        
        labelActionSequence = SKAction.sequence([
            waitAction,
            fadeInAction,
            holdAction,
            fadeOutAction,
            changeTextAction,
            pauseAction,
            fadeInAction,
            holdAction,
            fadeOutAction,
            changeTextAction,
            pauseAction,
            fadeInAction,
            holdAction,
            fadeOutAction
        ])
    }
    
    func letItSnow() {
        snowflakeOverlayView.removeFromSuperview()
        
        if let snowParticles = NSKeyedUnarchiver.unarchiveObject(withFile: snowParticlesFile) as? SKEmitterNode {
            snowParticles.position = CGPoint(x: snowScene.frame.midX, y: snowScene.frame.height + 20)
            snowParticles.name = "snowParticles"
            snowParticles.targetNode = snowScene
            snowParticles.particlePositionRange.dx = snowSceneView.frame.width
            snowParticles.particleBirthRate = 3
            
            if let snowFlakeTexture = Kaleidoscope.texture {
                snowParticles.particleTexture = snowFlakeTexture
            }
            
            if snowSceneView.frame.height > 750 {
                snowParticles.particleLifetime = 12
            }
            
            let snowBuildUpAction = SKAction.sequence([
                SKAction.wait(forDuration: 1),
                SKAction.run {
                    snowParticles.particleBirthRate += self.snowSceneView.frame.width / 70
                }
            ])
            
            snowParticles.run(SKAction.repeat(snowBuildUpAction, count: 7))
            
            snowScene.addChild(snowParticles)
        }
        
        messageNode.run(labelActionSequence)
        
        snowSceneView.presentScene(snowScene)
        musicPlayer.play()
        AppDelegate.hasSeenSnow = true
        restartButton.isHidden = false
    }
    
    func updateText() {
        switch labelScriptIndex {
        case 0:
            topLabelNode.text = "and a"
            bottomLabelNode.text = "Happy New Year"
        case 1:
            topLabelNode.text = "from"
            bottomLabelNode.text = "Doug"
        default:
            break
        }
        
        labelScriptIndex += 1
    }
    
    @IBAction func restart() {
        musicPlayer.pause()
        presentingViewController?.dismiss(animated: true)
    }
}
