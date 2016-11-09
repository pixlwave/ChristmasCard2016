import UIKit

class DrawView: UIImageView {
    
    var lastPoint = CGPoint.zero
    var brushColor = UIColor.white.cgColor
    var brushWidth: CGFloat = 25
    var swiped = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        brushWidth = frame.size.retinaSize.width / 24
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            drawLine(from: lastPoint, to: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLine(from: lastPoint, to: lastPoint)
        } else {
            if let image = image, let kaleidoscope = Kaleidoscope.render(from: image) {
                self.image = kaleidoscope
            }
        }
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(bounds.size.retinaSize)
        
        if let context = UIGraphicsGetCurrentContext() {
            image?.draw(in: bounds.retinaRect)
            
            context.move(to: fromPoint.retinaPoint)
            context.addLine(to: toPoint.retinaPoint)
            
            context.setLineCap(.round)
            context.setLineWidth(brushWidth)
            context.setStrokeColor(brushColor)
            context.setBlendMode(.normal)
            
            context.strokePath()
            
            image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
        }
    }
    
}
