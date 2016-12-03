import SceneKit

class SnowflakeScene: SCNScene {
    
    init(image: UIImage) {
        super.init()
        
        let snowflakePlaneFront = SCNPlane(width: 0.9, height: 0.9)
        snowflakePlaneFront.firstMaterial?.diffuse.contents = Kaleidoscope.lastRender
        let snowflakeFrontNode = SCNNode(geometry: snowflakePlaneFront)
        
        let snowflakePlaneBack = SCNPlane(width: 0.9, height: 0.9)
        snowflakePlaneBack.firstMaterial?.diffuse.contents = Kaleidoscope.lastRender
        let snowflakeBackNode = SCNNode(geometry: snowflakePlaneBack)
        snowflakeBackNode.eulerAngles.y = Float.pi
        
        rootNode.addChildNode(snowflakeFrontNode)
        rootNode.addChildNode(snowflakeBackNode)
        
        let rotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat.pi, z: 0, duration: 2.5))
        rootNode.runAction(rotateAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
