import SpriteKit
import AVFoundation

class SnowScene: SKScene {
    
    let snowParticlesFile = Bundle.main.path(forResource: "SnowParticles", ofType: "sks")!
    let topLabelNode = SKLabelNode(text: "Wishing you a")
    let bottomLabelNode = SKLabelNode(text: "Merry Christmas")
    let messageNode = SKNode()
    var labelScriptIndex = 0
    var labelActionSequence = SKAction()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.blueBackground
        scaleMode = .aspectFill   // probably not needed now
        
        let landscapeNode = SKSpriteNode(imageNamed: "background")
        landscapeNode.size = CGSize(width: frame.height / 9 * 16, height: frame.height)     // TODO: use ipad specific image
        landscapeNode.position = CGPoint(x: frame.midX, y: frame.midY)
        
        addChild(landscapeNode)
        
        topLabelNode.position = CGPoint(x: 0, y: frame.width / 17.5)
        topLabelNode.fontSize = frame.width / 14
        messageNode.addChild(topLabelNode)
        
        bottomLabelNode.position = CGPoint(x: 0, y: frame.width / -21)
        bottomLabelNode.fontSize = frame.width / 10.5
        messageNode.addChild(bottomLabelNode)
        
        messageNode.position = CGPoint(x: frame.midX, y: frame.midY)
        messageNode.alpha = 0
        addChild(messageNode)
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func letItSnow() {
        if let snowParticles = NSKeyedUnarchiver.unarchiveObject(withFile: snowParticlesFile) as? SKEmitterNode {
            snowParticles.position = CGPoint(x: frame.midX, y: frame.height + 20)
            snowParticles.name = "snowParticles"
            snowParticles.targetNode = self
            snowParticles.particlePositionRange.dx = frame.width
            snowParticles.particleBirthRate = 3
            
            if let snowFlakeTexture = Snowflake.texture {
                snowParticles.particleTexture = snowFlakeTexture
            }
            
            if frame.height > 750 {
                snowParticles.particleLifetime = 12
            }
            
            let snowBuildUpAction = SKAction.sequence([
                SKAction.wait(forDuration: 1),
                SKAction.run {
                    snowParticles.particleBirthRate += self.frame.width / 70
                }
            ])
            
            snowParticles.run(SKAction.repeat(snowBuildUpAction, count: 7))
            
            addChild(snowParticles)
        }
        
        messageNode.run(labelActionSequence)
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
    
}
