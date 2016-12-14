import UIKit
import SpriteKit

extension CGPoint {
    var retinaPoint: CGPoint {
        return CGPoint(x: x * UIScreen.main.scale, y: y * UIScreen.main.scale)
    }
}

extension CGSize {
    var retinaSize: CGSize {
        return CGSize(width: width * UIScreen.main.scale, height: height * UIScreen.main.scale)
    }
    
    var pythagRect: CGRect {
        let pythag = sqrt(Double((width * width) + (height * height)))
        return CGRect(origin: CGPoint(x: -pythag, y: -pythag), size: CGSize(width: pythag * 2, height: pythag * 2))
    }
}

extension CGRect {
    var retinaRect: CGRect {
        return CGRect(origin: origin.retinaPoint, size: size.retinaSize)
    }
}

extension SKColor {
    static let blueBackground = SKColor(red: 0.35, green: 0.75, blue: 1.000, alpha: 1.0)
}
