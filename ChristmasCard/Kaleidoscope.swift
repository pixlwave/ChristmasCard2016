import UIKit
import SpriteKit

class Kaleidoscope {
    
    static var ciContext = CIContext()
    static var ciFilter = CIFilter(name: "CIKaleidoscope")!
    
    static var lastRender: UIImage?
    
    static func render(from sourceImage: UIImage) -> UIImage? {
        guard let cgImage = sourceImage.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        let center = CIVector(x: sourceImage.size.width / 2, y: sourceImage.size.height / 2)
        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        ciFilter.setValue(55, forKey: kCIInputAngleKey)
        ciFilter.setValue(center, forKey: kCIInputCenterKey)
        
        guard let outputImage = ciFilter.outputImage else { return nil }
        guard let resultCGImage = ciContext.createCGImage(outputImage, from: ciImage.extent) else { return nil }
        
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
