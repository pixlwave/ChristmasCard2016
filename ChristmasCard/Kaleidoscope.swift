import UIKit
import SpriteKit

class Kaleidoscope {
    
    static let ciContext = CIContext()
    static let kaleidoscopeFilter = CIFilter(name: "CIKaleidoscope")!
    static let kaleidoscopeAngle = 0.125 * Double.pi
    static let kaleidoscopeCenter = CIVector(x: 0, y: 0)
    
    static let transformFilter = CIFilter(name: "CIAffineTransform")!
    static let transformRotation = CGAffineTransform(rotationAngle: CGFloat(0.375 * Double.pi))
    
    static var lastRender: UIImage?
    
    static func render(from sourceImage: UIImage) -> UIImage? {
        guard let cgImage = sourceImage.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        kaleidoscopeFilter.setValue(ciImage, forKey: kCIInputImageKey)
        kaleidoscopeFilter.setValue(kaleidoscopeAngle, forKey: kCIInputAngleKey)
        kaleidoscopeFilter.setValue(kaleidoscopeCenter, forKey: kCIInputCenterKey)
        guard let kaleidoscopeOutput = kaleidoscopeFilter.outputImage else { return nil }
        
        transformFilter.setValue(kaleidoscopeOutput, forKey: "inputImage")
        transformFilter.setValue(transformRotation, forKey: "inputTransform")
        guard let transformOutput = transformFilter.outputImage else { return nil }
        
        guard let resultCGImage = ciContext.createCGImage(transformOutput, from: sourceImage.size.pythagRect) else { return nil }
        
        lastRender = UIImage(cgImage: resultCGImage)
        
        return lastRender
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
    
}
