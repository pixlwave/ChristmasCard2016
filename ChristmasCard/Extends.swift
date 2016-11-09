import UIKit

extension CGPoint {
    var retinaPoint: CGPoint {
        return CGPoint(x: x * UIScreen.main.scale, y: y * UIScreen.main.scale)
    }
}

extension CGSize {
    var retinaSize: CGSize {
        return CGSize(width: width * UIScreen.main.scale, height: height * UIScreen.main.scale)
    }
}

extension CGRect {
    var retinaRect: CGRect {
        return CGRect(origin: origin.retinaPoint, size: size.retinaSize)
    }
}
