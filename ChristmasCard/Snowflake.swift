import UIKit
import SpriteKit

class Snowflake {
    
    static var lastRender: UIImage?
    
    private static let renderQueue = DispatchQueue(label: "SnowflakeCI", qos: .userInitiated)
    private static let ciContext = CIContext()

    private static let kaleidoscopeAngle = 0.125 * Double.pi
    private static let kaleidoscopeCenter = CIVector(x: 0, y: 0)
    private static let transformRotation = CGAffineTransform(rotationAngle: CGFloat(0.375 * Double.pi))
    
    static func render(from sourceImage: UIImage) {
        renderQueue.async {
            let kaleidoscopeFilter = CIFilter(name: "CIKaleidoscope")!
            let transformFilter = CIFilter(name: "CIAffineTransform")!
            
            // FIXME: guard return doesn't post notification
            guard let cgImage = sourceImage.cgImage else { return }
            
            let ciImage = CIImage(cgImage: cgImage)
            kaleidoscopeFilter.setValue(ciImage, forKey: kCIInputImageKey)
            kaleidoscopeFilter.setValue(kaleidoscopeAngle, forKey: kCIInputAngleKey)
            kaleidoscopeFilter.setValue(kaleidoscopeCenter, forKey: kCIInputCenterKey)
            guard let kaleidoscopeOutput = kaleidoscopeFilter.outputImage else { return }
            
            transformFilter.setValue(kaleidoscopeOutput, forKey: "inputImage")
            transformFilter.setValue(transformRotation, forKey: "inputTransform")
            guard let transformOutput = transformFilter.outputImage else { return }
            
            guard let snowflakeCGImage = ciContext.createCGImage(transformOutput, from: sourceImage.size.pythagRect) else { return }
            
            lastRender = UIImage(cgImage: snowflakeCGImage)
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SnowflakeDidRender"), object: nil)
            }
        }
    }
    
    static var texture: SKTexture? {
        guard let lastRender = lastRender else { return nil }
        
        let size = CGSize(width: 64, height: 64)
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        lastRender.draw(in: CGRect(origin: CGPoint.zero, size: size))
        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        
        return SKTexture(image: scaledImage)
    }
    
    static var shareImage: UIImage? {
        guard let lastRender = lastRender else { return nil }
        
        UIGraphicsBeginImageContext(lastRender.size)
        UIColor(red: 0.35, green: 0.75, blue: 1.000, alpha: 1.0).setFill()
        UIRectFill(CGRect(origin: CGPoint.zero, size: lastRender.size))
        lastRender.draw(at: CGPoint.zero)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
